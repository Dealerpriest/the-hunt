// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Map on _Map, Store {
  Computed<ObservableList<ParseObject>> _$allMyLocationsComputed;

  @override
  ObservableList<ParseObject> get allMyLocations =>
      (_$allMyLocationsComputed ??= Computed<ObservableList<ParseObject>>(
              () => super.allMyLocations,
              name: '_Map.allMyLocations'))
          .value;
  Computed<ObservableList<ParseObject>> _$allPreyLocationsComputed;

  @override
  ObservableList<ParseObject> get allPreyLocations =>
      (_$allPreyLocationsComputed ??= Computed<ObservableList<ParseObject>>(
              () => super.allPreyLocations,
              name: '_Map.allPreyLocations'))
          .value;
  Computed<ParseObject> _$latestPreyLocationComputed;

  @override
  ParseObject get latestPreyLocation => (_$latestPreyLocationComputed ??=
          Computed<ParseObject>(() => super.latestPreyLocation,
              name: '_Map.latestPreyLocation'))
      .value;
  Computed<ObservableList<ParseObject>> _$revealedPreyLocationsComputed;

  @override
  ObservableList<ParseObject> get revealedPreyLocations =>
      (_$revealedPreyLocationsComputed ??=
              Computed<ObservableList<ParseObject>>(
                  () => super.revealedPreyLocations,
                  name: '_Map.revealedPreyLocations'))
          .value;
  Computed<ParseObject> _$latestRevealedPreyLocationComputed;

  @override
  ParseObject get latestRevealedPreyLocation =>
      (_$latestRevealedPreyLocationComputed ??= Computed<ParseObject>(
              () => super.latestRevealedPreyLocation,
              name: '_Map.latestRevealedPreyLocation'))
          .value;
  Computed<Set<Marker>> _$checkpointMarkersComputed;

  @override
  Set<Marker> get checkpointMarkers => (_$checkpointMarkersComputed ??=
          Computed<Set<Marker>>(() => super.checkpointMarkers,
              name: '_Map.checkpointMarkers'))
      .value;
  Computed<Set<Marker>> _$revealedPreyMarkersComputed;

  @override
  Set<Marker> get revealedPreyMarkers => (_$revealedPreyMarkersComputed ??=
          Computed<Set<Marker>>(() => super.revealedPreyMarkers,
              name: '_Map.revealedPreyMarkers'))
      .value;
  Computed<Set<Marker>> _$markersComputed;

  @override
  Set<Marker> get markers => (_$markersComputed ??=
          Computed<Set<Marker>>(() => super.markers, name: '_Map.markers'))
      .value;

  final _$locationsAtom = Atom(name: '_Map.locations');

  @override
  ObservableList<ParseObject> get locations {
    _$locationsAtom.reportRead();
    return super.locations;
  }

  @override
  set locations(ObservableList<ParseObject> value) {
    _$locationsAtom.reportWrite(value, super.locations, () {
      super.locations = value;
    });
  }

  final _$clearAllLocationsAsyncAction = AsyncAction('_Map.clearAllLocations');

  @override
  Future clearAllLocations() {
    return _$clearAllLocationsAsyncAction.run(() => super.clearAllLocations());
  }

  final _$fetchAllLocationsAsyncAction = AsyncAction('_Map.fetchAllLocations');

  @override
  Future fetchAllLocations() {
    return _$fetchAllLocationsAsyncAction.run(() => super.fetchAllLocations());
  }

  @override
  String toString() {
    return '''
locations: ${locations},
allMyLocations: ${allMyLocations},
allPreyLocations: ${allPreyLocations},
latestPreyLocation: ${latestPreyLocation},
revealedPreyLocations: ${revealedPreyLocations},
latestRevealedPreyLocation: ${latestRevealedPreyLocation},
checkpointMarkers: ${checkpointMarkers},
revealedPreyMarkers: ${revealedPreyMarkers},
markers: ${markers}
    ''';
  }
}
