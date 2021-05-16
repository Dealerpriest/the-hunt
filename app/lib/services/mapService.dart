import 'dart:developer';

import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';


// import 'package:geodesy/geodesy.dart' as Geo;
import 'package:latlong2/latlong.dart' as Geo;

class MapService {
  /// SINGLETON PATTERN
  static MapService _instance;

  MapService._internal();

  factory MapService() {
    if (_instance == null) {
      _instance = MapService._internal();
    }
    return _instance;
  }
  //// END SINGLETON PATTERN

  GoogleMapController mapControl;

  animateToPosition(LatLng coords){
    if(mapControl == null){
      return;
    }
    mapControl.animateCamera(CameraUpdate.newLatLng(coords));
  }
  
  assignMapController(GoogleMapController controller) async {
    mapControl = controller;

    try {
      String mapStyle = await fetchMapStyle();
      controller.setMapStyle(mapStyle).then((_) {
        print("styling map!!!");
      }).catchError((error) {
        print("ERROR while styling map");
        return null;
      });
    }catch (err){
      log('error', error: err);
    }
  }

  toGeoLatLng(LatLng coords){
    return Geo.LatLng(coords.latitude, coords.longitude);
  }

  toMapLatLng(Geo.LatLng coords){
    return LatLng(coords.latitude, coords.longitude);
  }

  // void addCircle(double latitude, double longitude, bool isHunter) {
  //   Color circleColor = colors.prey;
  //   double circleRadius = 50;
  //   if (isHunter) {
  //     circleColor = colors.hunter;
  //     circleRadius = 25;
  //   }

  //   final String circleIdVal = 'circle_id_$_circleIdCounter';
  //   _circleIdCounter++;
  //   final CircleId circleId = CircleId(circleIdVal);

  //   final Circle circle = Circle(
  //     circleId: circleId,
  //     consumeTapEvents: true,
  //     strokeColor: circleColor,
  //     fillColor: Colors.transparent,
  //     strokeWidth: 10,
  //     center: LatLng(
  //       latitude,
  //       longitude,
  //     ),
  //     radius: circleRadius,
  //     onTap: () {
  //       _onCircleTapped(circleId);
  //     },
  //   );
  // }
  
  // static void moveMapViewToLocation(
  //     GoogleMapController controller, location) async {
  //   // if (location == null) await getCurrentPosition();
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //       createCameraFromPosition(
  //           location.coords.latitude, location.coords.longitude)));
  //   // .catchError((error) => (print(
  //   //     "ERROR when trying to get the GoogleMapController from it's future.")));
  // }

  // static void maveMapABit(GoogleMapController controller){
  //   controller.animateCamera(
  //     CameraUpdate.scrollBy(
  //       rnd.nextDouble()*200-100, 
  //       rnd.nextDouble()*200-100
  //     )
  //   );
  // }

  // static CameraPosition createCameraFromPosition(lat, long) {
  //   return CameraPosition(target: LatLng(lat, long), zoom: 17);
  // }

  static Future<String> fetchMapStyle() async {
    return await rootBundle.loadString("assets/mapStyle.json");
    // .then((string) {
    //   return string;
    // });
  }
}
