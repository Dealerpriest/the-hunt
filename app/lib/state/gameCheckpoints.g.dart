// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameCheckpoints.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GameCheckpoints on _GameCheckpoints, Store {
  Computed<ObservableList<ParseObject>> _$touchedCheckpointsComputed;

  @override
  ObservableList<ParseObject> get touchedCheckpoints =>
      (_$touchedCheckpointsComputed ??= Computed<ObservableList<ParseObject>>(
              () => super.touchedCheckpoints,
              name: '_GameCheckpoints.touchedCheckpoints'))
          .value;
  Computed<ObservableList<ParseObject>> _$unTouchedCheckpointsComputed;

  @override
  ObservableList<ParseObject> get unTouchedCheckpoints =>
      (_$unTouchedCheckpointsComputed ??= Computed<ObservableList<ParseObject>>(
              () => super.unTouchedCheckpoints,
              name: '_GameCheckpoints.unTouchedCheckpoints'))
          .value;

  final _$parseGameCheckpointsAtom =
      Atom(name: '_GameCheckpoints.parseGameCheckpoints');

  @override
  ObservableList<ParseObject> get parseGameCheckpoints {
    _$parseGameCheckpointsAtom.reportRead();
    return super.parseGameCheckpoints;
  }

  @override
  set parseGameCheckpoints(ObservableList<ParseObject> value) {
    _$parseGameCheckpointsAtom.reportWrite(value, super.parseGameCheckpoints,
        () {
      super.parseGameCheckpoints = value;
    });
  }

  final _$_GameCheckpointsActionController =
      ActionController(name: '_GameCheckpoints');

  @override
  dynamic setGameCheckpoints(List<ParseObject> checkpoints) {
    final _$actionInfo = _$_GameCheckpointsActionController.startAction(
        name: '_GameCheckpoints.setGameCheckpoints');
    try {
      return super.setGameCheckpoints(checkpoints);
    } finally {
      _$_GameCheckpointsActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic touchCheckpoint(String objectId) {
    final _$actionInfo = _$_GameCheckpointsActionController.startAction(
        name: '_GameCheckpoints.touchCheckpoint');
    try {
      return super.touchCheckpoint(objectId);
    } finally {
      _$_GameCheckpointsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
parseGameCheckpoints: ${parseGameCheckpoints},
touchedCheckpoints: ${touchedCheckpoints},
unTouchedCheckpoints: ${unTouchedCheckpoints}
    ''';
  }
}
