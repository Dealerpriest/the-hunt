// import 'package:gunnars_test/data/GameModel.dart';
// import 'package:learning_flutter/screens/gamescreen.dart';
// import 'package:learning_flutter/state/gameSession.dart';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;

import 'package:device_info/device_info.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io' show Platform;

Future<Map<String, String>> createUserCredentailsFromHardware() async {
  String _userId, _userPassword;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      _userPassword = (await deviceInfo.androidInfo).androidId;
    } else if (Platform.isIOS) {
      _userPassword = (await deviceInfo.iosInfo).identifierForVendor;
    }
    _userId = sha256.convert(utf8.encode(_userPassword)).toString();
    return Future.value({"userId": _userId, "userPassword": _userPassword});
  } catch (error) {
    print("NOOOOOOOOOOOO!!!!"); // NOOOOOOOOOOOO!!!!
    return Future.error(error);
  }
}

Future<void> initParse(userId, userPassword) async {
  String parseUrl = "${env['BACKEND_SERVER_PROTOCOL']}://${env['BACKEND_SERVER']}${env['PARSE_URL_PATH']}";
  await Parse().initialize(env['PARSE_APP_ID'],
      parseUrl,
      // masterKey:
      //     env['PARSE_MASTERKEY'], // Required for Back4App and others
      // clientKey: keyParseClientKey, // Required for some setups
      debug: false, // When enabled, prints logs to console
      liveQueryUrl: parseUrl, // Required if using LiveQuery
      autoSendSessionId: true, // Required for authentication and ACL
      // securityContext: securityContext, // Again, required for some setups
      coreStore: await CoreStoreSharedPrefsImp
          .getInstance()); // Local data storage method. Will use SharedPreferences instead of Sembast as an internal DB

  // Check server is healthy and live - Debug is on in this instance so check logs for result
  final ParseResponse response = await Parse().healthCheck();

  if (response.success) {
    print("PARSE CONNECTION HEALTHY");
    await loginOrSignup(userId, userPassword);
    print(response);
  } else {
    print("PARSE HEALTH NO GOOD");
  }
}

Future<void> loginOrSignup(userId, userPassword) async {
  ParseUser user;
  try {
    user = await ParseUser.currentUser();
    ParseResponse resp = await user.getUpdatedUser();
    if (!resp.success) {
      throw Exception("fuck you");
    }
    print("already logged in");
    return Future.value(user);
  } catch (error) {
    print(error);
    // TODO: Also first try to login here before creating new user. Could possibly happen if session was deleted or invalidated.
    // user = ParseUser('${userId}@beg.xyz');
    user = ParseUser.createUser(userId, userPassword);
    print("creating new user!!!");
    return user.signUp(allowWithoutEmail: true);
  }
}

Future<ParseObject> createGameSession(String name, String playerName) async {
  print("creating gameSession $name, with playerName:${playerName}");
  ParseUser user = await ParseUser.currentUser();
  ParseObject gameSession = ParseObject('GameSession')
    ..set('name', name)
    ..set('prey', user)
    ..set('owner', user);
    // ..set('participants', ParseRelation());
  gameSession.addRelation('participants', [user]);
  
  // ParseRelation relation = ParseRelation(key: 'participants', parent: gameSession);
  // relation.add(user);
  
  try{
    var results = await _unwrapParseResults(gameSession.save());

    ParseObject savedGame = results.first;

    ParseObject refetchedGame = (await _unwrapParseResults(savedGame.getObject(savedGame.objectId))).first;

    user.set<String>('playerName', playerName);
    // print('gonna set current game to session object: ${savedGame}');
    user.set<ParseObject>('currentGame', refetchedGame);
    // print('gonna save the updated user object');
    await user.save();

    // print('updated user saved');
    return refetchedGame;
  }catch(err){
    return Future.error(err);
  }
}

// Future<void> testSaveFunction() async {
//   ParseUser user = await ParseUser.currentUser();
//   ParseObject testThing = ParseObject('TestThing')
//   ..set('columnA', 'Some text')
//   ..set('columnB', 12345)
//   ..set('userPointer', user)
//   ..addRelation('relationToUsers', [user]);

//   print('testThing before save: \n${testThing}');

//   ParseObject savedThing = await _unwrapParseObject(testThing.save());
//   print('returned saved testThing: \n${savedThing}');

//   ParseObject refetchedThing = await _unwrapParseObject(ParseObject('TestThing').getObject(savedThing.objectId));
//   print('refetched testThing (using getObject function): \n${refetchedThing}');

//   QueryBuilder<ParseObject> query =
//       QueryBuilder<ParseObject>(ParseObject('TestThing'))
//       ..whereEqualTo('objectId', savedThing.objectId);
  
//   ParseObject queriedThing = await _unwrapParseObject(query.query());
//   print('queried testThing (using querybuilder): \n${queriedThing}');
// }

