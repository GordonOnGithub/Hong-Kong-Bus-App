import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:mobx/mobx.dart';
part 'route_detail_store.g.dart';

class RouteDetailStore = RouteDetailStoreBase
    with _$RouteDetailStore;

abstract class RouteDetailStoreBase with Store {
  @observable
  BusRoute route;

  @action
  void setBusRoute(BusRoute route){
    this.route = route;
  }

  @observable
  bool isInbound = false;

  @action
  void setIsInbound(bool isInbound){
    this.isInbound = isInbound;
  }

  @observable
  int selectedBusStopIndex;

  @action
  void setSelectedBusStopIndex(int index){
    selectedBusStopIndex = index;
  }

  @computed
  ObservableList<BusStopDetail> get selectedRouteBusStops {
    if(route == null){
      return ObservableList<BusStopDetail>();
    }

    var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
    if(routeStopsMap == null){
      return null;
    }
    var routeStopsList = routeStopsMap[route.routeCode];
    if(routeStopsList == null){
      return null;
    }

    var result = ObservableList<BusStopDetail>();
    for(var stop in routeStopsList){
      if(Stores.dataManager.busStopDetailMap != null && Stores.dataManager.busStopDetailMap.containsKey(stop.identifier)){
        result.add(Stores.dataManager.busStopDetailMap[stop.identifier]);
      }else{
        result.add(BusStopDetail.empty(stop.identifier));
      }

    }

    return result;
  }


}