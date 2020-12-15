import 'package:http/http.dart' as http;
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:minimal_bus_hk/model/eta_query.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:minimal_bus_hk/utils/stores.dart';
class NetworkUtil{
  static NetworkUtil _sharedInstance;

  static NetworkUtil sharedInstance(){
    if(_sharedInstance == null){
      _sharedInstance = NetworkUtil._();
    }

    return _sharedInstance;
  }

  NetworkUtil._();

  final String _routeAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route/nwfb";
  final String _routeDataAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route-stop/nwfb";
  final String _busStopDetailAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/stop";
  final String _etaAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta/nwfb";
  Future<int> getRoute() async {
    var response = await http.get(_routeAPI);
    var code = response.statusCode;
    if(code == 200){
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData.containsKey("data")){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(CacheUtils.routesCacheKey, response.body);
          parseRouteData(responseData);
        }
    }else{
      if(Stores.dataManager.routes == null) {
        Stores.dataManager.setRoutes(List());
      }
    }
    return code;
  }

  void parseRouteData(Map<String, dynamic> responseData){
    var list = responseData["data"] as List<dynamic>;
    var dataList = List<Map<String, dynamic>>();
    for(var data in list){
      if(data is Map<String, dynamic>){
        dataList.add(data);
      }
    }
    Stores.dataManager.setRoutes(dataList);
  }

  Future<int> getRouteDetail(String routeCode, bool isInbound) async {
    var response = await http.get(
        "$_routeDataAPI/$routeCode/${isInbound ? "inbound" : "outbound"}");
    var code = response.statusCode;
    if (code == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey("data")) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(CacheUtils.sharedInstance().getRouteDetailsCacheKey(routeCode, isInbound), response.body);
        parseRouteDetail(routeCode, isInbound, responseData);
      }
    }else{
      if((Stores.dataManager.inboundBusStopsMap == null && isInbound)||(Stores.dataManager.outboundBusStopsMap == null && !isInbound)) {
        Stores.dataManager.updateBusStopsMap(routeCode, isInbound, List());
      }
    }
    return code;
  }

  void parseRouteDetail(String routeCode, bool isInbound, Map<String, dynamic> responseData){
    var list = responseData["data"] as List<dynamic>;
    var dataList = List<Map<String, dynamic>>();
    for (var data in list) {
      if (data is Map<String, dynamic>) {
        dataList.add(data);
      }
    }
    Stores.dataManager.updateBusStopsMap(routeCode, isInbound, dataList);
  }

  Future<int> getBusStopDetail(String stopId) async {
    var response = await http.get(
        "$_busStopDetailAPI/$stopId");
    var code = response.statusCode;
    if (code == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey("data")) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(CacheUtils.sharedInstance().getBusStopDetailCacheKey(stopId), response.body);
        parseBusStopDetail(stopId, responseData);
      }
    }
    return code;
  }

  void parseBusStopDetail(String stopId,  Map<String, dynamic> responseData ){
      var data = responseData["data"] as Map<String, dynamic>;
      Stores.dataManager.updateBusStopDetailMap(stopId, data);
  }

  Future<int> getETA(String routeCode, String stopId) async {
    var response = await http.get("$_etaAPI/$stopId/$routeCode");
    var code = response.statusCode;
    if(code == 200){
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if(responseData.containsKey("data")){
        var list = responseData["data"] as List<dynamic>;
        var dataList = List<Map<String, dynamic>>();
        for(var data in list){
          if(data is Map<String, dynamic>){
            dataList.add(data);
          }
        }
        Stores.dataManager.updateETAMap(stopId, routeCode, dataList);
      }
    }
    return code;
  }

  Future<void> getETAForRouteStops() async{
    var queries = List<ETAQuery>();
    if(Stores.dataManager.bookmarkedRouteStops == null)return;

    for(RouteStop routeStop in Stores.dataManager.bookmarkedRouteStops){

      var query = ETAQuery.fromRouteStop(routeStop);
      if(!queries.contains(query)){
        queries.add(query);
      }

      for(var query in queries){
        await NetworkUtil.sharedInstance().getETA(query.routeCode, query.stopId);
      }
    }
  }
}

