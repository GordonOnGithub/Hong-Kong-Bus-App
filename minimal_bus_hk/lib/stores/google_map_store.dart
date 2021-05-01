import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:mobx/mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'google_map_store.g.dart';

class GoogleMapStore = GoogleMapStoreBase
    with _$GoogleMapStore;

abstract class GoogleMapStoreBase with Store {
  @observable
  BusStopDetail selectedBusStop;

  @action
  void setSelectedBusStop(BusStopDetail busStop){
    selectedBusStop = busStop;
  }

  @computed
  ObservableList<BusStopDetail> get busStops {
    if(selectedRoute == null){
      return ObservableList<BusStopDetail>();
    }

    var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
    if(routeStopsMap == null){
      return  ObservableList<BusStopDetail>();
    }
    var routeStopsList = routeStopsMap[selectedRoute.routeCode];
    if(routeStopsList == null){
      return  ObservableList<BusStopDetail>();
    }

    var result = ObservableList<BusStopDetail>();
    for(var stop in routeStopsList){
      if(Stores.dataManager.busStopDetailMap != null && Stores.dataManager.busStopDetailMap.containsKey(stop.identifier)){
        result.add(Stores.dataManager.busStopDetailMap[stop.identifier]);
      }
    }
    return result;
  }

  @observable
  BusRoute selectedRoute;

  @action
  void setSelectedRoute(BusRoute selectedRoute){
    this.selectedRoute = selectedRoute;
  }

  @observable
  bool isInbound = false;

  @action
  void setIsInbound(bool isInbound){
    this.isInbound = isInbound;
  }

  @observable
  double currentZoomLevel;

  @action
  void setCurrentZoomLevel(double zoom){
    currentZoomLevel = zoom;
  }

  @observable
  bool locationPermissionGranted = false;

  @action
  void setLocationPermissionGranted(bool locationPermissionGranted){
    this.locationPermissionGranted = locationPermissionGranted;
  }

  @observable
  bool atCenter = true;

  @action
  void setAtCenter(bool atCenter){
    this.atCenter = atCenter;
  }

  final LatLng HKGeoCenter = LatLng(22.32621908589066, 114.1186428366926);

  @computed
  LatLng get routeGeoCenter{

    double maxLat = 0;
    double minLat = double.infinity;

    double maxLng = 0;
    double minLng = double.infinity;

    for(var busStop in busStops){
      if( busStop.latitude == null || busStop.longitude == null){
        continue;
      }
      if(busStop.positionForMap.latitude > maxLat){
        maxLat = busStop.latitude;
      }
      if(busStop.positionForMap.latitude < minLat){
        minLat = busStop.latitude;
      }
      if(busStop.positionForMap.longitude > maxLng){
        maxLng = busStop.longitude;
      }
      if(busStop.positionForMap.longitude < minLng){
        minLng = busStop.longitude;
      }
    }

    if (maxLat > 0 && minLat < double.infinity && maxLng > 0 && minLng < double.infinity){
      return LatLng((maxLat + minLat) / 2, (minLng + maxLng) / 2);
    }else{
      return HKGeoCenter;// approximated geo center of HK
    }
  }

  @computed
  double get routeHorizontalRangeInKM{

    double maxLng = 0;
    double minLng = double.infinity;

    for(var busStop in busStops){
      if( busStop.latitude == null || busStop.longitude == null){
        continue;
      }
      if(busStop.positionForMap.longitude > maxLng){
        maxLng = busStop.longitude;
      }
      if(busStop.positionForMap.longitude < minLng){
        minLng = busStop.longitude;
      }
    }

    var lngDetla = maxLng - minLng;

    var distance = lngDetla * 111 * cos( HKGeoCenter.latitude * 3.1415926 / 180);

    return distance;
  }

  @computed
  double get routeVerticalRangeInKM{

    double maxLat = 0;
    double minLat = double.infinity;

    for(var busStop in busStops){
      if( busStop.latitude == null || busStop.longitude == null){
        continue;
      }
      if(busStop.positionForMap.longitude > maxLat){
        maxLat = busStop.latitude;
      }
      if(busStop.positionForMap.longitude < minLat){
        minLat = busStop.latitude;
      }
    }

    var latDetla = maxLat - minLat;

    var distance = latDetla * 111 ;

    return distance;
  }

  @computed
  double get getDefaultZoomLevelForRoute{

    var zoomLevel = 10.5;
    if(routeHorizontalRangeInKM < 20 && routeVerticalRangeInKM < 20){
      zoomLevel += 0.5;
    }
    if(routeHorizontalRangeInKM < 15 && routeVerticalRangeInKM < 15){
      zoomLevel += 0.5;
    }
    if(routeHorizontalRangeInKM < 12.5 && routeVerticalRangeInKM < 12.5){
      zoomLevel += 0.5;
    }
    return zoomLevel;
  }

}