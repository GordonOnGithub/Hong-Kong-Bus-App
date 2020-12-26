import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail_with_eta.dart';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
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
  ObservableList<BusStopDetailWithETA> get displayedStops{
    if(filterKeyword != null && selectedRouteBusStops != null) {
      var filteredList =  ObservableList<BusStopDetail>();
      filteredList.addAll(selectedRouteBusStops.where((element) {
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

      var result =  ObservableList<BusStopDetailWithETA>();

      for(var busStopDetail in filteredList){

        var eta = displayedETAMap[busStopDetail.identifier];
            result.add(BusStopDetailWithETA(busStopDetail: busStopDetail, eta: eta));
      }

      return result;
    }else {

      return null;
    }
  }

  @observable
  int selectedIndex;

  @action
  void setSelectedIndex(int index){
    selectedIndex = index;
  }

  @observable
  DateTime timeStampForChecking = DateTime.now();

  @action
  void updateTimeStampForChecking(){
    timeStampForChecking = DateTime.now();
  }

  @computed
  ObservableList<List<ETA>> get routesETAList{
    var result = ObservableList<List<ETA>>();
    var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
    if(routeStopsMap == null){
      return result;
    }
    var busStopsList = routeStopsMap[route.routeCode];
    if(busStopsList == null){
      return result;
    }

    for(BusStop busStop in busStopsList){
      var routeStop = RouteStop(route.routeCode, busStop.identifier, route.companyCode, isInbound);
      if(Stores.dataManager.ETAMap != null && Stores.dataManager.ETAMap.containsKey(routeStop)){
        var ETAs = Stores.dataManager.ETAMap[routeStop];
        var filteredETAs = <ETA>[];
        for(var eta in ETAs) {
          if(routeStop.matchETA(eta)) {
            filteredETAs.add(eta);
          }
        }
        if(filteredETAs.length == 0){
          filteredETAs.add(ETA.notFound(routeStop.routeCode, routeStop.stopId,  routeStop.companyCode, routeStop.isInbound));
        }
        filteredETAs.sort((a,b)=> a.etaTimestamp.compareTo(b.etaTimestamp));
        result.add(filteredETAs);
      }else{
        result.add([ETA.unknown(routeStop.routeCode, routeStop.stopId, routeStop.companyCode, routeStop.isInbound)]);
      }
    }

    return result;
  }

  @computed
  ObservableMap<String, ETA> get displayedETAMap{
    ObservableMap<String, ETA> result = ObservableMap<String, ETA>();
    for(List<ETA> list in routesETAList ){
      for(ETA eta in list){
        if(( eta.etaTimestamp != null ) || eta == list.last){
          result[eta.stopId] = eta;
          break;
        }
      }
    }
    return result;
  }
}