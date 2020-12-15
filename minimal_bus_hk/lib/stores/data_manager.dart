import 'dart:convert';

import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
part 'data_manager.g.dart';

class DataManager = DataManagerBase with _$DataManager;

abstract class DataManagerBase with Store {
  @observable
  ObservableList<BusRoute> routes;

  @computed
  ObservableMap<String, BusRoute> get routesMap{
    var result = ObservableMap<String, BusRoute>();
    for(var route in routes){
        result[route.routeCode] = route;
    }
    return result;
  }

  @action
  void setRoutes(List<Map<String, dynamic>> dataArray){

    ObservableList<BusRoute> result = ObservableList();
    for(Map<String, dynamic> data in dataArray){
      result.add(BusRoute.fromJson(data));
    }
    routes = result;
  }

  @observable
  ObservableMap<String, List<BusStop>> inboundBusStopsMap;
  @observable
  ObservableMap<String, List<BusStop>> outboundBusStopsMap;

  @action
  void updateBusStopsMap(String routeCode, bool isInbound, List<Map<String, dynamic>> dataArray){
    ObservableList<BusStop> result = ObservableList();
    for(Map<String, dynamic> data in dataArray){
      result.add(BusStop.fromJson(data));
    }

    if(isInbound) {
      if (inboundBusStopsMap == null) {
        inboundBusStopsMap = ObservableMap();
      }
      inboundBusStopsMap[routeCode] = result;
    }else{
      if (outboundBusStopsMap == null) {
        outboundBusStopsMap = ObservableMap();
      }
      outboundBusStopsMap[routeCode] = result;
    }
  }

  @observable
  ObservableMap<String, BusStopDetail> busStopDetailMap;

  @action
  void updateBusStopDetailMap(String stopId, Map<String, dynamic> busStopData){
    var busStopDetail = BusStopDetail.fromJson(busStopData);
    if(busStopDetailMap == null){
      busStopDetailMap = ObservableMap();
    }
    busStopDetailMap[stopId] = busStopDetail;
  }

  @observable
  ObservableMap<RouteStop, List<ETA>> ETAMap;

  @action
  void updateETAMap(String stopId, String routeCode ,List<Map<String, dynamic>> dataArray){
    List<ETA> inboundResult = List();
    List<ETA> outboundResult = List();

    for(Map<String, dynamic> data in dataArray){
      var eta = ETA.fromJson(data);
      if(eta.isInBound) {
        inboundResult.add(eta);
      }else{
        outboundResult.add(eta);
      }
    }
    if(ETAMap == null){
      ETAMap = ObservableMap();
    }
    ETAMap[RouteStop(routeCode, stopId, true)] = inboundResult;
    ETAMap[RouteStop(routeCode, stopId, false)] = outboundResult;

  }

  @observable
  ObservableList<RouteStop> bookmarkedRouteStops;

  @action
  Future<void> addRouteStopToBookmark(RouteStop routeStop) async{
    if(bookmarkedRouteStops == null){
      bookmarkedRouteStops = ObservableList<RouteStop>();
    }
    if(!bookmarkedRouteStops.contains(routeStop)) {
      bookmarkedRouteStops.add(routeStop);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (bookmarkedRouteStops != null && bookmarkedRouteStops.length > 0) {
       prefs.setString(CacheUtils.bookmarkedRouteStop, jsonEncode(bookmarkedRouteStops));
      } else {
        prefs.remove(CacheUtils.bookmarkedRouteStop);
      }
    }
  }

@action
  Future<void> removeRouteStopFromBookmark(RouteStop routeStop) async{
    if(bookmarkedRouteStops != null){
      bookmarkedRouteStops.removeWhere((element) => element == routeStop);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        if( bookmarkedRouteStops != null && bookmarkedRouteStops.length > 0) {
         prefs.setString( CacheUtils.bookmarkedRouteStop, jsonEncode(bookmarkedRouteStops));
        }

    }
  }

  @action
  void setRoutStopBookmarks(List<RouteStop> list){
    if(bookmarkedRouteStops == null){
      bookmarkedRouteStops = ObservableList<RouteStop>();
    }else {
      bookmarkedRouteStops.clear();
    }
    for(var routeStop in list){
      bookmarkedRouteStops.add(routeStop);
    }

  }
}