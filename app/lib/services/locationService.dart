import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:learning_flutter/services/checkpointService.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import '../state/mainStore.dart';
import './revealService.dart';
import 'package:location/location.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
// import 'package:geodesy/geodesy.dart' as geo;
import 'package:latlong2/latlong.dart' as Geo;
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
  final Duration _fastInterval = Duration(milliseconds: 1000);
  final Duration _slowInterval = Duration(milliseconds: 30000);
  Duration _interval = Duration(milliseconds: 30000);
  LocationAccuracy _accuracy = LocationAccuracy.high;

  Geo.Distance _distance;

  DateTime _onLocationUpdateTS = DateTime.now();
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

    _location.changeSettings(accuracy: _accuracy, interval: _interval.inMilliseconds, distanceFilter: 0);
    _location.enableBackgroundMode(enable: true);

    _distance = Geo.Distance();
  }

  Future<LocationData> getCurrentLocation() {
    return _location.getLocation();
  }

  void set locationInterval(Duration interval) {
    print('CHANGING LOCATION INTERVAL!!!!');
    _interval = interval;
    _location.changeSettings(interval: _interval.inMilliseconds, distanceFilter: 0).then((value) => print('changeSettings result: ${value}'));
  }

  Duration get locationInterval {
    return _interval;
  }

  setToFastInterval(){
    if(locationInterval.compareTo(_fastInterval) != 0) {
      locationInterval = _fastInterval;
    }
  }

  setToSlowInterval(){
    if(locationInterval.compareTo(_slowInterval) != 0) {
      locationInterval = _slowInterval;
    }
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

    // TODO: We seem to end up with many subscriptions when doing hot restart.
    // Could we somehow make sure we only have one stream running at the time?
    _locationStreamSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      print('gps location updated');
      print('configured interval: ${locationInterval.inMilliseconds}ms');
      Duration realInterval = DateTime.now().difference(_onLocationUpdateTS);
      _onLocationUpdateTS = DateTime.now();
      print('real interval: ${realInterval.inSeconds}');

      MainStore.getInstance().locations.onLocationChangedCounter++;
      // print(currentLocation);
      // print('shouldReveal:  ${_shouldBeRevealed()}');
      


      var shouldReveal = _shouldBeRevealed(_lastUsedRevealMoment);
      if(shouldReveal){
        print('PLAY REVEAL SOUND!!!!');
        // _lastUsedRevealMoment = RevealService().nextRevealMoment;
      }
      // sendLocationToParse(currentLocation, gameSession, user);

      // _checkDistances(currentLocation);
    });
    _streamStarted = true;
    print('location stream started!!!');
  }

  // TODO: Verify whether we need to refetch all the relevant locations from parse.
  // Ooooor. Can we trust that our live query is continuously updating the mobx store when phone is pocketed?
  // Oooor. Can we do best effort here and verify with cloud function afterSave for each incoming location to parse?
  void _checkDistances(LocationData currentLocation){
    try {
        // print('hello');
        var now = DateTime.now();
        Geo.LatLng currentPos = Geo.LatLng(currentLocation.latitude, currentLocation.longitude);

        var appState = MainStore.getInstance();
        var parseCheckpoints = appState.gameCheckpoints.parseGameCheckpoints;
        var hunterLocations = appState.locations.latestHunterLocations;
        ParseObject closestHunterLocation = null;
        double closestHunterDistance = double.infinity;
        ParseObject closestCheckpoint = null;
        double closestCheckpointDistance = double.infinity;
        
        hunterLocations.forEach((ParseObject hunterLocation) {
          ParseGeoPoint coords = hunterLocation.get<ParseGeoPoint>('coords');
          Geo.LatLng hunterCoords = Geo.LatLng(coords.latitude, coords.longitude);
          // double distance = _geodesy.distanceBetweenTwoGeoPoints(currentPos, hunterCoords);
          var distance = _distance(currentPos, hunterCoords);

          if(distance < closestHunterDistance) {
            closestHunterLocation = hunterLocation;
            closestHunterDistance = distance;
          }

          Duration timeDifference = now.difference(hunterLocation.createdAt);
          print('hunter prey time difference: ${timeDifference.inSeconds}');
          if(timeDifference < Duration(seconds: 5) && closestHunterDistance < 50){
            print('CATCHED!!!!');
            ParseUser hunter = closestHunterLocation.get<ParseUser>('user');
            catchPrey(appState.gameSession.parseGameSession, hunter);
          }

        });


        print('parseCheckPoints: ${parseCheckpoints}');
        parseCheckpoints.forEach((ParseObject checkpoint){
          ParseGeoPoint coords = checkpoint.get<ParseGeoPoint>('coords');
          Geo.LatLng checkpointCoord = Geo.LatLng(coords.latitude, coords.longitude);
          double distance =_distance(currentPos, checkpointCoord);

          if(distance < closestCheckpointDistance){
            closestCheckpoint = checkpoint;
            closestCheckpointDistance = distance;
          }
        });

        if(closestCheckpointDistance < 5){
          print('touching checkpoint: ${closestCheckpoint}');
          appState.gameCheckpoints.touchCheckpoint(closestCheckpoint.objectId);
        }

        double closestThing = math.min(closestHunterDistance, closestCheckpointDistance);

        // if(closestThing < 200){
        //   if(this.locationInterval > Duration(seconds: 5))
        //     this.locationInterval = Duration(seconds: 1);
        // }else{
        //   if(this.locationInterval < Duration(seconds: 5))
        //     this.locationInterval = Duration(seconds: 30);
        // }

      } catch(err) {
        log('error', error: err);
      }
  }

  // bool _isACatch()

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
    
    // print('now: ${now}');
    // print('nextReveal: ${nextReveal}');
    // print('untilNextReveal: ${untilNextReveal.inSeconds}');
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