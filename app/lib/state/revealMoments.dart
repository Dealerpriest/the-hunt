
import 'dart:developer';

import 'package:learning_flutter/services/revealService.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:mobx/mobx.dart';
import 'package:sorted_list/sorted_list.dart';

part 'revealMoments.g.dart';

class RevealMoments = _RevealMoments with _$RevealMoments;

abstract class _RevealMoments with Store {
  _RevealMoments({this.parent});
  MainStore parent;

  // @observable
  // ObservableList<DateTime> allRevealMoments = new ObservableList<DateTime>();

  @observable
  SortedList<DateTime> _allRevealMoments = SortedList<DateTime>((a, b) => a.compareTo(b));

  @computed 
  List<DateTime> get futureRevealMoments {
    return _allRevealMoments.where((DateTime revealMoment){
      var now = parent.gameSession.currentDateEverySecond.value;
      return now.isBefore(revealMoment); 
    }).toList();
  }

  @computed
  List<DateTime> get pastRevealMoments {
    return _allRevealMoments.where((DateTime revealMoment) {
      return !this.futureRevealMoments.contains(revealMoment);
    }).toList();
  }

  @computed
  DateTime get nextRevealMoment {
    if(futureRevealMoments.isEmpty){
      return null;
    }
    return futureRevealMoments.first;
  }

  @computed
  Duration get untilNextRevealMoment {
    try {
      if(nextRevealMoment == null){
        return Duration.zero;
      }
      var nextReveal = this.nextRevealMoment;
      var now = parent.gameSession.currentDateEverySecond.value;
      return nextReveal.difference(now);
    }catch(err){
      log('error', error: err);
      return Duration.zero;
    }
  }

  @computed
  DateTime get latestRevealMoment {
    return pastRevealMoments.last;
  }

  @action
  init() async {

    // RevealService().setRevealMomentsFromStartAndInterval(parent.gameSession.parseGameSession.get('startedAt'), Duration(minutes: 1));
    var startTime = parent.gameSession.parseGameSession.get<DateTime>('startedAt').toLocal();
    RevealService().setRevealMomentsFromStartAndInterval(startTime, Duration(seconds: 50), 250);
    this._allRevealMoments = RevealService().revealMoments;
  }
  
  
}