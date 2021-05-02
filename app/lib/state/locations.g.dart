// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Locations on _Locations, Store {
  Computed<List<ParseObject>> _$allMyLocationsComputed;

  @override
  List<ParseObject> get allMyLocations => (_$allMyLocationsComputed ??=
          Computed<List<ParseObject>>(() => super.allMyLocations,
              name: '_Locations.allMyLocations'))
      .value;
  Computed<Duration> _$durationBetweenMyLatestLocationsComputed;

  @override
  Duration get durationBetweenMyLatestLocations =>
      (_$durationBetweenMyLatestLocationsComputed ??= Computed<Duration>(
              () => super.durationBetweenMyLatestLocations,
              name: '_Locations.durationBetweenMyLatestLocations'))
          .value;
  Computed<List<ParseObject>> _$allPreyLocationsComputed;

  @override
  List<ParseObject> get allPreyLocations => (_$allPreyLocationsComputed ??=
          Computed<List<ParseObject>>(() => super.allPreyLocations,
              name: '_Locations.allPreyLocations'))
      .value;
  Computed<List<ParseObject>> _$allHunterLocationsComputed;

  @override
  List<ParseObject> get allHunterLocations => (_$allHunterLocationsComputed ??=
          Computed<List<ParseObject>>(() => super.allHunterLocations,
              name: '_Locations.allHunterLocations'))
      .value;
  Computed<Set<ParseObject>> _$latestHunterLocationsComputed;

  @override
  Set<ParseObject> get latestHunterLocations =>
      (_$latestHunterLocationsComputed ??= Computed<Set<ParseObject>>(
              () => super.latestHunterLocations,
              name: '_Locations.latestHunterLocations'))
          .value;
  Computed<ParseObject> _$latestPreyLocationComputed;

  @override
  ParseObject get latestPreyLocation => (_$latestPreyLocationComputed ??=
          Computed<ParseObject>(() => super.latestPreyLocation,
              name: '_Locations.latestPreyLocation'))
      .value;
  Computed<ObservableList<ParseObject>> _$revealedPreyLocationsComputed;

  @override
  ObservableList<ParseObject> get revealedPreyLocations =>
      (_$revealedPreyLocationsComputed ??=
              Computed<ObservableList<ParseObject>>(
                  () => super.revealedPreyLocations,
                  name: '_Locations.revealedPreyLocations'))
          .value;
  Computed<ParseObject> _$latestRevealedPreyLocationComputed;

  @override
  ParseObject get latestRevealedPreyLocation =>
      (_$latestRevealedPreyLocationComputed ??= Computed<ParseObject>(
              () => super.latestRevealedPreyLocation,
              name: '_Locations.latestRevealedPreyLocation'))
          .value;

  final _$allLocationsAtom = Atom(name: '_Locations.allLocations');

  @override
  ObservableList<ParseObject> get allLocations {
    _$allLocationsAtom.reportRead();
    return super.allLocations;
  }

  @override
  set allLocations(ObservableList<ParseObject> value) {
    _$allLocationsAtom.reportWrite(value, super.allLocations, () {
      super.allLocations = value;
    });
  }

  final _$onLocationChangedCounterAtom =
      Atom(name: '_Locations.onLocationChangedCounter');

  @override
  int get onLocationChangedCounter {
    _$onLocationChangedCounterAtom.reportRead();
    return super.onLocationChangedCounter;
  }

  @override
  set onLocationChangedCounter(int value) {
    _$onLocationChangedCounterAtom
        .reportWrite(value, super.onLocationChangedCounter, () {
      super.onLocationChangedCounter = value;
    });
  }

  final _$clearAllLocationsAsyncAction =
      AsyncAction('_Locations.clearAllLocations');

  @override
  Future clearAllLocations() {
    return _$clearAllLocationsAsyncAction.run(() => super.clearAllLocations());
  }

  final _$fetchAllLocationsAsyncAction =
      AsyncAction('_Locations.fetchAllLocations');

  @override
  Future fetchAllLocations() {
    return _$fetchAllLocationsAsyncAction.run(() => super.fetchAllLocations());
  }

  @override
  String toString() {
    return '''
allLocations: ${allLocations},
onLocationChangedCounter: ${onLocationChangedCounter},
allMyLocations: ${allMyLocations},
durationBetweenMyLatestLocations: ${durationBetweenMyLatestLocations},
allPreyLocations: ${allPreyLocations},
allHunterLocations: ${allHunterLocations},
latestHunterLocations: ${latestHunterLocations},
latestPreyLocation: ${latestPreyLocation},
revealedPreyLocations: ${revealedPreyLocations},
latestRevealedPreyLocation: ${latestRevealedPreyLocation}
    ''';
  }
}
