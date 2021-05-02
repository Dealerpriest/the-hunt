// Temporary hack so we can use the class name MAP
import 'dart:developer';
// end of hack

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
// import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
// import 'package:geodesy/geodesy.dart' as geo;

part 'chart.g.dart';

// TODO: Rename this class from Map since thats part of dart language.
class Chart = _Chart with _$Chart;

abstract class _Chart with Store {
  _Chart({this.parent});
  MainStore parent;

  

  @computed
  Set<Marker> get touchedCheckpointMarkers {
    var touchedCheckpoints = parent.gameCheckpoints.touchedCheckpoints;
    var touchedMarkers = Set<Marker>();
    if(touchedCheckpoints == null || touchedCheckpoints.length == 0){
      log('error', error: 'failed to get checkpoints from gameCheckpoints store');
    } else{
      touchedMarkers = touchedCheckpoints.map<Marker>((ParseObject checkpoint){
        BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        ParseGeoPoint geoPoint = checkpoint.get<ParseGeoPoint>('coords');

        LatLng coords = LatLng(geoPoint.latitude, geoPoint.longitude);
        return Marker(markerId: MarkerId(checkpoint.objectId), position: coords, icon: icon);
      }).toSet();
    }
    return touchedMarkers;
  }

  @computed
  Set<Marker> get unTouchedCheckpointMarkers {
    var unTouchedCheckpoints = parent.gameCheckpoints.unTouchedCheckpoints;
    var unTouchedMarkers = Set<Marker>();
    if(unTouchedCheckpoints == null || unTouchedCheckpoints.length == 0){
      log('error', error: 'failed to get checkpoints from gameCheckpoints store');
    }else{
      unTouchedMarkers = unTouchedCheckpoints.map<Marker>((ParseObject checkpoint){
        BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
        ParseGeoPoint geoPoint = checkpoint.get<ParseGeoPoint>('coords');

        LatLng coords = LatLng(geoPoint.latitude, geoPoint.longitude);
        return Marker(markerId: MarkerId(checkpoint.objectId), position: coords, icon: icon);
      }).toSet();
    }
    return unTouchedMarkers;

    // return unTouchedMarkers.union(touchedMarkers).asObservable();

    // int id = 3000;
    // return checkpoints.map<Marker>((core.Map checkpoint){
    //   BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    //   LatLng coords = LatLng(checkpoint["coords"]['latitude'], checkpoint['coords']['longitude']);
    //   return Marker(markerId: MarkerId((id++).toString()), position: coords, icon: icon);
    // }).toSet();
  }

  @computed
  Set<Marker> get allCheckpointMarkers {
    return unTouchedCheckpointMarkers.union(touchedCheckpointMarkers);
  }

  @computed
  Set<Marker> get latestHunterMarkers {
    
    return parent.locations.latestHunterLocations.map<Marker>((location){
      // ParseUser userOfLocation = location.get<ParseUser>('user');
      // bool isMe = parent.user.id == userOfLocation.objectId;
      BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      ParseGeoPoint geoPoint = location.get<ParseGeoPoint>('coords');
      return Marker(markerId: MarkerId(location.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon);
    }).toSet();
  }

  @computed
  Set<Marker> get revealedPreyMarkers {
    return parent.locations.revealedPreyLocations.map<Marker>((location){
      ParseUser userOfLocation = location.get<ParseUser>('user');
      bool isMe = parent.user.id == userOfLocation.objectId;
      BitmapDescriptor icon = isMe ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : BitmapDescriptor.defaultMarker;
      ParseGeoPoint geoPoint = location.get<ParseGeoPoint>('coords');
      return Marker(markerId: MarkerId(location.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon);
    }).toSet();
  }

  @computed
  Set<Marker> get markers {
    if(parent.gameSession.isPrey){
      return allCheckpointMarkers.union(revealedPreyMarkers);
    }
    return latestHunterMarkers.union(revealedPreyMarkers);
    // var checkpoints = parent.gameSession.parseGameSession.get<List<core.Map>>('checkpoints');
    // if(checkpoints == null || checkpoints.length == 0){
    //   log('error', error: 'failed to extract checkpoints from gamesession parseObject');
    //   return Set<Marker>();
    // }
    // int id = 3000;
    // return checkpoints.map<Marker>((core.Map checkpoint){
    //   BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    //   LatLng coords = LatLng(checkpoint["coords"]['latitude'], checkpoint['coords']['longitude']);
    //   return Marker(markerId: MarkerId((id++).toString()), position: coords, icon: icon);
    // }).toSet();

    // if(revealedPreyLocations == null || revealedPreyLocations.length == 0){
    //   return ObservableSet<Marker>();
    // }
    // return revealedPreyLocations.map<Marker>((location){
    //   ParseUser userOfLocation = location.get<ParseUser>('user');
    //   bool isMe = parent.user.id == userOfLocation.objectId;
    //   BitmapDescriptor icon = isMe ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : BitmapDescriptor.defaultMarker;
    //   ParseGeoPoint geoPoint = location.get<ParseGeoPoint>('coords');
    //   return Marker(markerId: MarkerId(location.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon);
    // }).toSet().asObservable();
  }

}