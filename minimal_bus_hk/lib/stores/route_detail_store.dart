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
  String selectedStopId;

  @action
  void setSelectedStopId(String stopId){
    if(selectedStopId != stopId){
        selectedStopId = stopId;
    }else{
      selectedStopId = null;
    }
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
  @observable
  bool dataFetchingError = false;

  @action
  void setDataFetchingError(bool hasError){
    dataFetchingError = hasError;
  }
  @observable
  String filterKeyword = "";

  @action
  void setFilterKeyword(String keyword){
    filterKeyword = keyword;
  }

  @computed
  List<String> get _keywords{
    return filterKeyword.split(" ");
  }

  @computed
  ObservableList<BusStopDetail> get displayedStops{
    if(filterKeyword != null && selectedRouteBusStops != null) {
      var result =  ObservableList<BusStopDetail>();
      result.addAll(selectedRouteBusStops.where((element) {
        for(var keyword in _keywords) {
          if( element.englishName.toLowerCase().contains(
                  keyword.toLowerCase())
              || element.TCName.toLowerCase().contains(
                  keyword.toLowerCase())
              || element.SCName.toLowerCase().contains(
                  keyword.toLowerCase())){

          }else{
            return false;
          }
        }
        return true;
      }
      ).toList());

      // result.sort((a,b){
      //   var result = a.routeCode.length.compareTo(b.routeCode.length);
      //   if(result == 0){
      //     result = a.routeCode.compareTo(b.routeCode);
      //   }
      //   return result;
      // });
      return result;
    }else {

      return null;
    }
  }
}