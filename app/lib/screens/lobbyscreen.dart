import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:provider/provider.dart';
// import 'package:gunnars_test/main.dart';

class LobbyScreen extends StatelessWidget {

  // Widget listItem(player){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Text(player),
  //       Switch(
  //         value: true,
  //         onChanged: (value) {
  //           print('switched');
  //         },
  //       ),
  //     ],
  //   );
  //   }

  @override
  Widget build(BuildContext ctx) {
    
    // final appState = Provider.of<MainStore>(ctx);
    MainStore appState = MainStore.getInstance();
    return Scaffold(
      appBar: AppBar(
        title: 
        Observer( builder: (ctx){
          String hostText = appState.gameSession.isGameHost ? ', (you are host)':'';
          return RichText(text: 
            TextSpan(text: 'gameName: ${appState.gameSession.sessionName}${hostText}', 
              recognizer: LongPressGestureRecognizer(duration: Duration(seconds: 3), postAcceptSlopTolerance: 20)..onLongPress = () => appState.gameSession.setAdmin(appState.user.currentUser)));
        })
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
                        trailing: Radio(
                          groupValue: appState.gameSession.prey.objectId, 
                          value: player.objectId,
                          onChanged: appState.gameSession.isGameHost ? (value){
                            appState.gameSession.setPrey(player);
                            // print(player.runtimeType);
                          } : null,),
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
                      child: const Text('Leave'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(ctx, '/');
                      },
                    ),
                    Observer(builder: (_){
                      if(appState.gameSession.isGameHost){
                        return ElevatedButton(
                          child: Text('Start the hunt!'),
                          onPressed: () async {
                            await appState.gameSession.startGame();
                            Navigator.pushReplacementNamed(ctx, '/game');
                          },
                        );
                      }else{
                        if(appState.gameSession.gameStarted){
                          return ElevatedButton(
                            child: Text('Enter the hunt!'),
                            onPressed: () async {
                              // await appState.gameSession.startGame();
                              appState.gameSession.enterGame();
                              Navigator.pushReplacementNamed(ctx, '/game');
                            },
                          );
                        }else{
                          return Container(width: 0, height: 0,);
                        }
                      }
                    }),
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