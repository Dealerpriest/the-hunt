import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'map.g.dart';

class Map = _Map with _$Map;

Subscription locationSubscription;
abstract class _Map with Store {
  _Map({this.parent});
  MainStore parent;

  Random rnd = Random();

  static LatLng defaultPos = LatLng(57.708870, 11.974560);

  @observable
  ObservableList<ParseObject> locations = new ObservableList<ParseObject>();

  @computed
  ObservableList<ParseObject> get myLocations {
    return locations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.user.currentUser.objectId;
    }).toList().asObservable();
  }
  
  @computed
  ObservableList<ParseObject> get preyLocations {
    return locations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.gameSession.prey.objectId;
    }).toList().asObservable();
  }

  ObservableList<ParseObject> get revealedPreyLocations {
    return preyLocations.where((location) => location.get<bool>('revealed')).toList().asObservable();
  }

  @computed
  ObservableSet<Marker> get markers {
    return revealedPreyLocations.map<Marker>((location){
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

  @action
  clearAllLocations() async {
    this.locations.clear();
  }

  @action
  revealMostRecentLocation() async {
    updateRevealStateForLocation(myLocations.last, true);
  }

  @action
  fetchAllLocations() async {
    print('fetching all locations');
    var list = await fetchLocationsForGamesession(parent.gameSession.parseGameSession);
    print(list);
    if(list != null){
      this.locations = list.asObservable();
    }
  }

  Future<void> startLocationSubscription() async {
    print('STARTING LOCATION SUBSCRIPTION');
    if(locationSubscription != null){
      stopSubscription(locationSubscription);
    }
    locationSubscription = await subscribeToLocationsForGamesession(this.parent.gameSession.parseGameSession);
    locationSubscription.on(LiveQueryEvent.create, (value) async {
      print('new location received from parse!!');
      this.locations.add(value as ParseObject);
    });
    locationSubscription.on(LiveQueryEvent.update, (value) async {
      print('updated location received from parse!!');
      print(value);
      ParseObject updatedLoc = value as ParseObject;
      var idx = locations.indexWhere((location) => updatedLoc.objectId == location.objectId);
      if(idx > 0){
        locations[idx] = updatedLoc;
      }
    });
  }
  
  
}