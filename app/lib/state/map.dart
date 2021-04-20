// Temporary hack so we can use the class name MAP
import 'dart:core' hide Map;
import 'dart:core' as core show Map;
import 'dart:developer';
// end of hack

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:geodesy/geodesy.dart' as geo;

part 'map.g.dart';

// TODO: Rename this class from Map since thats part of dart language.
class Map = _Map with _$Map;

Subscription locationSubscription;
abstract class _Map with Store {
  _Map({this.parent});
  MainStore parent;

  geo.Geodesy _geodesy = geo.Geodesy();

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
  List<ParseObject> get allHunterLocations {
    print('recalculating allhunterlocations');
    return locations.where((location) => location.get<ParseUser>('user').objectId != parent.gameSession.prey.objectId).toList();
  }


  //TODO: We can't do it like this! We need to actually build some data object where players' locations are already separated. Not recalculate it as a computed!
  // I think this shit is O(n2) or some other really bad number
  @computed
  Set<ParseObject> get latestHunterLocations {
    print('recalculating latest hunter locations');
    Set<ParseObject> theSet = new Set<ParseObject>();
    allHunterLocations.forEach((newCandidate){
      ParseObject previousCandidate = theSet.firstWhere((location){
        return newCandidate.get<ParseUser>('user').objectId == location.get<ParseUser>('user').objectId;
      }, orElse: () => null);
      if(previousCandidate == null){
        theSet.add(newCandidate);
      }else if(newCandidate.createdAt.isAfter(previousCandidate.createdAt)){
        theSet.remove(previousCandidate);
        theSet.add(newCandidate);
      }
    });
    // print('nr of locations: ${theSet.length}');
    return theSet;
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

  @computed
  ParseObject get latestRevealedPreyLocation {
    return revealedPreyLocations.last;
  }

  @computed
  ObservableSet<Marker> get checkpointMarkers {
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

    return unTouchedMarkers.union(touchedMarkers).asObservable();

    // int id = 3000;
    // return checkpoints.map<Marker>((core.Map checkpoint){
    //   BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    //   LatLng coords = LatLng(checkpoint["coords"]['latitude'], checkpoint['coords']['longitude']);
    //   return Marker(markerId: MarkerId((id++).toString()), position: coords, icon: icon);
    // }).toSet();
  }

  @computed
  Set<Marker> get latestHunterMarkers {
    
    return latestHunterLocations.map<Marker>((location){
      // ParseUser userOfLocation = location.get<ParseUser>('user');
      // bool isMe = parent.user.id == userOfLocation.objectId;
      BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      ParseGeoPoint geoPoint = location.get<ParseGeoPoint>('coords');
      return Marker(markerId: MarkerId(location.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon);
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
    if(parent.gameSession.isPrey){
      return checkpointMarkers.union(revealedPreyMarkers);
    }
    return latestHunterMarkers; //.union(latestHunterMarkers);
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

  @action
  clearAllLocations() async {
    this.locations.clear();
  }

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
    locationSubscription.on(LiveQueryEvent.create, (ParseObject value) async {
      print('new location received from parse!!');
      // bool revealed = value.get<bool>('revealed');
      // print("revealed: ${revealed}");
      
      this.locations.add(value);
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

  List<ParseObject> touchingLocations(ParseObject newLocation) {
    var newCoords = newLocation.get<ParseGeoPoint>('coords');
    this.locations.where((ParseObject location){
      Duration timeDifference = newLocation.createdAt.difference(location.createdAt);
      if(timeDifference > Duration(seconds: 2)){
        return false;
      }

      var coords = location.get<ParseGeoPoint>('coords');

      geo.LatLng pos1 = geo.LatLng(newCoords.latitude, newCoords.longitude);
      geo.LatLng pos2 = geo.LatLng(coords.latitude, coords.longitude);

      
      var distance = _geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
      return distance < 10;
    });
  }

}