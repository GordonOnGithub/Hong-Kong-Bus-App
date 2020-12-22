import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleMapViewPage(),
    );
  }
}

class GoogleMapViewPage extends StatefulWidget {
  GoogleMapViewPage({Key key}) : super(key: key);


  @override
  _GoogleMapViewPageState createState() => _GoogleMapViewPageState();
}

class _GoogleMapViewPageState extends State<GoogleMapViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(Stores.googleMapStore.selectedBusStop)),
        ),
        body: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 500, child:
        GoogleMap(initialCameraPosition: CameraPosition(
            target: Stores.googleMapStore.selectedBusStop.positionForMap,
            zoom: 16.0,
          ),
          markers: _getMarkers(Stores.googleMapStore.selectedBusStop),))
          
        ],),)
    );
  }

  Set<Marker> _getMarkers(BusStopDetail busStopDetail){
    Set<Marker> markers = Set();
      

       MarkerId markerId = MarkerId(busStopDetail.identifier);
        InfoWindow infoWindow = InfoWindow(title: _getTitle(busStopDetail));
        Marker stopMarker = Marker(markerId: markerId, position: Stores.googleMapStore.selectedBusStop.positionForMap, infoWindow: infoWindow);
        markers.add(stopMarker);

    return markers;
  }

  String _getTitle(BusStopDetail busStopDetail){
      return  Stores.localizationStore.localizedStringFrom(busStopDetail, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref);

    }
}