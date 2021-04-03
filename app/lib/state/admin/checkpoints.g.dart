// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoints.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Checkpoints on _Checkpoints, Store {
  Computed<List<ParseObject>> _$notPickedCheckpointsComputed;

  @override
  List<ParseObject> get notPickedCheckpoints =>
      (_$notPickedCheckpointsComputed ??= Computed<List<ParseObject>>(
              () => super.notPickedCheckpoints,
              name: '_Checkpoints.notPickedCheckpoints'))
          .value;
  Computed<ObservableList<ParseObject>> _$tappedCheckpointsComputed;

  @override
  ObservableList<ParseObject> get tappedCheckpoints =>
      (_$tappedCheckpointsComputed ??= Computed<ObservableList<ParseObject>>(
              () => super.tappedCheckpoints,
              name: '_Checkpoints.tappedCheckpoints'))
          .value;
  Computed<ObservableSet<Polyline>> _$tappedCheckpointsPolylinesComputed;

  @override
  ObservableSet<Polyline> get tappedCheckpointsPolylines =>
      (_$tappedCheckpointsPolylinesComputed ??=
              Computed<ObservableSet<Polyline>>(
                  () => super.tappedCheckpointsPolylines,
                  name: '_Checkpoints.tappedCheckpointsPolylines'))
          .value;
  Computed<double> _$distanceThroughTappedCheckpointsComputed;

  @override
  double get distanceThroughTappedCheckpoints =>
      (_$distanceThroughTappedCheckpointsComputed ??= Computed<double>(
              () => super.distanceThroughTappedCheckpoints,
              name: '_Checkpoints.distanceThroughTappedCheckpoints'))
          .value;
  Computed<Set<Marker>> _$checkpointMarkersComputed;

  @override
  Set<Marker> get checkpointMarkers => (_$checkpointMarkersComputed ??=
          Computed<Set<Marker>>(() => super.checkpointMarkers,
              name: '_Checkpoints.checkpointMarkers'))
      .value;

  final _$allCheckpointsAtom = Atom(name: '_Checkpoints.allCheckpoints');

  @override
  ObservableList<ParseObject> get allCheckpoints {
    _$allCheckpointsAtom.reportRead();
    return super.allCheckpoints;
  }

  @override
  set allCheckpoints(ObservableList<ParseObject> value) {
    _$allCheckpointsAtom.reportWrite(value, super.allCheckpoints, () {
      super.allCheckpoints = value;
    });
  }

  final _$pickedCheckpointsAtom = Atom(name: '_Checkpoints.pickedCheckpoints');

  @override
  List<ParseObject> get pickedCheckpoints {
    _$pickedCheckpointsAtom.reportRead();
    return super.pickedCheckpoints;
  }

  @override
  set pickedCheckpoints(List<ParseObject> value) {
    _$pickedCheckpointsAtom.reportWrite(value, super.pickedCheckpoints, () {
      super.pickedCheckpoints = value;
    });
  }

  final _$tappedCheckpointIdsAtom =
      Atom(name: '_Checkpoints.tappedCheckpointIds');

  @override
  ObservableList<String> get tappedCheckpointIds {
    _$tappedCheckpointIdsAtom.reportRead();
    return super.tappedCheckpointIds;
  }

  @override
  set tappedCheckpointIds(ObservableList<String> value) {
    _$tappedCheckpointIdsAtom.reportWrite(value, super.tappedCheckpointIds, () {
      super.tappedCheckpointIds = value;
    });
  }

  final _$moveCheckpointAsyncAction =
      AsyncAction('_Checkpoints.moveCheckpoint');

  @override
  Future moveCheckpoint(ParseObject checkpoint, LatLng coords) {
    return _$moveCheckpointAsyncAction
        .run(() => super.moveCheckpoint(checkpoint, coords));
  }

  final _$newCheckpointAsyncAction = AsyncAction('_Checkpoints.newCheckpoint');

  @override
  Future newCheckpoint(LatLng coords) {
    return _$newCheckpointAsyncAction.run(() => super.newCheckpoint(coords));
  }

  final _$initAsyncAction = AsyncAction('_Checkpoints.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
allCheckpoints: ${allCheckpoints},
pickedCheckpoints: ${pickedCheckpoints},
tappedCheckpointIds: ${tappedCheckpointIds},
notPickedCheckpoints: ${notPickedCheckpoints},
tappedCheckpoints: ${tappedCheckpoints},
tappedCheckpointsPolylines: ${tappedCheckpointsPolylines},
distanceThroughTappedCheckpoints: ${distanceThroughTappedCheckpoints},
checkpointMarkers: ${checkpointMarkers}
    ''';
  }
}
