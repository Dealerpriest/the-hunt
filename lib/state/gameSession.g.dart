// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameSession.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GameSession on _GameSession, Store {
  Computed<String> _$sessionNameComputed;

  @override
  String get sessionName =>
      (_$sessionNameComputed ??= Computed<String>(() => super.sessionName,
              name: '_GameSession.sessionName'))
          .value;
  Computed<List<String>> _$allPlayerNamesComputed;

  @override
  List<String> get allPlayerNames => (_$allPlayerNamesComputed ??=
          Computed<List<String>>(() => super.allPlayerNames,
              name: '_GameSession.allPlayerNames'))
      .value;
  Computed<ParseUser> _$preyComputed;

  @override
  ParseUser get prey => (_$preyComputed ??=
          Computed<ParseUser>(() => super.prey, name: '_GameSession.prey'))
      .value;

  final _$sessionNameAvailableAtom =
      Atom(name: '_GameSession.sessionNameAvailable');

  @override
  bool get sessionNameAvailable {
    _$sessionNameAvailableAtom.reportRead();
    return super.sessionNameAvailable;
  }

  @override
  set sessionNameAvailable(bool value) {
    _$sessionNameAvailableAtom.reportWrite(value, super.sessionNameAvailable,
        () {
      super.sessionNameAvailable = value;
    });
  }

  final _$parseGameSessionAtom = Atom(name: '_GameSession.parseGameSession');

  @override
  ParseObject get parseGameSession {
    _$parseGameSessionAtom.reportRead();
    return super.parseGameSession;
  }

  @override
  set parseGameSession(ParseObject value) {
    _$parseGameSessionAtom.reportWrite(value, super.parseGameSession, () {
      super.parseGameSession = value;
    });
  }

  final _$parsePlayersAtom = Atom(name: '_GameSession.parsePlayers');

  @override
  ObservableList<ParseObject> get parsePlayers {
    _$parsePlayersAtom.reportRead();
    return super.parsePlayers;
  }

  @override
  set parsePlayers(ObservableList<ParseObject> value) {
    _$parsePlayersAtom.reportWrite(value, super.parsePlayers, () {
      super.parsePlayers = value;
    });
  }

  final _$locationsAtom = Atom(name: '_GameSession.locations');

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

  final _$checkSessionNameAvailableAsyncAction =
      AsyncAction('_GameSession.checkSessionNameAvailable');

  @override
  Future checkSessionNameAvailable(String sessionName) {
    return _$checkSessionNameAvailableAsyncAction
        .run(() => super.checkSessionNameAvailable(sessionName));
  }

  final _$createGameAsyncAction = AsyncAction('_GameSession.createGame');

  @override
  Future<void> createGame(dynamic sessionName, dynamic playerName) {
    return _$createGameAsyncAction
        .run(() => super.createGame(sessionName, playerName));
  }

  final _$joinGameAsyncAction = AsyncAction('_GameSession.joinGame');

  @override
  Future<void> joinGame(dynamic sessionName, dynamic playerName) {
    return _$joinGameAsyncAction
        .run(() => super.joinGame(sessionName, playerName));
  }

  final _$fetchPlayersAsyncAction = AsyncAction('_GameSession.fetchPlayers');

  @override
  Future<void> fetchPlayers() {
    return _$fetchPlayersAsyncAction.run(() => super.fetchPlayers());
  }

  final _$_GameSessionActionController = ActionController(name: '_GameSession');

  @override
  Future<void> setAdmin(ParseUser user) {
    final _$actionInfo = _$_GameSessionActionController.startAction(
        name: '_GameSession.setAdmin');
    try {
      return super.setAdmin(user);
    } finally {
      _$_GameSessionActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sessionNameAvailable: ${sessionNameAvailable},
parseGameSession: ${parseGameSession},
parsePlayers: ${parsePlayers},
locations: ${locations},
sessionName: ${sessionName},
allPlayerNames: ${allPlayerNames},
prey: ${prey}
    ''';
  }
}