// Future<ParseObject> _unwrapParseObject(Future<ParseResponse> responseFuture) async {
//   ParseResponse response = await responseFuture;
//   if(response.success){
//     return response.results.first;
//   }
//   return Future.error(response.error);
// } 

Future<List<ParseObject>> _unwrapParseResults(Future<ParseResponse> responseFuture) async {
  ParseResponse response = await responseFuture;
  if(response.success){
    return response.results;
  }
  return Future.error(response.error);
} 

Future<ParseObject> joinGameSessionByName(String name, String playerName) async {
  print('joining game Session by name: ${name}');
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject('GameSession'))
        ..whereEqualTo('name', name);
  var resp = await query.query();
  if (resp.success) {
    ParseObject session = resp.results.first;
    return joinGameSession(session, playerName);
  }
  return Future.error(resp.error);
}

Future<ParseObject> joinGameSession(ParseObject game, String playerName) async {
  if(game.get<DateTime>('startedAt') != null){
    log('error', error: 'game was already started. Too late to join');
    return Future.error('game already started. Can not join');
  }
  print('joining gameSession: ${game.objectId} as player ${playerName}');
  ParseUser user = await ParseUser.currentUser();
  if(user == null){
    return Future.error('not logged in!!!');
  }

  bool nameIsFree = await isPlayerNameAvailable(game, playerName);
  if(!nameIsFree){
    print('ERROR: name taken');
    return Future.error('name already taken');
  }

  user.set('playerName', playerName);
  user.set<ParseObject>('currentGame', game);
  await user.save();
  ParseRelation relation = game.getRelation('participants');
  relation.add(user);
  ParseResponse response = await game.save();
  if(response.success)
    return response.results.first;
  else
    return Future.error(response.error);
}


// TODO: Handle if user is owner, pre or both when they leave a game.
Future<void> leaveCurrentGameSession() async {
  try{
    ParseUser user = await ParseUser.currentUser();
    ParseObject currentGame = user.get<ParseObject>('currentGame');
    ParseRelation participants = currentGame.getRelation('participants');
    participants.remove(user);
    await currentGame.save();
    user.unset('currentGame');
    ParseResponse response = await user.save();
    if(response.success){
      return Future.value();
    }
    throw response.error;
  } catch(err){
    throw err;
  }
}

Future<void> setPreyForGameSession (ParseObject gameSession, ParseUser prey) async {
  gameSession.set('prey', prey);
  ParseResponse apiResponse = await gameSession.save();
  if (apiResponse.success) {
    return;
  }
  return Future.error('couldn\'t save the prey to the gameSession');
    // if(apiResponse.count > 0){
    //   ParseObject player = apiResponse.results.first;
    //   ParseUser current = (await ParseUser.currentUser());
    //   if(player.objectId != current.objectId){
    //     return Future.value(false);
    //   }
    // }
    // // print("playername $playerName is available: ${available}");
    // return Future.value(true);
}

Future<bool> isGameNameAvailable(String value) async {
  print("Is game name $value available?");
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject('GameSession'))
        ..whereEqualTo('name', value);

  var apiResponse = await query.query();
  if (apiResponse.success) {
    bool available = apiResponse.count == 0;
    print("game name $value available: ${available}");
    return Future.value(available);
  }
  return Future.error(
      'HEEEELVETE!! ITS ALL GUNNARS FAULT! BUT THIS WENT WRONG. SORRY. CANT HELP IT. DONT CRY. PLEASE.');
}

// TODO: Only check inside current gamesession. We should allow duplicate names in different sessions!
Future<bool> isPlayerNameAvailable(ParseObject session, String playerName) async {
  print("Is player name $playerName available? ");
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject('_User'))
        ..whereRelatedTo('participants', 'GameSession', session.objectId)
        ..whereEqualTo('playerName', playerName);
        

  var apiResponse = await query.query();
  if (apiResponse.success) {
    if(apiResponse.count > 0){
      ParseObject player = apiResponse.results.first;
      ParseUser current = (await ParseUser.currentUser());
      if(player.objectId != current.objectId){
        return Future.value(false);
      }
    }
    // print("playername $playerName is available: ${available}");
    return Future.value(true);
  }
  return Future.error('HEEEELVETE!!');
}

Future<String> fetchAllGameSessions() async {
  var apiResponse = await ParseObject('GameSession').getAll();

  if (apiResponse.success) {
    for (var testObject in apiResponse.result) {
      print("Parse result: " + testObject.toString());
    }

    return apiResponse.results.toString();
  }

  return Future.error('no result');
}

