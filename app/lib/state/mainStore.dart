import 'package:mobx/mobx.dart';



import 'gameSession.dart';
import 'user.dart';
import 'map.dart';

part 'mainStore.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {

  GameSession gameSession;
  User user;
  Map map;

  _MainStore(){
    gameSession = GameSession(parent: this);
    user = User(parent: this);
    map = Map(parent: this);
  }

  // @action
  // tryToCreateSession(sessionName) async {
    
  // }
}