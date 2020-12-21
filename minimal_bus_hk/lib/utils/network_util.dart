import 'dart:io';

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

  final String _routeAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route";
  final String _routeDataAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route-stop";
  final String _busStopDetailAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/stop";
  final String _etaAPI = "https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta";

  static final String companyCodeNWFB = "nwfb";
  static final String companyCodeCTB = "ctb";

  Future<bool> getRoute() async {
    int nwfbResult = await getRouteFor(companyCodeNWFB);
    int ctbResult = await getRouteFor(companyCodeCTB);
    return nwfbResult == 200 &&  ctbResult == 200;
  }

    Future<int> getRouteFor(String companyCode) async {
    var response = await http.get("$_routeAPI/$companyCode").catchError((e){
        return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if(code == 200){
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData.containsKey("data")){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("${CacheUtils.routesCacheKey}/$companyCode", response.body);
          parseRouteData(responseData, companyCode);
        }
    }else{
      if(Stores.dataManager.routes == null) {
        Stores.dataManager.setRoutes([], companyCode);
      }
    }
    return code;
  }

  void parseRouteData(Map<String, dynamic> responseData, companyCode){
    var list = responseData["data"] as List<dynamic>;
    var dataList = <Map<String, dynamic>>[];
    for(var data in list){
      if(data is Map<String, dynamic>){
        dataList.add(data);
      }
    }
    Stores.dataManager.setRoutes(dataList, companyCode);
  }

  Future<int> getRouteDetail(String routeCode, String companyCode, bool isInbound) async {
    var response = await http.get(
        "$_routeDataAPI/$companyCode/$routeCode/${isInbound ? "inbound" : "outbound"}").catchError((e){
      return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if (code == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey("data")) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(CacheUtils.sharedInstance().getRouteDetailsCacheKey(routeCode, companyCode,isInbound), response.body);
        parseRouteDetail(routeCode,  companyCode, isInbound, responseData);
      }
    }else{
      if((Stores.dataManager.inboundBusStopsMap == null && isInbound)||(Stores.dataManager.outboundBusStopsMap == null && !isInbound)) {
        Stores.dataManager.updateBusStopsMap(routeCode, isInbound, []);
      }
    }
    return code;
  }

  void parseRouteDetail(String routeCode, String companyCode, bool isInbound, Map<String, dynamic> responseData){
    var list = responseData["data"] as List<dynamic>;
    var dataList = <Map<String, dynamic>>[];
    for (var data in list) {
      if (data is Map<String, dynamic>) {
        dataList.add(data);
      }
    }
    Stores.dataManager.updateBusStopsMap(routeCode, isInbound, dataList);
  }

  Future<int> getBusStopDetail(String stopId) async {
    var response = await http.get(
        "$_busStopDetailAPI/$stopId").catchError((e){
      return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
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

  Future<int> getETA(ETAQuery query) async {
    var response = await http.get("$_etaAPI/${query.companyCode}/${query.stopId}/${query.routeCode}").catchError((e){
      return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if(code == 200){
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if(responseData.containsKey("data")){
        var list = responseData["data"] as List<dynamic>;
        var dataList = <Map<String, dynamic>>[];
        for(var data in list){
          if(data is Map<String, dynamic>){
            dataList.add(data);
          }
        }
        Stores.dataManager.updateETAMap(query.stopId, query.routeCode,query.companyCode, dataList);
      }
    }
    return code;
  }

  Future<void> getETAForRouteStops() async{
    var queries = <ETAQuery>[];
    if(Stores.dataManager.bookmarkedRouteStops == null)return;
    List<RouteStop> list = List.from(Stores.dataManager.bookmarkedRouteStops);
    for(RouteStop routeStop in list){

      var query = ETAQuery.fromRouteStop(routeStop);
      if(!queries.contains(query)){
        queries.add(query);
      }

      for(var query in queries){
        await NetworkUtil.sharedInstance().getETA(query);
      }
    }
  }
}

