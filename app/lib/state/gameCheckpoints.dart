import 'dart:developer';

import 'package:mobx/mobx.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'mainStore.dart';

part 'gameCheckpoints.g.dart';
class GameCheckpoints = _GameCheckpoints with _$GameCheckpoints;

abstract class _GameCheckpoints with Store {
  _GameCheckpoints({this.parent});

  MainStore parent;

  @observable
  ObservableList<ParseObject> parseGameCheckpoints = ObservableList<ParseObject>();

  @computed
  ObservableList<ParseObject> get touchedCheckpoints {
    return this.parseGameCheckpoints.where((chckpt) {
      var touchedAt = chckpt.get<DateTime>('touchedAt');
      return touchedAt != null;
    }).toList().asObservable();
  }

  @computed
  ObservableList<ParseObject> get unTouchedCheckpoints {
    return this.parseGameCheckpoints.where((chckpt) {
      var touchedAt = chckpt.get<DateTime>('touchedAt');
      return touchedAt == null;
    }).toList().asObservable();
  }

  @action
  setGameCheckpoints (List<ParseObject> checkpoints){
    // var parseGamesession = parent.gameSession.parseGameSession;
    // List<ParseObject> pickedCheckpoints = List<ParseObject>();
    // for (var checkpoint in checkpoints) {
    //   ParseObject gameCheckpoint = ParseObject("GameCheckpoint")
    // ..set<ParseObject>('gameSession', parseGamesession)
    // ..set<ParseGeoPoint>('coords', checkpoint.get<ParseGeoPoint>('coords'))
    // ..set('difficulty', checkpoint.get<num>('difficulty'));

    // pickedCheckpoints.add(gameCheckpoint);

    // }
    // this.parseGameCheckpoints = pickedCheckpoints.asObservable();
    this.parseGameCheckpoints = checkpoints.asObservable();
  }

  // TODO: make this class sync with parse through live queries
  @action 
  touchCheckpoint (String objectId) {
    var idx = this.parseGameCheckpoints.indexWhere((checkpoint) => checkpoint.objectId == objectId);
    if(idx == -1){
      log('error', error: 'no checkpint with that id found');
      return;
    }
    var updatedCheckpoint = this.parseGameCheckpoints[idx];
    updatedCheckpoint.set('touchedAt', DateTime.now());
    this.parseGameCheckpoints.removeAt(idx);
    this.parseGameCheckpoints.insert(idx, updatedCheckpoint);
    updatedCheckpoint.save();
  }

}



