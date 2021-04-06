import 'package:learning_flutter/state/revealMoments.dart';
import 'package:mobx/mobx.dart';



import 'gameSession.dart';
import 'user.dart';
import 'map.dart';

part 'mainStore.g.dart';

// class MainStore = _MainStore with _$MainStore;
class MainStore extends _MainStore with _$MainStore { 
  static MainStore _instance; 
  static MainStore getInstance() { 
    if (_instance == null) { 
      _instance = new MainStore(); 
    }
    
    return _instance;
  }


  // static MainStore _instance;
  

  // MainStore._internal(){
  //   this._init();
  // }

  // factory MainStore() {
  //   if (_instance == null) {
  //     _instance = MainStore._internal();
  //   }
  //   return _instance;
  // }
}

abstract class _MainStore with Store {

  GameSession gameSession;
  User user;
  Map map;
  RevealMoments revealMoments;

  _MainStore(){
    gameSession = GameSession(parent: this);
    user = User(parent: this);
    map = Map(parent: this);
    revealMoments = RevealMoments(parent: this);
  }

  // @action
  // tryToCreateSession(sessionName) async {
    
  // }
}