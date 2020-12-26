import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:mobx/mobx.dart';

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
}