// import 'package:gunnars_test/data/GameModel.dart';
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
      debug: true, // When enabled, prints logs to console
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

Future<ParseObject> createGameSession(String name) async {
  print("creating gameSession $name");
  ParseUser user = await ParseUser.currentUser();
  ParseObject gameSession = ParseObject('GameSession')
    ..set('name', name)
    ..set('prey', user)
    ..set('owner', user);
    // ..set('participants', ParseRelation());
  try{
    ParseResponse response = await gameSession.save();
    if(response.success)
    return response.results.first;
  }catch(err){
    print(err);
    return Future.error(err);
  }
}

Future<ParseObject> joinGameSessionByName(String name, String playerName, [bool asHunter = true]) async {
  print('joining game Session by name: ${name}');
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject('GameSession'))
        ..whereEqualTo('name', name);
  var resp = await query.query();
  if (resp.success) {
    ParseObject session = resp.results.first;
    return joinGameSession(session, playerName, asHunter);
  }
  return Future.error(resp.error);
}

Future<ParseObject> joinGameSession(ParseObject game, String playerName, [bool asHunter = true]) async {
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
  user.save();
  // ParseObject player = ParseObject('Player')
  //   ..set("isHunter", asHunter)
  //   ..set("playerName", playerName)
  //   ..set("user", user);
  // player.save();

  // game.addRelation("participants", [user]);
  ParseRelation relation = game.getRelation('participants');
  relation.add(user);
  ParseResponse response = await game.save();
  if(response.success)
    return response.results.first;
  else
    return Future.error(response.error);
  // ParseResponse response = await game.save();
  // if(response.success){
  //   return Future.value();
  // }
  // return Future.error('coulnt add user to gamesession participant field');


  // QueryBuilder<ParseObject> query =
  //     QueryBuilder<ParseObject>(ParseObject('GameSession'))
  //       ..whereEqualTo('name', name);
  // var resp = await query.query();
  // if (resp.success) {
  //   ParseObject session = resp.results[0];
  //   ParseUser user = await ParseUser.currentUser();

  //   ParseObject player = ParseObject('Player')
  //     ..set("isHunter", asHunter)
  //     ..set("playerName", playerName)
  //     ..set("user", user);
  //   player.save();

  //   session.addRelation("participants", [player]);
  // }
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

// TODO: Only check inside current gamesession. We allow duplicate names in different sessions!
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

Future<List<ParseObject>> fetchPlayersForGameSession(String gameSessionId) async {
  QueryBuilder<ParseObject> playerQuery =
      QueryBuilder<ParseObject>(ParseObject('_User'))
        ..whereRelatedTo('participants', 'GameSession', gameSessionId);

  var apiResponse = await playerQuery.query();

  if (apiResponse.success) {
    // print(apiResponse.results);
    return Future.value(apiResponse.results as List<ParseObject>);
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

void sendLocationToParse(LocationData location, ParseObject gameSession, ParseUser user) {
  print("sending location to parse!!");
  print(location);
  ParseGeoPoint pos = ParseGeoPoint(latitude: location.latitude, longitude: location.longitude);
  ParseObject loc = ParseObject("Location")
    ..set('gameSession', gameSession)
    ..set('coords', pos)
    ..set('accuracy', location.accuracy)
    ..set('heading', location.heading)
    ..set('speed', location.speed)
    ..set('speedAccuracy', location.speedAccuracy)
    ..set('user', user);

  loc.save();
}

Future<List<dynamic>> fetchLocationsForGameSession(
    String gameSessionId, bool hunters) async {
  QueryBuilder<ParseObject> playerQuery =
      QueryBuilder<ParseObject>(ParseObject('_User'))
        ..whereRelatedTo('participants', 'GameSession', gameSessionId);

  // QueryBuilder<ParseObject> sessionQuery =
  //   QueryBuilder<ParseObject>(ParseObject('GameSession'))
  //     ..whereEqualTo('objectId', 'RVpzsL3tST');

  QueryBuilder<ParseObject> queryBuilder =
      QueryBuilder<ParseObject>(ParseObject('Location'))
        ..whereEqualTo('visibleByDefault', true)
        ..whereMatchesQuery('player', playerQuery);

  // var apiResponse = await queryBuilder.query();
  var apiResponse = await queryBuilder.query();

  // var apiResponse = await ParseObject('Locations').;

  if (apiResponse.success && apiResponse.count > 0) {
    print("\\\\\\\\\\\\\\");
    print(apiResponse.count);

    return apiResponse.results;
  }

  return Future.error('no result');
}

Future<Subscription> subscribeToLocationsForGamesession(ParseObject gameSession) {
  print('Not implemented yet: location subscription');
  QueryBuilder<ParseObject> locationQuery =
      QueryBuilder<ParseObject>(ParseObject('Location'))
        ..whereEqualTo('gameSession', gameSession);

  final LiveQuery liveQuery = LiveQuery();
  return liveQuery.client.subscribe(locationQuery);
}

void stopSubscription(Subscription subscription) {
  final LiveQuery liveQuery = LiveQuery();
  liveQuery.client.unSubscribe(subscription);
}