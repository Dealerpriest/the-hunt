import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:provider/provider.dart';
// import 'package:gunnars_test/main.dart';

class LobbyScreen extends StatelessWidget {

  Widget listItem(player){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(player),
        Switch(
          value: true,
          onChanged: (value) {
            print('switched');
          },
        ),
      ],
    );
    }

  @override
  Widget build(BuildContext ctx) {
    
    final appState = Provider.of<MainStore>(ctx);
    return Scaffold(
      appBar: AppBar(
        title: RichText(text: 
          TextSpan(text: 'Lobby', 
            recognizer: LongPressGestureRecognizer(duration: Duration(seconds: 3), postAcceptSlopTolerance: 20)..onLongPress = () => appState.gameSession.setAdmin(appState.user.currentUser))),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: <Widget>[
              ListTile(
                      title: Text('Player'),
                      trailing: Text('Prey'),
                    ),
              Expanded(
                child: Observer(builder: (_) => ListView(
                  children: 
                  appState.gameSession.parsePlayers.map((player) => ListTile(
                        title: Text(player.get('playerName')),
                        trailing: Radio(groupValue: appState.gameSession.prey.objectId, value: player.objectId,),
                      )).toList()
                  // List.generate(15, (idx) => ListTile(
                  //       title: Text('Player $idx'),
                  //       trailing: Switch(value: true, onChanged: (value) => value = !value),
                  //     ))
                )
                )
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlinedButton(
                      // style: Theme.of(ctx).e,
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(ctx, '/');
                      },
                    ),
                    ElevatedButton(
                      child: Text('Start the hunt!'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(ctx, '/game');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}