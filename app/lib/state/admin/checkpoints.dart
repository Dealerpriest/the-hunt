import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/services/checkpointService.dart';
import 'package:learning_flutter/state/admin/adminStore.dart';
import 'package:mobx/mobx.dart';
import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'checkpoints.g.dart';

class Checkpoints = _Checkpoints with _$Checkpoints;

Subscription locationSubscription;
abstract class _Checkpoints with Store {
  _Checkpoints({this.parent});
  AdminStore parent;

  CheckpointService checkpointService = CheckpointService();

  @observable
  ObservableList<ParseObject> checkpoints = new ObservableList<ParseObject>();

  @observable
  ObservableList<ParseObject> tappedCheckpoints = new ObservableList<ParseObject>();

  @computed
  ObservableSet<Polyline> get tappedCheckpointsPolylines {
    if(tappedCheckpoints.length < 2){
      return <Polyline>{}.asObservable();
    }
    List<LatLng> points = tappedCheckpoints.map((checkpoint){
      var geoPoint = checkpoint.get<ParseGeoPoint>('coords');
      return LatLng(geoPoint.latitude, geoPoint.longitude);
    }).toList();
    
    return {
      Polyline(
      patterns: [PatternItem.dot, PatternItem.gap(4)],
      polylineId: PolylineId(tappedCheckpoints[0].objectId),
      points: points
      )
    }.asObservable();
  }

  @computed
  double get distanceThroughTappedCheckpoints {
    if(tappedCheckpoints.length < 2){
      return 0;
    }

    double meters = 0;
    for (var i = 1; i < tappedCheckpoints.length; i++) {
      meters += checkpointService.distanceBetweenCheckpoints(tappedCheckpoints[i], tappedCheckpoints[i-1]);
    }
    return meters;
    // print('distance between tapped checkpoints: ${meters}');
  }


  @computed
  ObservableSet<Marker> get checkpointMarkers {
    return checkpoints.map<Marker>((checkpoint){
      BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      ParseGeoPoint geoPoint = checkpoint.get<ParseGeoPoint>('coords');
      return Marker(markerId: MarkerId(checkpoint.objectId), position: LatLng(geoPoint.latitude, geoPoint.longitude), icon: icon, draggable: true,
      onDragEnd: (LatLng coords){
        this.moveCheckpoint(checkpoint, coords);
      },
      onTap: (){
        print('tapped a checkpoint: ${checkpoint}');
        this.tappedCheckpoints.add(checkpoint);
        if(this.tappedCheckpoints.length > 2){
          tappedCheckpoints.removeAt(0);
        }
        if(this.tappedCheckpoints.length != 2){
          return;
        }
        
      });
    }).toSet().asObservable();
  }

  @action
  moveCheckpoint(ParseObject checkpoint, LatLng coords) async {
    ParseObject updatedCheckpoint = await updateCheckpointPosition(checkpoint, coords);
    int idx = this.checkpoints.indexWhere((ParseObject checkpoint) => checkpoint.objectId == updatedCheckpoint.objectId);
    if(idx >= 0) {
      checkpoints[idx] = updatedCheckpoint;
    }
    print('checkpoint ${checkpoint} moved to ${coords}');
  }


  @action
  newCheckpoint(LatLng coords) async {
    print('action for creating checkpoint called with: ${coords}');
    ParseObject savedCheckpoint = await createCheckpoint(coords);
    this.checkpoints.add(savedCheckpoint);
  }

  @action
  init() async {
    List<ParseObject> fetchedCheckpoints = await fetchAllCheckpoints();
    if(fetchedCheckpoints == null){
      return;
    }
    this.checkpoints = fetchedCheckpoints.asObservable();
  }
  
  
}