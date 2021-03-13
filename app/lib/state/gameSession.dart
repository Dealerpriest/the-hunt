import 'package:flutter/foundation.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'gameSession.g.dart';

class GameSession = _GameSession with _$GameSession;

Subscription gameSessionSubscription;

abstract class _GameSession with Store {
  _GameSession({this.parent});
  MainStore parent;
  
  Stream _gameTimer = null;
  // @observable
  // String playerName = '';
  
  // @observable
  // String sessionName = '';

  @observable
  bool sessionNameAvailable = false;

  @observable
  ParseObject parseGameSession;

  @observable
  ObservableStream<int> elapsedGameTime;

  @computed
  String get sessionName {
    // if(parseGameSession?.get('name')??true){
    //   print('invalid game session when calcing computed property');
    //   return '';
    // }
    var name = parseGameSession?.get('name')??'';
    print('game Session name: '+ name);
    return name;
  }

  @computed
  ParseUser get gameHost {
    if(parseGameSession == null || !parseGameSession.containsKey('owner'))
      return null;
    return parseGameSession.get<ParseUser>('owner');
  }

  @computed
  bool get isGameHost {
    return parent.user.currentUser.objectId == this.gameHost.objectId;
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
    return parent.user.currentUser.objectId == this.prey.objectId;
  }

  @action
  checkSessionNameAvailable(String sessionName) async {
    bool availbale = await isGameNameAvailable(sessionName);
    sessionNameAvailable = availbale;
  }

  @action
  Future<void> createGame(sessionName, playerName) async{
    bool available = await isGameNameAvailable(sessionName);
    if(!available){
      return Future.error("Problem. Game name was already in use");
    }
    try {
      this.parseGameSession = await createGameSession(sessionName);
      _startGameSubscription();
      await joinGameSession(this.parseGameSession, playerName);
      return Future.value();
    }catch (err){
      Future.error(err);
    }
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
  Future<void> joinGame(sessionName, playerName) async {
    this.parseGameSession = await joinGameSessionByName(sessionName, playerName);
    await _startGameSubscription();
    await this.fetchPlayers();
  }

  @action
  Future<void> fetchPlayers() async {
    this.parsePlayers =  (await fetchPlayersForGameSession(this.parseGameSession.objectId)).asObservable();
    // print('parsePlayers type: ' + this.parsePlayers.runtimeType.toString());
  }

  int updateGameTimer(counter) {
    print('_gameTimer updated');
    return DateTime.now().difference(parseGameSession.get<DateTime>('startedAt')).inSeconds;
  }

  @action
  Future<void> startGame() async {
    parseGameSession.set<DateTime>('startedAt', DateTime.now());
    var result = parseGameSession.save();
    _gameTimer = Stream.periodic(Duration(seconds: 1), updateGameTimer);
    elapsedGameTime = _gameTimer.asObservable();
    return result;
    // if(response)
  }

  Future<void> _startGameSubscription() async{
    if(gameSessionSubscription != null){
      stopSubscription(gameSessionSubscription);
    }
    gameSessionSubscription = await subscribeToGameSession(this.parseGameSession);
      gameSessionSubscription.on(LiveQueryEvent.update, (value) async {
        // print('gamSession updated!!!: ' + value);
        this.parseGameSession = (value as ParseObject);
        await this.fetchPlayers();
      });
  }
}