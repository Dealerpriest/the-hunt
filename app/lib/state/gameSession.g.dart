// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameSession.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GameSession on _GameSession, Store {
  Computed<Duration> _$elapsedGameTimeComputed;

  @override
  Duration get elapsedGameTime => (_$elapsedGameTimeComputed ??=
          Computed<Duration>(() => super.elapsedGameTime,
              name: '_GameSession.elapsedGameTime'))
      .value;
  Computed<String> _$sessionNameComputed;

  @override
  String get sessionName =>
      (_$sessionNameComputed ??= Computed<String>(() => super.sessionName,
              name: '_GameSession.sessionName'))
          .value;
  Computed<DateTime> _$gameStartTimeComputed;

  @override
  DateTime get gameStartTime =>
      (_$gameStartTimeComputed ??= Computed<DateTime>(() => super.gameStartTime,
              name: '_GameSession.gameStartTime'))
          .value;
  Computed<dynamic> _$gameStartedComputed;

  @override
  dynamic get gameStarted =>
      (_$gameStartedComputed ??= Computed<dynamic>(() => super.gameStarted,
              name: '_GameSession.gameStarted'))
          .value;
  Computed<ParseUser> _$gameHostComputed;

  @override
  ParseUser get gameHost =>
      (_$gameHostComputed ??= Computed<ParseUser>(() => super.gameHost,
              name: '_GameSession.gameHost'))
          .value;
  Computed<bool> _$isGameHostComputed;

  @override
  bool get isGameHost =>
      (_$isGameHostComputed ??= Computed<bool>(() => super.isGameHost,
              name: '_GameSession.isGameHost'))
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
  Computed<bool> _$isPreyComputed;

  @override
  bool get isPrey => (_$isPreyComputed ??=
          Computed<bool>(() => super.isPrey, name: '_GameSession.isPrey'))
      .value;
  Computed<bool> _$isHunterComputed;

  @override
  bool get isHunter => (_$isHunterComputed ??=
          Computed<bool>(() => super.isHunter, name: '_GameSession.isHunter'))
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

  final _$parseGameCheckpointsAtom =
      Atom(name: '_GameSession.parseGameCheckpoints');

  @override
  List<ParseObject> get parseGameCheckpoints {
    _$parseGameCheckpointsAtom.reportRead();
    return super.parseGameCheckpoints;
  }

  @override
  set parseGameCheckpoints(List<ParseObject> value) {
    _$parseGameCheckpointsAtom.reportWrite(value, super.parseGameCheckpoints,
        () {
      super.parseGameCheckpoints = value;
    });
  }

  final _$currentDateEverySecondAtom =
      Atom(name: '_GameSession.currentDateEverySecond');

  @override
  ObservableStream<DateTime> get currentDateEverySecond {
    _$currentDateEverySecondAtom.reportRead();
    return super.currentDateEverySecond;
  }

  @override
  set currentDateEverySecond(ObservableStream<DateTime> value) {
    _$currentDateEverySecondAtom
        .reportWrite(value, super.currentDateEverySecond, () {
      super.currentDateEverySecond = value;
    });
  }

  final _$parsePlayersAtom = Atom(name: '_GameSession.parsePlayers');

  @override
  ObservableList<ParseUser> get parsePlayers {
    _$parsePlayersAtom.reportRead();
    return super.parsePlayers;
  }

  @override
  set parsePlayers(ObservableList<ParseUser> value) {
    _$parsePlayersAtom.reportWrite(value, super.parsePlayers, () {
      super.parsePlayers = value;
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

  final _$leaveGameAsyncAction = AsyncAction('_GameSession.leaveGame');

  @override
  Future<void> leaveGame() {
    return _$leaveGameAsyncAction.run(() => super.leaveGame());
  }

  final _$fetchPlayersAsyncAction = AsyncAction('_GameSession.fetchPlayers');

  @override
  Future<void> fetchPlayers() {
    return _$fetchPlayersAsyncAction.run(() => super.fetchPlayers());
  }

  final _$startGameAsyncAction = AsyncAction('_GameSession.startGame');

  @override
  Future<void> startGame() {
    return _$startGameAsyncAction.run(() => super.startGame());
  }

  final _$enterGameAsyncAction = AsyncAction('_GameSession.enterGame');

  @override
  Future enterGame() {
    return _$enterGameAsyncAction.run(() => super.enterGame());
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
  Future<void> setPrey(ParseUser user) {
    final _$actionInfo = _$_GameSessionActionController.startAction(
        name: '_GameSession.setPrey');
    try {
      return super.setPrey(user);
    } finally {
      _$_GameSessionActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sessionNameAvailable: ${sessionNameAvailable},
parseGameSession: ${parseGameSession},
parseGameCheckpoints: ${parseGameCheckpoints},
currentDateEverySecond: ${currentDateEverySecond},
parsePlayers: ${parsePlayers},
elapsedGameTime: ${elapsedGameTime},
sessionName: ${sessionName},
gameStartTime: ${gameStartTime},
gameStarted: ${gameStarted},
gameHost: ${gameHost},
isGameHost: ${isGameHost},
allPlayerNames: ${allPlayerNames},
prey: ${prey},
isPrey: ${isPrey},
isHunter: ${isHunter}
    ''';
  }
}
