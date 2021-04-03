import 'dart:math';

import 'package:learning_flutter/state/admin/adminStore.dart';
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

  
  // AdminStore adminState;
  
  _init(){
    geodesy = Geodesy();
    // adminState = AdminStore.getInstance();
    print('checkpoint service initialized');
  }

  double distanceBetweenCheckpoints(ParseObject checkpoint1, ParseObject checkpoint2){
    ParseGeoPoint coords1 = checkpoint1.get<ParseGeoPoint>('coords');
    ParseGeoPoint coords2 = checkpoint2.get<ParseGeoPoint>('coords');
    
    LatLng pos1 = LatLng(coords1.latitude, coords1.longitude);
    LatLng pos2 = LatLng(coords2.latitude, coords2.longitude);

    return geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
  }

  Future<List<ParseObject>> selectGameCheckPoints(List<ParseObject> alternatives, LatLng mapCenter, {int minDistance = 2000}) {
    print('mapcenter is:');
    print(mapCenter);

    final random = Random();


    // TODO: This can SURELY be optimized!!!!!!!
    // Try at most 4000 times.
    for (var attempt = 0; attempt < 100000; attempt++) {
      List<ParseObject> allCheckpoints = new List<ParseObject>.from(alternatives);
      List<ParseObject> pickedCheckpoints = new List<ParseObject>();
      
      // pick 5 randomly
      for (var i = 0; i < 5; i++) {
        var idx = random.nextInt(allCheckpoints.length);
        pickedCheckpoints.add(allCheckpoints[idx]);
        allCheckpoints.removeAt(idx);
      }

      var success = true;
      //Check so it fullfills requirements!
      for (var outerIdx = 0; outerIdx < pickedCheckpoints.length; outerIdx++) {
        for (var innerIdx = outerIdx + 1; innerIdx < pickedCheckpoints.length; innerIdx++) {
          var checkpoint1 = pickedCheckpoints[outerIdx];
          var checkpoint2 = pickedCheckpoints[innerIdx];

          var geopoint1 = checkpoint1.get<ParseGeoPoint>('coords'); 
          var pos1 = LatLng(geopoint1.latitude, geopoint1.longitude);

          var geopoint2 = checkpoint2.get<ParseGeoPoint>('coords'); 
          var pos2 = LatLng(geopoint2.latitude, geopoint2.longitude);

          var distance = geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
          if(distance < minDistance){
            success = false;
            break;
          }
        }
        if(!success){
          break;
        }
      }

      if(success){
        print('successfully picked valid checkpoints after ${attempt} attempts');
        print('picked checkpoints: ${pickedCheckpoints}');
        return Future.value(pickedCheckpoints);
      }




    }
    // print('tried ${attempt} times');
    return Future.error('failed to randomly pick validated checkpoints');
  }
}