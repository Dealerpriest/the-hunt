
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/services/mapService.dart';
import 'package:learning_flutter/state/admin/adminStore.dart';



class AdminMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    
    AdminStore adminState = AdminStore.getInstance();
    adminState.checkpoints.init();

    final mapService = MapService();

    return Scaffold(
      body: 
      Observer(builder: 
        (ctx) => GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(57.708870, 11.974560), zoom: 17),
          mapType: MapType.normal,
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
    );
  }
}