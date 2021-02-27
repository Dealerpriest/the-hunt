// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Map on _Map, Store {
  Computed<ObservableSet<Marker>> _$markersComputed;

  @override
  ObservableSet<Marker> get markers => (_$markersComputed ??=
          Computed<ObservableSet<Marker>>(() => super.markers,
              name: '_Map.markers'))
      .value;

  final _$clearAllMarkersAsyncAction = AsyncAction('_Map.clearAllMarkers');

  @override
  Future clearAllMarkers() {
    return _$clearAllMarkersAsyncAction.run(() => super.clearAllMarkers());
  }

  @override
  String toString() {
    return '''
markers: ${markers}
    ''';
  }
}
