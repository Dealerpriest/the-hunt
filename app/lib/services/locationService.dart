import 'dart:async';
import 'dart:developer';

import 'package:learning_flutter/services/checkpointService.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import '../state/mainStore.dart';
import './revealService.dart';
import 'package:location/location.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:geodesy/geodesy.dart' as geo;
class LocationService {
  /// SINGLETON PATTERN
  static LocationService _instance;
  

  LocationService._internal(){
    this._init();
  }

  factory LocationService() {
    if (_instance == null) {
      _instance = LocationService._internal();
    }
    return _instance;
  }
  //// END SINGLETON PATTERN

  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  StreamSubscription _locationStreamSubscription = null;
  bool _streamStarted = false;
  Duration _interval = Duration(seconds: 10);
  LocationAccuracy _accuracy = LocationAccuracy.high;

  DateTime _lastUsedRevealMoment = DateTime.now();

  _init() async {
    
    _location = new Location();

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.changeSettings(accuracy: _accuracy, interval: _interval.inMilliseconds);
    _location.enableBackgroundMode(enable: true);
  }

  Future<LocationData> getCurrentLocation() {
    return _location.getLocation();
  }

  void set locationInterval(Duration interval) {
    _interval = interval;
    _location.changeSettings(interval: _interval.inMilliseconds);
  }

  Duration get locationInterval {
    return _interval;
  }

  stopStream() async {
    if(_locationStreamSubscription == null){
      print('tried to stop locationStreamSubscripion but no streamSubscription found.');
      _streamStarted = false;
      return;
    }
    await _locationStreamSubscription.cancel();
    _streamStarted = false;
  }

  startStream(ParseObject gameSession, ParseUser user){
    if(_streamStarted){
      log('error:', error: 'Location stream already started!');
      return;
    }
    // TODO: We seem to end up with many subscriptions when doing hot reloading.
    // Could we somehow make sure we only have one stream running at the time?
    _locationStreamSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      print('location updated');
      // print(currentLocation);
      // print('shouldReveal:  ${_shouldBeRevealed()}');
      var shouldReveal = _shouldBeRevealed(_lastUsedRevealMoment);
      if(shouldReveal){
        print('PLAY SOUND!!!!');
        // _lastUsedRevealMoment = RevealService().nextRevealMoment;
      }
      sendLocationToParse(currentLocation, gameSession, user);

      try {
        print('hello');
        var checkpoints = MainStore.getInstance().gameSession.checkpoints;
        print(checkpoints);
        geo.LatLng currentPos = geo.LatLng(currentLocation.latitude, currentLocation.longitude);
        var checkPointsData = CheckpointService().checkCheckpoint(checkpoints, 500, currentPos);
        if(checkPointsData != null){
          bool touched = checkPointsData.any((Map data){
              print(data['touching']);
              return data['touching'] == true;
            });
          if(touched){
            print('CHECKPOINT TOUCHED!!!!');
          }
          print('TouchedCheckpoint is: ${checkPointsData}');
        }

      } catch(err) {
        log('error', error: err);
      }
    });
    _streamStarted = true;
    print('location stream started!!!');
  }

  bool _shouldBeRevealed(DateTime lastUsedReveal){
    // Don't reveal hunters
    if(MainStore.getInstance().gameSession.isHunter){
      return false;
    }

    // await MainStore.getInstance().gameSession.currentDateEverySecond.
    DateTime now = DateTime.now();
    DateTime nextReveal = RevealService().nextRevealMomentRealTime;
    if(nextReveal == null){
      log('error', error: 'couldnt get nextRevealMomentRealTime');
      return true;
    }
    Duration untilNextReveal = nextReveal.difference(now);
    
    print('now: ${now}');
    print('nextReveal: ${nextReveal}');
    print('untilNextReveal: ${untilNextReveal.inSeconds}');
    print('interval: ${_interval.inSeconds}');
    if(untilNextReveal < _interval){
      // Only one reveal per revealMoment!
      // if(nextReveal.isAtSameMomentAs(lastUsedReveal)){
      //   print('already revealed one for the picked revealMoment');
      //   return false;
      // }
      // print('gonna reveal this location');
      return true;
    }
    return false;
  }
}