Future<List<ParseUser>> fetchPlayersForGameSession(String gameSessionId) async {
  QueryBuilder<ParseUser> playerQuery =
      QueryBuilder<ParseUser>(ParseUser.forQuery())
        ..whereRelatedTo('participants', 'GameSession', gameSessionId);

  var apiResponse = await playerQuery.query();

  if (apiResponse.success) {
    // print(apiResponse.results);
    // print('apiRsponse.result type: ${apiResponse.results.runtimeType}');
    return Future.value(apiResponse.results.cast<ParseUser>());
  }
  return Future.error('no result');
}

Future<Subscription> subscribeToGameSession(ParseObject gameSession){
  print('Gonna try to subscribe to gameSession' + gameSession.objectId);
  QueryBuilder<ParseObject> gameSessionQuery =
    QueryBuilder<ParseObject>(ParseObject('GameSession'))
    ..whereEqualTo('objectId', gameSession.objectId);

  // ParseObject('GameSession').getObject(gameSession.objectId);

  final LiveQuery liveQuery = LiveQuery();
  return liveQuery.client.subscribe(gameSessionQuery);
}

void sendLocationToParse(LocationData location, ParseObject gameSession, ParseUser user, [bool revealed = false]) {
  print("sending location to parse!!");
  print(location);
  ParseGeoPoint pos = ParseGeoPoint(latitude: location.latitude, longitude: location.longitude);
  ParseObject loc = ParseObject("Location")
    ..set<ParseObject>('gameSession', gameSession)
    ..set<ParseGeoPoint>('coords', pos)
    ..set('accuracy', location.accuracy)
    ..set('heading', location.heading)
    ..set('speed', location.speed)
    ..set('speedAccuracy', location.speedAccuracy)
    ..set('user', user)
    ..set('revealed', revealed);

  loc.save();
}

Future<void> updateRevealStateForLocation(ParseObject loc, revealed) async {
  // print("sending location to parse!!");
  // print(location);
  // ParseGeoPoint pos = ParseGeoPoint(latitude: location.latitude, longitude: location.longitude);
  // ParseObject loc = ParseObject("Location")
  //   ..set('gameSession', gameSession)
  //   ..set('coords', pos)
  //   ..set('accuracy', location.accuracy)
  //   ..set('heading', location.heading)
  //   ..set('speed', location.speed)
  //   ..set('speedAccuracy', location.speedAccuracy)
  //   ..set('user', user);

  loc.set<bool>('revealed', revealed);

  await loc.save();
}

Future<List<ParseObject>> fetchLocationsForGamesession(ParseObject gameSession) async {
  QueryBuilder<ParseObject> locationQuery =
      QueryBuilder<ParseObject>(ParseObject('Location'))
        ..whereEqualTo('gameSession', gameSession)
        ..setLimit(15000); // We don't expect there to be more than that...

  ParseResponse response = await locationQuery.query();
  if(response.success){
    return response.results;
  }
  
  return Future.error('no result when trying to fetch locations');
}

Future<ParseObject> createCheckpoint(LatLng coords) async{
  print('gonna create a new checkpoint');
  ParseGeoPoint geopoint = ParseGeoPoint(latitude: coords.latitude, longitude: coords.longitude);
  print('geopoint: ${geopoint}');
  ParseObject checkpoint = ParseObject("Checkpoint")
    ..set('coords', geopoint);

  print('checkpoint: ${checkpoint}');
  
  ParseResponse response = await checkpoint.save();
  if(response.success){
    return response.results.first;
  }
  return Future.error(response.error);
}

Future<ParseObject> updateCheckpointPosition(ParseObject checkpoint, LatLng coords) async {
  ParseGeoPoint geopoint = ParseGeoPoint(latitude: coords.latitude, longitude: coords.longitude);
  checkpoint.set('coords', geopoint);
  return (await _unwrapParseResults(checkpoint.save())).first;
}

Future<List<ParseObject>> fetchAllCheckpoints() async {
  QueryBuilder<ParseObject> checkpointsQuery =
      QueryBuilder<ParseObject>(ParseObject('Checkpoint'));
  ParseResponse response = await checkpointsQuery.query();
  if(response.success){
    return response.results;
  }
  return Future.error('failed to fetch checkpoints');
}

Future<Subscription> subscribeToLocationsForGamesession(ParseObject gameSession) {
  QueryBuilder<ParseObject> locationQuery =
      QueryBuilder<ParseObject>(ParseObject('Location'))
        ..whereEqualTo('gameSession', gameSession);

  final LiveQuery liveQuery = LiveQuery();
  return liveQuery.client.subscribe(locationQuery);
}

Future<Subscription> subscribeToCheckpoints() {
  QueryBuilder<ParseObject> checkpointsQuery =
      QueryBuilder<ParseObject>(ParseObject('Checkpoint'));

  final LiveQuery liveQuery = LiveQuery();
  return liveQuery.client.subscribe(checkpointsQuery);
}

void stopSubscription(Subscription subscription) {
  final LiveQuery liveQuery = LiveQuery();
  liveQuery.client.unSubscribe(subscription);
}