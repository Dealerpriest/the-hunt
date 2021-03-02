import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:learning_flutter/state/gameSession.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import '../state/GameModel.dart';
// import 'package:gunnars_test/main.dart';

// import '../services/parseServerInteractions.dart';
// import 'package:provider/provider.dart';

// class StartScreen extends StatefulWidget {
//   @override
//   State<StartScreen> createState() => StartScreenState();
// }

class StartScreen extends StatelessWidget {
  // ONLY UI STATE HERE!!!!
  // bool _gameNameAvailable = false;
  // bool _playerNameAvailable = false;
  // String _gameName = "";
  // String _playerName = "";

  // @override
  // void initState() {
  //   super.initState();
  //   createUserCredentailsFromHardware().then((Map<String, String> credentials) {
  //     initParse(credentials["userId"], credentials["userPassword"]).then((_) {
  //       // getAllGameSessions().then((gameSessionsString) {
  //       //   _gameSessionName = gameSessionsString;
  //       // });
  //     });
  //   });
  // }

  // void _onClickHostGame(GameModel state) async {
  //   try {
  //     await createGameSession(_gameName);
  //     await joinGameSession(_gameName, _playerName);
  //     state.gameState = GameState.lobby;
  //     state.myPlayer = Player(name: _playerName);
  //     state.addPlayerToGameSession(state.myPlayer);

  //     Navigator.pushReplacementNamed(context, '/lobby');
  //   } catch (error) {
  //     print("fuck you!!");
  //     print(error);
  //   }
  // }

  // void _onClickJoinGame(GameModel state) async {
  //   await joinGameSession(_gameName, _playerName);
  //   state.gameState = GameState.lobby;
  //   state.myPlayer = Player(name: _playerName);
  //   state.addPlayerToGameSession(state.myPlayer);
  //   Navigator.pushReplacementNamed(context, '/lobby');
  // }

  String gameName = '';
  String playerName = '';


  @override
  Widget build(BuildContext ctx) {
    final appState = Provider.of<MainStore>(ctx);
    return Scaffold(
      body: Center(
        child: Container(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 40.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Observer(
                builder: (ctx) => Container(
                  child: Column(
                    children: [
                      Text(
                        "Das Hunt",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          foreground: Paint()
                            // ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.orange[600],
                        ),
                      ),
                      // Text(gameSession.playerName),
                      // Text(gameSession.sessionName),
                      // Text(
                      //   "Are you ready for some action? One player is the prey, who needs to go to all waypoints. The other players are hunters, who try to get close enough to the prey to catch it.",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //   ),
                      // ),
                      // Text(
                      //   "Come up with a name and host a game, or fill in the name of an existing game and join it.",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Observer(builder: (_) => Text('players: ' + appState.gameSession.allPlayerNames?.toString()??'no players'),),
              Observer(builder: (_) => Text('game name: ' + appState.gameSession.sessionName??'no game object'),),
              Builder(
                builder: (ctx) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Player Name',
                          ),
                          onChanged: (value) {
                            playerName = value;
                          },
                        ),
                      ),
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Game Name',
                          ),
                          onChanged: (value) {
                            gameName = value;
                            appState.gameSession.checkSessionNameAvailable(value);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                              color: Colors.orange[700],
                              child: Text('Host'),
                              onPressed: () async{

                                // Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('klickade Host')));
                                try{

                                  await appState.gameSession.createGame(gameName, playerName);
                                  Navigator.pushNamed(ctx, '/lobby');
                                } catch ( err) {
                                  log('error:', error: err);
                                }

                              }
                          ),
                          RaisedButton(
                              color: Colors.orange[700],
                              child: Text('Join'),
                              onPressed: () async {
                                // Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('klickade Join'),));

                                await appState.gameSession.joinGame(gameName, playerName);
                                Navigator.pushNamed(ctx, '/lobby');
                              },
                          ),
                          RaisedButton(
                              color: Colors.orange[700],
                              child: Text('Game Screen'),
                              onPressed: (){
                                Navigator.pushNamed(ctx, '/game');
                                // appState.gameSession.getPlayers();
                              },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
