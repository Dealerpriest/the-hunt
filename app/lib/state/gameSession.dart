import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../services/revealService.dart';

part 'gameSession.g.dart';

class GameSession = _GameSession with _$GameSession;

Subscription gameSessionSubscription;

abstract class _GameSession with Store {
  _GameSession({this.parent});
  MainStore parent;

  // ReactionDisposer _disposeStartReaction;
  ReactionDisposer _disposeRevealTimerReaction;

  @observable
  bool sessionNameAvailable = false;

  @observable
  ParseObject parseGameSession;

  @observable
  ObservableStream<Duration> elapsedGameTime = Stream.value(Duration.zero).asObservable();

  @computed
  Duration get durationUntilNextReveal {
    try {
      int elapsed = elapsedGameTime.value.inSeconds;
      Duration untilReveal = RevealService().untilNextRevealMoment;
      if(untilReveal == null){
        return Duration.zero;
      }
      return untilReveal;
      // DateTime now = DateTime.now();
      // DateTime nextReveal = revealMoments.firstWhere((revealMoment) => now.isBefore(revealMoment), orElse: () =>  DateTime.now());
      // return nextReveal.difference(now);
    } catch (err){
      log('error', error: err);
      return Duration.zero;
    }
  }

  int _revealTimerCounter = 0;

  @computed
  int get nrOfRevealsFromTimer {
    if(this.durationUntilNextReveal.inSeconds == 0){
      _revealTimerCounter++;
    }
    return _revealTimerCounter;
  }

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
    try {
      this.parseGameSession = await createGameSession(sessionName, playerName);
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
      this.elapsedGameTime = Stream.value(Duration.zero).asObservable();
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
    parseGameSession.set<DateTime>('startedAt', DateTime.now());
    await parseGameSession.save();
    await enterGame();
    return;
  }

  @action enterGame() async {
    // await parent.map.fetchAllLocations();
    await parent.map.startLocationSubscription();
    print('enter game called and finished');
  }

  void setupGameStartedReaction() async {
    when((_){
      return null != parseGameSession.get<DateTime>('startedAt', defaultValue: null);
    }, (){
      print('====================>>    ONE SHOT REACTION TRIGGERED: Game was started');
      RevealService().setRevealMomentsFromStartAndInterval(parseGameSession.get<DateTime>('startedAt'), Duration(seconds: 50), 250);
      elapsedGameTime = Stream.periodic(Duration(seconds: 1), (count) {
      return DateTime.now().difference(parseGameSession.get<DateTime>('startedAt'));
    }).asObservable(initialValue: Duration.zero);
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