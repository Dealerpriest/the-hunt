

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/services/locationService.dart';
import 'package:learning_flutter/services/mapService.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    // final appState = Provider.of<MainStore>(ctx);
    MainStore appState = MainStore.getInstance();

    final mapService = MapService();
    final locationService =  LocationService();
    () async {
      ParseUser user = await ParseUser.currentUser();
      locationService.startStream(appState.gameSession.parseGameSession, user);
      // appState.map.startLocationSubscription();
    }();

    return Scaffold(
      body: Observer(builder: (_) => 
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(57.708870, 11.974560), zoom: 17),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            mapService.assignMapController(controller);
          },
          markers: appState.map.markers,
        ),
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end,  children: [
        // FloatingActionButton(child: Icon(Icons.add), onPressed: () => appState.map.generateSomeMarkers()),
        SizedBox(height: 10),
        FloatingActionButton(child: Icon(Icons.remove), onPressed: () => appState.map.clearAllMarkers(), heroTag: null,),
        ],),
      persistentFooterButtons: [
        Observer(builder: (_) => Text(
          '''
          reveal in: ${appState.gameSession.durationTillNextReveal.inSeconds} 
          elapsed: ${appState.gameSession.elapsedGameTime.value.inSeconds},
          locations: ${appState.map.locations.length.toString()}, 
          revealedlocations: ${appState.map.revealedPreyLocations.length.toString()}
          markers: ${appState.map.markers.length.toString()},
        '''
        ),)
      ],
    );
  }
}