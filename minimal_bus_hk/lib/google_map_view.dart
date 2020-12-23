import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/custom_map_pin_info.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleMapViewPage();
  }
}

class GoogleMapViewPage extends StatefulWidget {
  GoogleMapViewPage({Key key}) : super(key: key);


  @override
  _GoogleMapViewPageState createState() => _GoogleMapViewPageState();
}

class _GoogleMapViewPageState extends State<GoogleMapViewPage> {
  GoogleMapController mapController;
  static final _defaultZoomForStop = 18.0;
  static final _defaultZoomForRoute = 10.5;
  static final _HKGeographicCenter = const LatLng(22.32621908589066, 114.1186428366926);
  static final _customPinInfoList = [
    CustomMapPinInfo("立會",  LatLng(22.28161008355225, 114.16632608035314), "There's no riot, only tyranny.", "沒有暴徒 只有暴政", "沒有暴徒 只有暴政"),

    CustomMapPinInfo("七二一",  LatLng(22.44607925235589, 114.03473965700638), "Where cops worked with triads on 21 July.", "七二一唔見人", "七二一唔見人"),
    CustomMapPinInfo("八三一",  LatLng(22.324687846223284, 114.16825423504059), "Where cops terrorized citizens in MTR on 31 Aug.", "八三一打死人", "八三一打死人"),
    CustomMapPinInfo("十月一",  LatLng( 22.37173657381423, 114.1160214388837), "Where cops attempted to murder on 1 Oct.", "十月一槍殺人", "十月一槍殺人"),

    CustomMapPinInfo("周梓樂",  LatLng( 22.31190876592493, 114.26114652885158), "Rest in power, Chow Tsz-lok.", "永遠懷念 周梓樂", "永遠懷念 周梓樂"),
    CustomMapPinInfo("陳彥霖",  LatLng( 22.299476160808236, 114.26405094959347), "Rest in power, Chan Yin-lam.", "永遠懷念 陳彥霖", "永遠懷念 陳彥霖"),
    CustomMapPinInfo("梁凌杰",  LatLng( 22.277913075110394, 114.16559846333044), "Rest in power, Leung Ling-kit.", "永遠懷念 梁凌杰", "永遠懷念 梁凌杰"),

    CustomMapPinInfo("Save12HKYouth",  LatLng( 22.586375079606228, 114.25622469111427), "#save12hkyouths", "#save12hkyouths", "#save12hkyouths"),
  ];

  @override
  void initState() {
    super.initState();
    Stores.googleMapStore.setCurrentZoomLevel( Stores.googleMapStore.selectedBusStop != null?_defaultZoomForStop:_defaultZoomForRoute);

    Permission.locationWhenInUse.status.then((status) {
      Stores.googleMapStore.setLocationPermissionGranted(status == PermissionStatus.granted);

      Permission.locationWhenInUse.request().then((result){
        Stores.googleMapStore.setLocationPermissionGranted(result == PermissionStatus.granted);
      });
    });

  }
  
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Observer(
        builder: (_) =>Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRoute, Stores.localizationStore.localizationPref)} ${Stores.googleMapStore.selectedRoute.routeCode}")),
        ),
        body: Observer(
    builder: (_) =>Center(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Stores.googleMapStore.locationPermissionGranted? Container() :  Container(height: 50,color: Colors.yellow,alignment: Alignment.center, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLocationPermissionNotGranted, Stores.localizationStore.localizationPref), style: TextStyle(fontWeight: FontWeight.w600),)),
      Expanded( child:
        GoogleMap(initialCameraPosition: CameraPosition(
            target:  Stores.googleMapStore.selectedBusStop != null?Stores.googleMapStore.selectedBusStop.positionForMap:_HKGeographicCenter,
            zoom:   Stores.googleMapStore.selectedBusStop != null?_defaultZoomForStop:_defaultZoomForRoute,
          ),
          markers: _getMarkers(Stores.googleMapStore.busStops, Stores.googleMapStore.currentZoomLevel),
          onMapCreated: _onMapCreated,
          onCameraIdle: (){
              mapController.getZoomLevel().then((value) => Stores.googleMapStore.setCurrentZoomLevel(value));
          },
          myLocationEnabled: Stores.googleMapStore.locationPermissionGranted,
          myLocationButtonEnabled: Stores.googleMapStore.locationPermissionGranted,
          tiltGesturesEnabled: false,
        )),
          SizedBox( height: 100, child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly , children: [
            Stores.googleMapStore.selectedBusStop != null ?InkWell(child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRecenter, Stores.localizationStore.localizationPref),style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline)),
              onTap: (){
                _onRecenterClicked();
            },) : Container(),
          ],))
          
        ],),))
    );
  }

  Set<Marker> _getMarkers(List<BusStopDetail> busStops, double zoom){
    Set<Marker> markers = Set();
      if(busStops != null) {
        for (var busStopDetail in busStops) {
          MarkerId markerId = MarkerId(busStopDetail.identifier);
          InfoWindow infoWindow = InfoWindow(title:LocalizationUtil.localizedStringFrom(
              busStopDetail, BusStopDetail.localizationKeyForName,
              Stores.localizationStore.localizationPref));
          Marker stopMarker = Marker(markerId: markerId,
              position: busStopDetail.positionForMap,
              infoWindow: infoWindow,);
          markers.add(stopMarker);
        }
      }

      //easter egg
      for(var pinInfo in _customPinInfoList) {
        if(zoom >= 17 || (pinInfo.identifier == "Save12HKYouth" && zoom >= _defaultZoomForRoute)) {
          MarkerId markerId = MarkerId(pinInfo.identifier);
        InfoWindow infoWindow = InfoWindow(title: LocalizationUtil.localizedStringFrom(pinInfo, CustomMapPinInfo.localizationKeyForDescription, Stores.localizationStore.localizationPref));
        Marker stopMarker = Marker(markerId: markerId,
          position:pinInfo.positionForMap,
          infoWindow: infoWindow,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)
        );
        markers.add(stopMarker);
      }
    }
    return markers;
  }

  void _onRecenterClicked(){
    mapController.moveCamera(
      CameraUpdate.newLatLngZoom(Stores.googleMapStore.selectedBusStop.positionForMap, _defaultZoomForStop),
    );
  }
}