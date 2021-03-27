import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/services/revealService.dart';
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
  ObservableList<ParseObject> get allMyLocations {
    return locations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.user.currentUser.objectId;
    }).toList().asObservable();
  }
  
  @computed
  ObservableList<ParseObject> get allPreyLocations {
    return locations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.gameSession.prey.objectId;
    }).toList().asObservable();
  }

  @computed
  ParseObject get latestPreyLocation {
    return allPreyLocations.last;
  }

  // TODO: WE probably not want to recalculate this every second.... (because one used observable is a stream)
  @computed
  ObservableList<ParseObject> get revealedPreyLocations {
    return allPreyLocations.where((location){
      var untilReveal = parent.gameSession.durationUntilNextReveal;
      bool revealed = location.get<bool>('revealed');
      bool isNotYetTriggered = location.createdAt.isAfter(RevealService().latestRevealMoment);
      return revealed && !isNotYetTriggered;
    }).toList().asObservable();
  }

  @computed
  ObservableList<ParseObject> get pendingPreyLocations {
    return allPreyLocations.where((location){
      var untilReveal = parent.gameSession.durationUntilNextReveal;
      bool revealed = location.get<bool>('revealed');
      bool isNotYetTriggered = location.createdAt.isAfter(RevealService().latestRevealMoment);
      return revealed && isNotYetTriggered;
    }).toList().asObservable();
  }

  @computed
  ParseObject get latestRevealedPreyLocation {
    return revealedPreyLocations.last;
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
  clearAllLocations() async {
    this.locations.clear();
  }

  // @action
  // revealMostRecentLocation() async {
    //   updateRevealStateForLocation(allMyLocations.last, true);
  // }

  @action
  fetchAllLocations() async {
    print('fetching all locations');
    var list = await fetchLocationsForGamesession(parent.gameSession.parseGameSession);
    // print(list);
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
      bool revealed = value.get<bool>('revealed');
      print("revealed: ${revealed}");
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