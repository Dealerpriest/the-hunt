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
        title: Text('Lobby'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: <Widget>[
              ListTile(
                      title: Text('Player'),
                      trailing: Text('Hunter'),
                    ),
              Expanded(
                child: Observer(builder: (_) => ListView(
                  children: 
                  appState.gameSession.allPlayerNames.map((playerName) => ListTile(
                        title: Text(playerName),
                        trailing: Switch(value: true, onChanged: (value) => value = !value),
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


// Old hedawr of playerlist (put inside a row widget...):
// children: <Widget>[
//                         Text(
//                           "Player name",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "Hunter/Prey",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],