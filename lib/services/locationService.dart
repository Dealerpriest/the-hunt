import 'dart:developer';

import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:location/location.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';



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
  bool _streamStarted = false;

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

    _location.changeSettings(accuracy: LocationAccuracy.high, interval: 10000);
    _location.enableBackgroundMode(enable: true);
  }

  startStream(ParseObject gameSession, ParseUser user){
    if(_streamStarted){
      log('error:', error: 'Location stream already started!');
      return;
    }
    _location.onLocationChanged.listen((LocationData currentLocation) {
      print('location updated');
      // print(currentLocation);
      sendLocationToParse(currentLocation, gameSession, user);
    });
    _streamStarted = true;
    print('location stream started!!!');
  }


  // _locationData = await location.getLocation();

}