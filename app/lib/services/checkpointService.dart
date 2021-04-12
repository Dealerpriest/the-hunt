import 'dart:developer';
import 'dart:math' as math;

import 'package:learning_flutter/services/parseServerInteractions.dart' as parse;
// import 'package:learning_flutter/state/admin/adminStore.dart';
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
  List<ParseObject> allCheckpoints = new List<ParseObject>();

  
  // AdminStore adminState;
  
  _init(){
    geodesy = Geodesy();
    // adminState = AdminStore.getInstance();
    print('checkpoint service initialized');
  }

  Future<void> fetchAllCheckpoints() async {
    try{

      List<ParseObject> fetchedCheckpoints = await parse.fetchAllCheckpoints();
      if(fetchedCheckpoints == null){
        return;
      }
      this.allCheckpoints = fetchedCheckpoints;
    }catch(err){
      log('error', error: err);
    }
    return;
  }

  double distanceBetweenCheckpoints(ParseObject checkpoint1, ParseObject checkpoint2){
    ParseGeoPoint coords1 = checkpoint1.get<ParseGeoPoint>('coords');
    ParseGeoPoint coords2 = checkpoint2.get<ParseGeoPoint>('coords');
    
    LatLng pos1 = LatLng(coords1.latitude, coords1.longitude);
    LatLng pos2 = LatLng(coords2.latitude, coords2.longitude);

    return geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
  }

  Map touchingAnyCheckpoint(List<Map> alternatives, double minDistance, LatLng pos){
    for (Map checkpoint in alternatives) {
      LatLng checkpointCoord = LatLng(checkpoint['latitude'], checkpoint['longitude']);
      double distance = geodesy.distanceBetweenTwoGeoPoints(pos, checkpointCoord);
      if (distance < minDistance){
        return checkpoint;
      }
    }
    return null;
  }

  Future<List<ParseObject>> selectGameCheckPoints(LatLng mapCenter, {List<ParseObject> alternatives, int minDistance = 2000}) {
    print('mapcenter is:');
    print(mapCenter);

    // TODO: use the mapCenter for restricitng alternatives to circular area
    if(alternatives == null){
      if(this.allCheckpoints.length == 0){
        log('error', error: 'No checkpoints to use for selection process!!! Baling out');
      }
      alternatives = this.allCheckpoints;
    }

    final random = math.Random();


    // TODO: This can SURELY be optimized!!!!!!!
    // Try at most 100000 times.
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