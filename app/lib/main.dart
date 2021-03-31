import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'screens/admin/adminMapScreen.dart';
import 'screens/gamescreen.dart';
import 'screens/testPage.dart';
import 'screens/lobbyscreen.dart';
import 'screens/startscreen.dart';

// TODO: Remove when not developing
import 'package:wakelock/wakelock.dart';

import 'package:provider/provider.dart';

import 'state/mainStore.dart';


Future main() async {
  await DotEnv.load();

  // mainContext.spy(print);
  runApp(MainWidget());
  // LocationService locationService = new LocationService();
  // await locationService.init();
  // locationService.startStream();
}

class MainWidget extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    
    Wakelock.enable();

    MainStore.getInstance().user.initUser();

    return MaterialApp(
        title: 'All makt åt tengil!',
        theme: ThemeData.dark(),
        home: StartScreen(),
        routes: <String, WidgetBuilder>{
          '/start': (_) => StartScreen(),
          '/lobby': (_) => LobbyScreen(),
          // '/test': (_) => TestScreen(),
          '/game': (_) => GameScreen(),
          '/admin': (_) => AdminMapScreen(),
        },
      );

    // return MultiProvider(
    //   providers: [
    //     Provider<MainStore>(create: (_){
    //       // MainStore store = MainStore();
    //       // store.user.initUser();
    //       // return store;

    //       MainStore store = MainStore.getInstance();
    //       store.user.initUser();
    //       return store;
    //     },)
    //   ],
    //   child: MaterialApp(
    //     title: 'All makt åt tengil!',
    //     theme: ThemeData.dark(),
    //     home: StartScreen(),
    //     routes: <String, WidgetBuilder>{
    //       '/start': (_) => StartScreen(),
    //       '/lobby': (_) => LobbyScreen(),
    //       '/test': (_) => TestScreen(),
    //       '/game': (_) => GameScreen(),
    //     },
    //   )
    // );
  }
}