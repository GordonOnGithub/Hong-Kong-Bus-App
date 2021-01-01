
import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/custom_map_pin_info.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:permission_handler/permission_handler.dart';
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
  static final _defaultZoomForAllStops = 16.5;
  static final _minZoomLevelForEasterEggs = 17.0;

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
  final LatLng HKIslandGeoCenter = LatLng(22.319361669566444, 114.1692526504284);

  @override
  void initState() {
    super.initState();
    Stores.googleMapStore.setCurrentZoomLevel( Stores.googleMapStore.selectedBusStop != null?_defaultZoomForStop: Stores.googleMapStore.getDefaultZoomLevelForRoute);

    Permission.locationWhenInUse.status.then((status) {
      Stores.googleMapStore.setLocationPermissionGranted(status == PermissionStatus.granted);

      Permission.locationWhenInUse.request().then((result){
        Stores.googleMapStore.setLocationPermissionGranted(result == PermissionStatus.granted);
      });
    });
  }
  
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    Stores.googleMapStore.setAtCenter(true);
    if(Stores.googleMapStore.selectedBusStop != null) {
      mapController.showMarkerInfoWindow(MarkerId(Stores.googleMapStore.selectedBusStop.identifier));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Observer(
        builder: (_) =>Stores.googleMapStore.selectedRoute != null?
        Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRoute, Stores.localizationStore.localizationPref)} ${Stores.googleMapStore.selectedRoute.routeCode}, ${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${LocalizationUtil.localizedStringFrom(Stores.googleMapStore.selectedRoute, Stores.googleMapStore.isInbound ? BusRoute.localizationKeyForOrigin : BusRoute.localizationKeyForDestination, Stores.localizationStore.localizationPref)}", maxLines: 2,)
          :Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForBusStopList, Stores.localizationStore.localizationPref))),
        ),
        body: Observer(
    builder: (_) =>Center(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Stores.googleMapStore.locationPermissionGranted? Container() :  Container(height: 50,color: Colors.yellow,alignment: Alignment.center, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLocationPermissionNotGranted, Stores.localizationStore.localizationPref), style: TextStyle(fontWeight: FontWeight.w600),)),
      Expanded( child:
        GoogleMap(initialCameraPosition: CameraPosition(
            target:  Stores.googleMapStore.selectedBusStop != null?Stores.googleMapStore.selectedBusStop.positionForMap:
            ( Stores.googleMapStore.selectedRoute != null? Stores.googleMapStore.routeGeoCenter: HKIslandGeoCenter),
            zoom:   Stores.googleMapStore.selectedBusStop != null? _defaultZoomForStop:
            ( Stores.googleMapStore.selectedRoute != null? Stores.googleMapStore.getDefaultZoomLevelForRoute : _defaultZoomForAllStops),
          ),
          markers: _getMarkers(Stores.googleMapStore.busStops, Stores.googleMapStore.currentZoomLevel),
          onMapCreated: _onMapCreated,
          onCameraMoveStarted: (){
            Stores.googleMapStore.setAtCenter(false);
          },
          onCameraIdle: (){
              mapController.getZoomLevel().then((value) => Stores.googleMapStore.setCurrentZoomLevel(value));
          },
          myLocationEnabled: Stores.googleMapStore.locationPermissionGranted,
          myLocationButtonEnabled: Stores.googleMapStore.locationPermissionGranted,
          tiltGesturesEnabled: false,
          zoomControlsEnabled: false,
          cameraTargetBounds: CameraTargetBounds(LatLngBounds(northeast: LatLng(22.631843587586193, 114.41798414088238), southwest:  LatLng(22.176373229353644, 113.81319021792984))),

        )),
        ],),)),
            floatingActionButton:Observer(
           builder: (_) =>  !Stores.googleMapStore.atCenter ?
               ( Stores.googleMapStore.selectedRoute != null? FloatingActionButton.extended(
             onPressed: (){
               _onRecenterClicked();
             },
             icon: Icon(Icons.zoom_in),
                 label: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRecenter, Stores.localizationStore.localizationPref)),
           ) :Container() ): Container()),

    );
  }

  Set<Marker> _getMarkers(List<BusStopDetail> busStops, double zoom){
    Set<Marker> markers = Set();
      if(busStops != null && busStops.length > 0) {
        var count = 0;
        for (var busStopDetail in busStops) {
          count += 1;
          if(busStopDetail.positionForMap.latitude == 0 && busStopDetail.positionForMap.longitude == 0){
            continue;
          }

          MarkerId markerId = MarkerId("${busStopDetail.identifier}");
          InfoWindow infoWindow = InfoWindow(title: "$count. ${LocalizationUtil.localizedStringFrom(
              busStopDetail, BusStopDetail.localizationKeyForName,
              Stores.localizationStore.localizationPref)}");
          Marker stopMarker = Marker(markerId: markerId,
              position: busStopDetail.positionForMap,
              infoWindow: infoWindow,
              icon: BitmapDescriptor.defaultMarkerWithHue(  Stores.googleMapStore.selectedBusStop != null && busStopDetail.identifier == Stores.googleMapStore.selectedBusStop.identifier ? BitmapDescriptor.hueGreen : count == 1?BitmapDescriptor.hueAzure:(count == busStops.length? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed)));
          markers.add(stopMarker);
        }
      }else if(zoom >= _defaultZoomForAllStops){
        for(BusStopDetail busStopDetail in Stores.dataManager.busStopDetailMap.values){
          MarkerId markerId = MarkerId("${busStopDetail.identifier}");
          InfoWindow infoWindow = InfoWindow(title: "${LocalizationUtil.localizedStringFrom(
              busStopDetail, BusStopDetail.localizationKeyForName,
              Stores.localizationStore.localizationPref)}");
          Marker stopMarker = Marker(markerId: markerId,
              position: busStopDetail.positionForMap,
              infoWindow: infoWindow,
              icon: BitmapDescriptor.defaultMarkerWithHue(  BitmapDescriptor.hueRed),
          onTap: (){

          });
          markers.add(stopMarker);
        }

      }
//debug
    // MarkerId markerId = MarkerId("geocenter");
    // Marker stopMarker = Marker(markerId: markerId,
    //     position: Stores.googleMapStore.routeGeoCenter,
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
    // );
    // markers.add(stopMarker);

      //easter egg
      for(var pinInfo in _customPinInfoList) {
        if(zoom >= _minZoomLevelForEasterEggs || (pinInfo.identifier == "Save12HKYouth" && zoom >= 11)) {
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
      Stores.googleMapStore.selectedBusStop != null?
      CameraUpdate.newLatLngZoom(Stores.googleMapStore.selectedBusStop.positionForMap, _defaultZoomForStop):
      CameraUpdate.newLatLngZoom(Stores.googleMapStore.routeGeoCenter, Stores.googleMapStore.getDefaultZoomLevelForRoute),
    ).then((value) {
      Stores.googleMapStore.setAtCenter(true);
      if(Stores.googleMapStore.selectedBusStop != null) {
        mapController.showMarkerInfoWindow(MarkerId(Stores.googleMapStore.selectedBusStop.identifier));
      }
    });
  }
}