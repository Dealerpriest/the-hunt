import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'map.g.dart';

class Map = _Map with _$Map;

abstract class _Map with Store {
  _Map({this.parent});
  MainStore parent;

  Random rnd = Random();

  static LatLng defaultPos = LatLng(57.708870, 11.974560);

  // @observable
  // ObservableSet<Marker> markers = ObservableSet<Marker>.of([Marker(markerId: MarkerId('marker123'), position: defaultPos)]);

  @computed
  ObservableSet<Marker> get markers {
    return parent.gameSession.locations.map<Marker>((location){
      ParseUser userOfLocation = location.get<ParseUser>('user');
      bool isMe = parent.user.currentUser.objectId == userOfLocation.objectId;
      BitmapDescriptor icon = isMe ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : BitmapDescriptor.defaultMarker;
      ParseGeoPoint geoPoint = location.get<ParseGeoPoint>('coords');
      return Marker(markerId: MarkerId(location.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon);
    }).toSet().asObservable();
  }


  // @action
  // generateSomeMarkers() async {
  //   print('generate markers triggered');
  //   for (var i = 0; i < 20; i++) {
  //     int n = markers.length + i;
  //     String id = "marker-$n";
  //     MarkerId mrkrId = MarkerId(id);
  //     double randomOffsetX = rnd.nextDouble()*0.02 - 0.01;
  //     double randomOffsetY = rnd.nextDouble()*0.02 - 0.01;
  //     Marker marker = Marker(markerId: mrkrId, draggable: false, position: LatLng(defaultPos.latitude + randomOffsetX, defaultPos.longitude+randomOffsetY));

  //     this.markers.add(marker);
  //   }
  // }

  @action
  clearAllMarkers() async {
    this.markers.clear();
  }
  
  
}