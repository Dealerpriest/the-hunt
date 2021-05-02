// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Chart on _Chart, Store {
  Computed<Set<Marker>> _$touchedCheckpointMarkersComputed;

  @override
  Set<Marker> get touchedCheckpointMarkers =>
      (_$touchedCheckpointMarkersComputed ??= Computed<Set<Marker>>(
              () => super.touchedCheckpointMarkers,
              name: '_Chart.touchedCheckpointMarkers'))
          .value;
  Computed<Set<Marker>> _$unTouchedCheckpointMarkersComputed;

  @override
  Set<Marker> get unTouchedCheckpointMarkers =>
      (_$unTouchedCheckpointMarkersComputed ??= Computed<Set<Marker>>(
              () => super.unTouchedCheckpointMarkers,
              name: '_Chart.unTouchedCheckpointMarkers'))
          .value;
  Computed<Set<Marker>> _$allCheckpointMarkersComputed;

  @override
  Set<Marker> get allCheckpointMarkers => (_$allCheckpointMarkersComputed ??=
          Computed<Set<Marker>>(() => super.allCheckpointMarkers,
              name: '_Chart.allCheckpointMarkers'))
      .value;
  Computed<Set<Marker>> _$latestHunterMarkersComputed;

  @override
  Set<Marker> get latestHunterMarkers => (_$latestHunterMarkersComputed ??=
          Computed<Set<Marker>>(() => super.latestHunterMarkers,
              name: '_Chart.latestHunterMarkers'))
      .value;
  Computed<Set<Marker>> _$revealedPreyMarkersComputed;

  @override
  Set<Marker> get revealedPreyMarkers => (_$revealedPreyMarkersComputed ??=
          Computed<Set<Marker>>(() => super.revealedPreyMarkers,
              name: '_Chart.revealedPreyMarkers'))
      .value;
  Computed<Set<Marker>> _$markersComputed;

  @override
  Set<Marker> get markers => (_$markersComputed ??=
          Computed<Set<Marker>>(() => super.markers, name: '_Chart.markers'))
      .value;

  @override
  String toString() {
    return '''
touchedCheckpointMarkers: ${touchedCheckpointMarkers},
unTouchedCheckpointMarkers: ${unTouchedCheckpointMarkers},
allCheckpointMarkers: ${allCheckpointMarkers},
latestHunterMarkers: ${latestHunterMarkers},
revealedPreyMarkers: ${revealedPreyMarkers},
markers: ${markers}
    ''';
  }
}
