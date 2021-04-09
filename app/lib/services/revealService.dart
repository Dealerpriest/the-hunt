import 'dart:developer';

import 'package:sorted_list/sorted_list.dart';


class RevealService {
  /// SINGLETON PATTERN
  static RevealService _instance;
  

  RevealService._internal(){
    this._init();
  }

  factory RevealService() {
    if (_instance == null) {
      _instance = RevealService._internal();
    }
    return _instance;
  }
  //// END SINGLETON PATTERN
  
  SortedList<DateTime> _revealMoments = SortedList<DateTime>((a, b) => a.compareTo(b));
  // List<DateTime> _revealMoments = List<DateTime>();

  _init(){
    // Do we need to init something?? Don't think so!
  }


  void set revealMoments(List<DateTime> revealMoments){
    _revealMoments = revealMoments;
  }

  List<DateTime> get revealMoments {
    return _revealMoments;
  }

  DateTime get nextRevealMomentRealTime {
    try{
      return _revealMoments.firstWhere((revealMoment) => DateTime.now().isBefore(revealMoment));
    } catch(err) {
      log('error', error: err);
      print('probably have run out of revealMoments');
      return null;
    }
  }

  // DateTime get latestRevealMoment {
  //   try{
  //     return _revealMoments.lastWhere((revealMoment) {
  //       return DateTime.now().isAfter(revealMoment);
  //     });
  //   } catch(err) {
  //     log('error', error: err);
  //     return null;
  //   }
  // }

  // Duration get untilNextRevealMoment {
  //   var nextReveal = this.nextRevealMoment;
  //   if(nextReveal == null){
  //     return null;
  //   }
  //   return nextReveal.difference(DateTime.now());
  // }
  // 
  
  // bool shouldTriggerRevealSound(int ){
  //   var nextReveal = _nextRevealMoment;

  // }

  void setRevealMomentsFromStartAndInterval(DateTime startTime, Duration interval, [int nrOfReveals = 100]){
    print('Setting revealMoment!');
    print('provided startTime: ${startTime}');
    // List<DateTime> list = new List<DateTime>();
    _revealMoments.clear();
    for(int i = 0; i < nrOfReveals; i++){
      DateTime revealMoment = startTime.add(interval * (i+1));
      _revealMoments.add(revealMoment);
    }
    print('nr of set revealMoments: ${_revealMoments.length}');
    for(DateTime dt in _revealMoments){
      print(dt.toString());
    }
  }
}