import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:geodesy/geodesy.dart' as geo;

part 'locations.g.dart';

class Locations = _Locations with _$Locations;


Subscription locationSubscription;

abstract class _Locations with Store {
  _Locations({this.parent});
  MainStore parent;

  geo.Geodesy _geodesy = geo.Geodesy();

  @observable
  ObservableList<ParseObject> allLocations = new ObservableList<ParseObject>();

  @observable
  int onLocationChangedCounter = 0;

  @computed
  List<ParseObject> get allMyLocations {
    print('recalculating allMyLocations');
    return allLocations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.user.id;
    }).toList();
  }

  @computed
  Duration get durationBetweenMyLatestLocations {
    if(allMyLocations.length < 2){
      return Duration.zero;
    }
    var last = allMyLocations.last;
    var previous = allMyLocations[allMyLocations.length-2];
    return last.createdAt.difference(previous.createdAt);
  }
  
  @computed
  List<ParseObject> get allPreyLocations {
    // print('recalculating allPreyLocations');
    return allLocations.where((location) {
      return location.get<ParseUser>('user').objectId == parent.gameSession.prey.objectId;
    }).toList();
  }

  @computed
  List<ParseObject> get allHunterLocations {
    // print('recalculating allhunterlocations');
    return allLocations.where((location) => location.get<ParseUser>('user').objectId != parent.gameSession.prey.objectId).toList();
  }


  //TODO: We can't do it like this! We need to actually build some data object where players' locations are already separated. Not recalculate it as a computed!
  // I think this shit is O(n2) or some other really bad number
  @computed
  Set<ParseObject> get latestHunterLocations {
    // print('recalculating latest hunter locations');
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
    // print('recalculating revealedPreyLocations');

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

  @action
  clearAllLocations() async {
    this.allLocations.clear();
  }

  @action
  fetchAllLocations() async {
    print('fetching all locations');
    var list = await fetchLocationsForGamesession(parent.gameSession.parseGameSession);
    // print(list);
    if(list != null){
      this.allLocations = list.asObservable();
    }
  }

  bool isPreyLocation(ParseObject location){
    String userId = location.get<ParseUser>('user').objectId;
    return parent.gameSession.prey.objectId == userId;
  }

  Future<void> startLocationSubscription() async {
    print('STARTING LOCATION SUBSCRIPTION');
    if(locationSubscription != null){
      stopSubscription(locationSubscription);
    }
    locationSubscription = await subscribeToLocationsForGamesession(this.parent.gameSession.parseGameSession);
    locationSubscription.on(LiveQueryEvent.create, (ParseObject location) async {
      print('new location received from parse!!');
      // bool revealed = location.get<bool>('revealed');
      // print("revealed: ${revealed}");
      // if(isPreyLocation(location)){
      //   List<dynamic> touchList = _touchingHunterLocations(location);
      //   print('touching hunterLocations:');
      //   print(touchList);
      // }
      
      this.allLocations.add(location);
    });
    locationSubscription.on(LiveQueryEvent.update, (value) async {
      print('updated location received from parse!!');
      print(value);
      ParseObject updatedLoc = value as ParseObject;
      var idx = allLocations.indexWhere((location) => updatedLoc.objectId == location.objectId);
      if(idx > 0){
        allLocations[idx] = updatedLoc;
      }
    });
  }

  List<ParseObject> _touchingHunterLocations(ParseObject newLocation) {
    var newCoords = newLocation.get<ParseGeoPoint>('coords');
    return this.allHunterLocations.where((ParseObject location){
      Duration timeDifference = newLocation.createdAt.difference(location.createdAt);
      if(timeDifference > Duration(seconds: 5)){
        return false;
      }

      var coords = location.get<ParseGeoPoint>('coords');

      geo.LatLng pos1 = geo.LatLng(newCoords.latitude, newCoords.longitude);
      geo.LatLng pos2 = geo.LatLng(coords.latitude, coords.longitude);

      
      var distance = _geodesy.distanceBetweenTwoGeoPoints(pos1, pos2);
      return distance < 10;
    }).toList();
  }
}