import 'package:learning_flutter/state/locations.dart';
import 'package:learning_flutter/state/revealMoments.dart';
import 'package:mobx/mobx.dart';



import 'gameSession.dart';
import 'user.dart';
import 'chart.dart';
import 'gameCheckpoints.dart';

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
  Locations locations;
  Chart chart;
  RevealMoments revealMoments;
  GameCheckpoints gameCheckpoints;

  _MainStore(){
    gameSession = GameSession(parent: this);
    user = User(parent: this);
    locations = Locations(parent: this);
    chart = Chart(parent: this);
    revealMoments = RevealMoments(parent: this);
    gameCheckpoints = GameCheckpoints(parent: this);
  }
}