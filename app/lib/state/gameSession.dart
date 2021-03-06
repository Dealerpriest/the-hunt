import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:learning_flutter/services/checkpointService.dart';
import 'package:learning_flutter/services/locationService.dart' as loc;
// import 'package:geodesy/geodesy.dart' as geo;
import 'package:latlong2/latlong.dart' as Geo;
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

// import '../services/revealService.dart';

part 'gameSession.g.dart';

class GameSession = _GameSession with _$GameSession;

Subscription gameSessionSubscription;

abstract class _GameSession with Store {
  _GameSession({this.parent});

  MainStore parent;


  // service and other dependencies
  CheckpointService _checkpointService = CheckpointService();
  loc.LocationService _locationService = loc.LocationService();




  // ReactionDisposer _disposeStartReaction;
  // ReactionDisposer _disposeRevealTimerReaction;
  // 
  @observable
  int nrOfcheckpointTouches = 0;

  @observable
  bool sessionNameAvailable = false;

  @observable
  ParseObject parseGameSession;

  // @computed
  // List<Map> get checkpoints {
  //   print('GETTING CHECKPOINTS FROM PARSE GAMESESSION:');
  //   try{

  //     List<dynamic> checkpoints = this.parseGameSession.get('checkpoints');
  //     List<Map> chkpts = checkpoints.cast<Map>();
  //     print(chkpts);
  //     print(chkpts.runtimeType);
  //     return chkpts;
  //     // return new List<Map>();
  //   }catch(err) {
  //     log('error', error: err);
  //     return new List<Map>();
  //   }
  // }

  @observable
  ObservableStream<DateTime> currentDateEverySecond = Stream.value(DateTime.now()).asObservable();

  @computed
  Duration get elapsedGameTime {
    return this.currentDateEverySecond.value.difference(parseGameSession.get<DateTime>('startedAt', defaultValue: DateTime.now()));
  }
  
  // @computed
  // Duration get durationUntilNextReveal {
  //   try {
  //     int elapsed = elapsedGameTime.value.inSeconds;
  //     Duration untilReveal = RevealService().untilNextRevealMoment;
  //     if(untilReveal == null){
  //       return Duration.zero;
  //     }
  //     return untilReveal;
  //     // DateTime now = DateTime.now();
  //     // DateTime nextReveal = revealMoments.firstWhere((revealMoment) => now.isBefore(revealMoment), orElse: () =>  DateTime.now());
  //     // return nextReveal.difference(now);
  //   } catch (err){
  //     log('error', error: err);
  //     return Duration.zero;
  //   }
  // }

  // int _revealTimerCounter = 0;

  // @computed
  // int get nrOfRevealsFromTimer {
  //   if(this.durationUntilNextReveal.inSeconds == 0){
  //     _revealTimerCounter++;
  //   }
  //   return _revealTimerCounter;
  // }

  @computed
  String get sessionName {
    // if(parseGameSession?.get('name')??true){
    //   print('invalid game session when calcing computed property');
    //   return '';
    // }
    var name = parseGameSession?.get('name')??'';
    // print('game Session name: '+ name);
    return name;
  }

  @computed
  DateTime get gameStartTime {
    if(parseGameSession == null){
      return null;
    }
    return parseGameSession.get<DateTime>('startedAt', defaultValue: null);
  }

  @computed get catcher {
    if(parseGameSession == null){
      return null;
    }
    var pointer = parseGameSession.get<ParseUser>('preyCatchedBy', defaultValue: null);
    if(pointer == null){
      return null;
    }
    return parsePlayers.firstWhere((player) => player.objectId == pointer.objectId);
  }

  @computed get catcherName {
    if(catcher == null){
      return '';
    }
    return catcher.get<String>('playerName');
  }

  @computed get gameFinished {
    if(catcher == null){
      return false;
    }else {
      return true;
    }
  }

  @computed get gameStarted {
    return gameStartTime != null;
  }

  @computed
  ParseUser get gameHost {
    if(parseGameSession == null || !parseGameSession.containsKey('owner'))
      return null;
    return parseGameSession.get<ParseUser>('owner');
  }

  @computed
  bool get isGameHost {
    return parent.user.id == this.gameHost?.objectId;
  }

  @observable
  ObservableList<ParseUser> parsePlayers = new ObservableList<ParseUser>();

  @computed
  List<String> get allPlayerNames{
    if(parsePlayers?.isEmpty??true){
      return List<String>();
    }
  //  return List<String>();
    var all =  this.parsePlayers.toList().map<String>((user){
      var name = user.get<String>('playerName');
      print(name);
      return name;
    }).toList();
    return all;
  }

  @computed
  ParseUser get prey {
    if(parseGameSession == null || !parseGameSession.containsKey('prey'))
      return null;
    return this.parseGameSession.get('prey') as ParseUser;
  }

  @computed
  bool get isPrey {
    return parent.user.id == this.prey.objectId;
  }

