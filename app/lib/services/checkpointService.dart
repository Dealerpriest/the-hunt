

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'package:geodesy/geodesy.dart';

class CheckpointService {
  /// SINGLETON PATTERN
  static CheckpointService _instance;
  

  CheckpointService._internal(){
    this._init();
  }

  factory CheckpointService() {
    if (_instance == null) {
      _instance = CheckpointService._internal();
    }
    return _instance;
  }
  //// END SINGLETON PATTERN

  Geodesy geodesy;
  
  _init(){
    geodesy = Geodesy();
    print('checkpoint service initialized');
  }

  double distanceBetweenCheckpoints(ParseObject checkpoint1, ParseObject checkpoint2){
    ParseGeoPoint coords1 = checkpoint1.get<ParseGeoPoint>('coords');
    ParseGeoPoint coords2 = checkpoint2.get<ParseGeoPoint>('coords');
    
    LatLng pos1 = LatLng(coords1.latitude, coords1.longitude);
    LatLng pos2 = LatLng(coords2.latitude, coords2.longitude);

    return geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
  }

  Future<void> createGameCheckpoints() {
    return null;
  }
}