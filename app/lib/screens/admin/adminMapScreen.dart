
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/services/checkpointService.dart';
import 'package:learning_flutter/services/mapService.dart';
import 'package:learning_flutter/state/admin/adminStore.dart';



class AdminMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    
    AdminStore adminState = AdminStore.getInstance();
    adminState.checkpoints.init();

    final mapService = MapService();
    final checkpointService = CheckpointService();

    return Scaffold(
      body: 
      Observer(builder: 
        (ctx) => GoogleMap(
          polylines: adminState.checkpoints.tappedCheckpointsPolylines,
          initialCameraPosition: CameraPosition(target: LatLng(57.708870, 11.974560), zoom: 17),
          mapType: MapType.satellite,
          onMapCreated: (GoogleMapController controller) {
            mapService.assignMapController(controller);
          },
          onTap: (LatLng pos) {
            print('pressed at: ${pos}');
            adminState.checkpoints.newCheckpoint(pos);
          },
          markers: adminState.checkpoints.checkpointMarkers,
        ),
      ),
      floatingActionButton: 
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(child: Icon(Icons.face), onPressed: ()async {
              await checkpointService.createGameCheckpoints();
              print('pressed da button');
            })
          ],
        )
      ,
      bottomNavigationBar:
      Observer(builder: (_) =>
        Container(
          padding: EdgeInsets.all(15),
          child: 
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text('nr of timer reveals: ${appState.gameSession.nrOfRevealsFromTimer}'),
              // Text('latest location revealValue: ${appState.map.latestPreyLocation.get<bool>('revealed')}'),
              // Text('reveal in: ${appState.gameSession.durationUntilNextReveal.inSeconds+1}.${appState.gameSession.durationUntilNextReveal.inMilliseconds - 1000 * appState.gameSession.durationUntilNextReveal.inSeconds }'),
              // Text('elapsed: ${appState.gameSession.elapsedGameTime.value.inSeconds}'),
              // Text('locations: ${appState.map.locations.length}'),
              // Text('revealedlocations: ${appState.map.revealedPreyLocations.length}'),
              Text('nr of checkpoints: ${adminState.checkpoints.checkpoints.length}'),
              Text('distance: ${adminState.checkpoints.distanceThroughTappedCheckpoints.toStringAsFixed(1)}m'),

              
                ],)
        )
      ),
    );
  }
}