  @computed
  bool get isHunter {
    return !this.isPrey;
  }

  @action
  Future<void> setAdmin (ParseUser user){
    print('Calling placeholder setAdmin function');
    print('supposed to set this user as admin:' + user.toString());
    return Future.value();
    // TODO: actually implement this. remember to also remove user from participants.
  }

  @action
  Future<void> setPrey (ParseUser user) {
    // print(user.runtimeType );
    return setPreyForGameSession(this.parseGameSession, user);
  }

  @action
  checkSessionNameAvailable(String sessionName) async {
    bool available = await isGameNameAvailable(sessionName);
    sessionNameAvailable = available;
  }

  @action
  Future<void> createGame(sessionName, playerName) async{
    bool available = await isGameNameAvailable(sessionName);
    if(!available){
      return Future.error("Problem. Game name was already in use");
    }
    ParseGeoPoint startLocation;
    try{
      var location = await _locationService.getCurrentLocation();
      startLocation = ParseGeoPoint(latitude: location.latitude, longitude: location.longitude);
    }catch(err){
      return Future.error('couldnt get current location. need that to setup game');
    }
    try {
      this.parseGameSession = await createGameSession(sessionName, playerName, startLocation);
      await _checkpointService.fetchAllCheckpoints();
      Geo.LatLng center = Geo.LatLng(startLocation.latitude, startLocation.longitude);
      var pickedParseCheckpoints = await _checkpointService.selectGameCheckPoints(center);
      List<ParseObject> parseGameCheckpoints = await setCheckpointsForGameSession(this.parseGameSession, pickedParseCheckpoints);
      parent.gameCheckpoints.setGameCheckpoints(parseGameCheckpoints);
      fetchPlayers();
      _startGameSubscription();
      // await joinGameSession(this.parseGameSession, playerName);
      setupGameStartedReaction();
      return Future.value();
    }catch (err){
      Future.error(err);
    }
  }

  @action
  Future<void> joinGame(sessionName, playerName) async {
    this.parseGameSession = await joinGameSessionByName(sessionName, playerName);
    await _startGameSubscription();
    await this.fetchPlayers();
    setupGameStartedReaction();
    // setupGameStartedReaction();
  }

  @action
  Future<void> leaveGame() async {
    try {

      await leaveCurrentGameSession();
      if(gameSessionSubscription != null){
        stopSubscription(gameSessionSubscription);
      }
      this.parseGameSession = null;
      this.parsePlayers = new ObservableList<ParseUser>();
      // this.elapsedGameTime = Stream.value(Duration.zero).asObservable();
    } catch(err) {
      log('error', error: err);
      throw err;
    }
  }

  @action
  Future<void> fetchPlayers() async {
    try{
      this.parsePlayers =  (await fetchPlayersForGameSession(this.parseGameSession.objectId)).asObservable();
    }catch(err){
      log('error', error: 'failed to fetch parse players');
      this.parsePlayers = new ObservableList<ParseUser>();
    }
    // print('parsePlayers type: ' + this.parsePlayers.runtimeType.toString());
  }

  @action
  Future<void> startGame() async {
    print('starting gameSession');
    parseGameSession.set<DateTime>('startedAt', DateTime.now());
    print('now: ${DateTime.now()}');
    var startedAt = parseGameSession.get<DateTime>('startedAt');
    print('StartedAt before save: ${startedAt}');
    await parseGameSession.save();

    await enterGame();
    return;
  }

  @action enterGame() async {
    // await parent.map.fetchAllLocations();
    await parent.locations.startLocationSubscription();
    print('enter game called and finished');
  }

  void setupGameStartedReaction() async {
    when((_){
      return null != parseGameSession.get<DateTime>('startedAt', defaultValue: null);
    }, (){
      print('====================>>    ONE SHOT REACTION TRIGGERED: Game was started');
      var startedAt = parseGameSession.get<DateTime>('startedAt');
      startedAt = startedAt.toLocal();
      print('startTime: ${startedAt}');
      
      // RevealService().setRevealMomentsFromStartAndInterval(startedAt.toLocal(), Duration(seconds: 50), 250);
      parent.revealMoments.init();

      currentDateEverySecond = Stream.periodic(Duration(seconds: 1), (count) {
        // return DateTime.now().difference(parseGameSession.get<DateTime>('startedAt'));
        return DateTime.now();
      }).asObservable(initialValue: DateTime.now());
    });
  }

  Future<void> _startGameSubscription() async{
    if(gameSessionSubscription != null){
      stopSubscription(gameSessionSubscription);
    }
    gameSessionSubscription = await subscribeToGameSession(this.parseGameSession);
      gameSessionSubscription.on(LiveQueryEvent.update, (value) async {
        print('gameSession updated: ${value}');
        this.parseGameSession = (value as ParseObject);
        print('refetching all players');
        await this.fetchPlayers();
      });
  }
}