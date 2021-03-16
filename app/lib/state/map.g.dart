// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Map on _Map, Store {
  Computed<ObservableList<ParseObject>> _$myLocationsComputed;

  @override
  ObservableList<ParseObject> get myLocations => (_$myLocationsComputed ??=
          Computed<ObservableList<ParseObject>>(() => super.myLocations,
              name: '_Map.myLocations'))
      .value;
  Computed<ObservableList<ParseObject>> _$preyLocationsComputed;

  @override
  ObservableList<ParseObject> get preyLocations => (_$preyLocationsComputed ??=
          Computed<ObservableList<ParseObject>>(() => super.preyLocations,
              name: '_Map.preyLocations'))
      .value;
  Computed<ObservableSet<Marker>> _$markersComputed;

  @override
  ObservableSet<Marker> get markers => (_$markersComputed ??=
          Computed<ObservableSet<Marker>>(() => super.markers,
              name: '_Map.markers'))
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

  final _$clearAllMarkersAsyncAction = AsyncAction('_Map.clearAllMarkers');

  @override
  Future clearAllMarkers() {
    return _$clearAllMarkersAsyncAction.run(() => super.clearAllMarkers());
  }

  final _$clearAllLocationsAsyncAction = AsyncAction('_Map.clearAllLocations');

  @override
  Future clearAllLocations() {
    return _$clearAllLocationsAsyncAction.run(() => super.clearAllLocations());
  }

  final _$revealMostRecentLocationAsyncAction =
      AsyncAction('_Map.revealMostRecentLocation');

  @override
  Future revealMostRecentLocation() {
    return _$revealMostRecentLocationAsyncAction
        .run(() => super.revealMostRecentLocation());
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
myLocations: ${myLocations},
preyLocations: ${preyLocations},
markers: ${markers}
    ''';
  }
}
