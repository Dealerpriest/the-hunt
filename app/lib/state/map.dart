// Temporary hack so we can use the class name MAP
import 'dart:core' hide Map;
import 'dart:core' as core show Map;
import 'dart:developer';
// end of hack

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/state/admin/checkpoints.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'map.g.dart';

// TODO: Rename this class from Map since thats part of dart language.
class Map = _Map with _$Map;

Subscription locationSubscription;
abstract class _Map with Store {
  _Map({this.parent});
  MainStore parent;

  @observable
  ObservableList<ParseObject> locations = new ObservableList<ParseObject>();

  @computed
  ObservableList<ParseObject> get allMyLocations {
    print('recalculating allMyLocations');
    return locations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.user.id;
    }).toList().asObservable();
  }
  
  @computed
  ObservableList<ParseObject> get allPreyLocations {
    print('recalculating allPreyLocations');
    return locations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.gameSession.prey.objectId;
    }).toList().asObservable();
  }

  @computed
  ParseObject get latestPreyLocation {
    return allPreyLocations.last;
  }

  @computed
  ObservableList<ParseObject> get revealedPreyLocations {
    print('recalculating revealedPreyLocations');

    var locations = parent.revealMoments.pastRevealMoments.map((DateTime revealMoment) {
      return allPreyLocations.lastWhere((ParseObject preyLocation){
        return preyLocation.createdAt.isBefore(revealMoment);
      });
    });
    
    return locations.toList().asObservable();
  }

  // @computed
  // ObservableList<ParseObject> get pendingPreyLocations {
  //   return allPreyLocations.where((location){
  //     bool revealed = location.get<bool>('revealed');
  //     bool isNotYetTriggered = true;
  //     try{
  //       // bool isNotYetTriggered = RevealService().latestRevealMoment == null || location.createdAt.isAfter(RevealService().latestRevealMoment);
  //       isNotYetTriggered = parent.revealMoments.latestRevealMoment == null || location.createdAt.isAfter(parent.revealMoments.latestRevealMoment);
  //     }catch(err){
  //       isNotYetTriggered = true;
  //     }
  //     return revealed && isNotYetTriggered;
  //   }).toList().asObservable();
  // }

  @computed
  ParseObject get latestRevealedPreyLocation {
    return revealedPreyLocations.last;
  }

  @computed
  Set<Marker> get checkpointMarkers {
    List<core.Map> checkpoints = parent.gameSession.checkpoints;
    if(checkpoints == null || checkpoints.length == 0){
      log('error', error: 'failed to extract checkpoints from gamesession parseObject');
      return Set<Marker>();
    }
    int id = 3000;
    return checkpoints.map<Marker>((core.Map checkpoint){
      BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      LatLng coords = LatLng(checkpoint["coords"]['latitude'], checkpoint['coords']['longitude']);
      return Marker(markerId: MarkerId((id++).toString()), position: coords, icon: icon);
    }).toSet();
  }

  @computed
  Set<Marker> get revealedPreyMarkers {
    return revealedPreyLocations.map<Marker>((location){
      ParseUser userOfLocation = location.get<ParseUser>('user');
      bool isMe = parent.user.id == userOfLocation.objectId;
      BitmapDescriptor icon = isMe ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : BitmapDescriptor.defaultMarker;
      ParseGeoPoint geoPoint = location.get<ParseGeoPoint>('coords');
      return Marker(markerId: MarkerId(location.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon);
    }).toSet();
  }

  @computed
  Set<Marker> get markers {
    return checkpointMarkers.union(revealedPreyMarkers);
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