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
        result.add(BusStopDetail.unknown(stop.identifier));
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
        if(element == null) return false;

        for(var keyword in _keywords) {
          if(( element.englishName.toLowerCase().contains(
                  keyword.toLowerCase()))
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

      for(var busStopDetail in filteredList) {
        var eta = displayedETAMap[busStopDetail.identifier];
        var sequence = 0;

        var routeStopsMap = isInbound
            ? Stores.dataManager.inboundBusStopsMap
            : Stores.dataManager.outboundBusStopsMap;
        if (routeStopsMap != null) {
           var routeStopsList = routeStopsMap[route.routeCode];
           if (routeStopsList != null) {
              for (BusStop s in routeStopsList) {
                if(s.identifier == busStopDetail.identifier){
                   sequence = s.sequence;
                   break;
                }
             }

            result.add(BusStopDetailWithETA(
              busStopDetail: busStopDetail, eta: eta, sequence: sequence));
          }
        }
      }

      return result;
    }else {

      return ObservableList<BusStopDetailWithETA>();
    }
  }


  @observable
  int selectedSequence;

  @observable
  int lastSelectedSequence;

  @action
  void setSelectedSequence(int seq){
    selectedSequence = seq;
    if(seq != null){
      lastSelectedSequence = selectedSequence;
    }
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
      var routeStop = RouteStop(route.routeCode, busStop.identifier, route.companyCode, isInbound, busStop.serviceType);
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
        filteredETAs.sort((a,b){
          if(a.etaTimestamp == null || b.etaTimestamp == null){
            return 0;
          }
          return a.etaTimestamp.compareTo(b.etaTimestamp);});
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