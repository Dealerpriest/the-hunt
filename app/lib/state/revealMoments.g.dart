// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revealMoments.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RevealMoments on _RevealMoments, Store {
  Computed<List<DateTime>> _$futureRevealMomentsComputed;

  @override
  List<DateTime> get futureRevealMoments => (_$futureRevealMomentsComputed ??=
          Computed<List<DateTime>>(() => super.futureRevealMoments,
              name: '_RevealMoments.futureRevealMoments'))
      .value;
  Computed<List<DateTime>> _$pastRevealMomentsComputed;

  @override
  List<DateTime> get pastRevealMoments => (_$pastRevealMomentsComputed ??=
          Computed<List<DateTime>>(() => super.pastRevealMoments,
              name: '_RevealMoments.pastRevealMoments'))
      .value;
  Computed<DateTime> _$nextRevealMomentComputed;

  @override
  DateTime get nextRevealMoment => (_$nextRevealMomentComputed ??=
          Computed<DateTime>(() => super.nextRevealMoment,
              name: '_RevealMoments.nextRevealMoment'))
      .value;
  Computed<Duration> _$untilNextRevealMomentComputed;

  @override
  Duration get untilNextRevealMoment => (_$untilNextRevealMomentComputed ??=
          Computed<Duration>(() => super.untilNextRevealMoment,
              name: '_RevealMoments.untilNextRevealMoment'))
      .value;
  Computed<DateTime> _$latestRevealMomentComputed;

  @override
  DateTime get latestRevealMoment => (_$latestRevealMomentComputed ??=
          Computed<DateTime>(() => super.latestRevealMoment,
              name: '_RevealMoments.latestRevealMoment'))
      .value;

  final _$_allRevealMomentsAtom =
      Atom(name: '_RevealMoments._allRevealMoments');

  @override
  SortedList<DateTime> get _allRevealMoments {
    _$_allRevealMomentsAtom.reportRead();
    return super._allRevealMoments;
  }

  @override
  set _allRevealMoments(SortedList<DateTime> value) {
    _$_allRevealMomentsAtom.reportWrite(value, super._allRevealMoments, () {
      super._allRevealMoments = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_RevealMoments.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
futureRevealMoments: ${futureRevealMoments},
pastRevealMoments: ${pastRevealMoments},
nextRevealMoment: ${nextRevealMoment},
untilNextRevealMoment: ${untilNextRevealMoment},
latestRevealMoment: ${latestRevealMoment}
    ''';
  }
}
