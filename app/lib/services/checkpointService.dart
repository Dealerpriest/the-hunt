import 'dart:developer';
import 'dart:math' as math;

import 'package:learning_flutter/services/parseServerInteractions.dart' as parse;
// import 'package:learning_flutter/state/admin/adminStore.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

// import 'package:geodesy/geodesy.dart';
import 'package:latlong2/latlong.dart' as Geo;

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

  // Geodesy geodesy;
  Geo.Distance _distance;
  List<ParseObject> allCheckpoints = new List<ParseObject>();

  
  // AdminStore adminState;
  
  _init(){
    // geodesy = Geodesy();
    _distance = new Geo.Distance();
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
    
    Geo.LatLng pos1 = Geo.LatLng(coords1.latitude, coords1.longitude);
    Geo.LatLng pos2 = Geo.LatLng(coords2.latitude, coords2.longitude);

    return _distance(pos1, pos2);
    // return geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
  }

  List<Map> checkCheckpoints(Geo.LatLng pos, List<ParseObject> alternatives, { double minDistance = 10 }){
    return alternatives.map((ParseObject checkpoint) {
      ParseGeoPoint coords = checkpoint.get<ParseGeoPoint>('coords');
      Geo.LatLng checkpointCoord = Geo.LatLng(coords.latitude, coords.longitude);
      // double _distance = geodesy.distanceBetweenTwoGeoPoints(pos, checkpointCoord);
      double distance = _distance(pos, checkpointCoord);

      return {
        'objectId': checkpoint.objectId,
        'coords': coords,
        'distance': distance,
        'touching': distance < minDistance
      };
    }).toList();
  }

  Future<List<ParseObject>> selectGameCheckPoints(Geo.LatLng mapCenter, {List<ParseObject> alternatives, int minDistance = 2000}) {
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

    // TESTING CHECKPOINTS:
    List<String> testCheckpointsIds = [
      'KyHXJ0tIp4',
      'xcB82DMtRl',
      'OaF2lND21i',
      'FIp7yyDWZl',
      'GGALalOKuR',
      'ase7ndPIMI',
      'FUvVDg6dG5',
      'bBw337m84R',
      'Znh4Xf0L3f'
    ];

    var pickedCheckpoints = allCheckpoints.where((checkpoint)=> testCheckpointsIds.any((id) => id == checkpoint.objectId)).toList();
    return Future.value(pickedCheckpoints);

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
          var pos1 = Geo.LatLng(geopoint1.latitude, geopoint1.longitude);

          var geopoint2 = checkpoint2.get<ParseGeoPoint>('coords'); 
          var pos2 = Geo.LatLng(geopoint2.latitude, geopoint2.longitude);

          // var distance = geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
          var distance = _distance(pos1, pos2);
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