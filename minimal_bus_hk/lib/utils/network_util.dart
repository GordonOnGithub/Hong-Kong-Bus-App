import 'package:http/http.dart' as http;
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:minimal_bus_hk/model/eta_query.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

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

  final Map<String, String> _routeAPIs = {companyCodeNWFB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route/nwfb", companyCodeCTB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route/ctb", companyCodeKMB : "https://data.etabus.gov.hk/v1/transport/kmb/route/"};
  final Map<String, String> _routeDataAPIs = {companyCodeNWFB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route-stop/nwfb/", companyCodeCTB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route-stop/ctb/", companyCodeKMB : "https://data.etabus.gov.hk/v1/transport/kmb/route-stop/"};
  final Map<String, String> _busStopDetailAPIs = {companyCodeNWFB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/stop/", companyCodeCTB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/stop/", companyCodeKMB : "https://data.etabus.gov.hk/v1/transport/kmb/stop/"};
  final Map<String, String> _etaAPIs = {companyCodeNWFB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta/nwfb/", companyCodeCTB : "https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta/ctb/", companyCodeKMB : "https://data.etabus.gov.hk/v1/transport/kmb/eta/"};
  final Map<String, String> _stopListAPIs = {companyCodeNWFB : "", companyCodeCTB : "", companyCodeKMB : "https://data.etabus.gov.hk/v1/transport/kmb/stop"};

  //Lantau bus
  final String _lantauBusRouteAPI = "https://rt.data.gov.hk/v1/transport/nlb/route.php?action=list";

  static const String companyCodeNWFB = "nwfb";
  static const String companyCodeCTB = "ctb";
  static const String companyCodeKMB = "kmb";
  static final List<String> companyCodeList = [companyCodeCTB, companyCodeNWFB, companyCodeKMB];

  Future<bool> getRoute() async {
    bool result = true;

    for(var code in companyCodeList){
      result = (await getRouteFor(code) == 200) && result;
    }
    return result;
  }

    Future<int> getRouteFor(String companyCode) async {
    var result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.wifi && result != ConnectivityResult.mobile){
      if(Stores.dataManager.routes == null) {
        await Stores.dataManager.setRoutes([], companyCode);
      }
      return -1;
    }

    var response = await http.get(_routeAPIs[companyCode]).catchError((e){
        return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if(code == 200){
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData.containsKey("data")){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("${CacheUtils.routesCacheKey}/$companyCode", response.body);
          await parseRouteData(responseData, companyCode);
        }
    }else{
      if(Stores.dataManager.routes == null) {
        await Stores.dataManager.setRoutes([], companyCode);
      }
    }
    return code;
  }

  Future<void> parseRouteData(Map<String, dynamic> responseData, companyCode, {bool saveInTmp = false}) async{
    var list = responseData["data"] as List<dynamic>;
    var dataList = <Map<String, dynamic>>[];
    for(var data in list){
      if(data is Map<String, dynamic>){
        if(data["co"] == null){
          data["co"] = companyCode;
        }
        dataList.add(data);
      }
    }
    await Stores.dataManager.setRoutes(dataList, companyCode);
  }

  Future<int> getStopListFor(String companyCode) async {
    var result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.wifi && result != ConnectivityResult.mobile){
      if(Stores.dataManager.routes == null) {
        await Stores.dataManager.setRoutes([], companyCode);
      }
      return -1;
    }

    var response = await http.get(_stopListAPIs[companyCode]).catchError((e){
      return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if(code == 200){
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if(responseData.containsKey("data")){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(CacheUtils.sharedInstance().getStopListCacheKey(companyCode), response.body);
        await parseStopListData(responseData, companyCode, saveInTmp: true);
      }
    }else{

    }
    return code;
  }

  Future<void> parseStopListData(Map<String, dynamic> responseData, companyCode, {bool saveInTmp = false}) async{
    var list = responseData["data"] as List<dynamic>;
    for(var data in list){
      if(data is Map<String, dynamic>){
        String stopId = data["stop"];
        if(stopId != null) {
          if (data["co"] == null) {
            data["co"] = companyCode;
          }
        }
      }
    }
    Stores.dataManager.updateBusStopDetailMapFromList(list);
  }

  Future<int> getRouteDetail(String routeCode, String companyCode, bool isInbound, String serviceType, { bool saveInTmp = false}) async {
    var result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.wifi && result != ConnectivityResult.mobile){
      if((Stores.dataManager.inboundBusStopsMap == null && isInbound)||(Stores.dataManager.outboundBusStopsMap == null && !isInbound)) {
        await Stores.dataManager.updateBusStopsMap(routeCode, isInbound, [], saveInTmp: saveInTmp);
      }
      return -1;
    }
    var url = _routeDataAPIs[companyCode.toLowerCase()];
    var response = await http.get(
        "$url$routeCode/${ isInbound ? "inbound" : "outbound"}/$serviceType").catchError((e){
      return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if (code == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey("data") && responseData["data"] is List) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(CacheUtils.sharedInstance().getRouteDetailsCacheKey(routeCode, companyCode,isInbound), response.body);
        await parseRouteDetail(routeCode,  companyCode, isInbound, responseData, saveInTmp: saveInTmp);
      }
    }else{
      if((Stores.dataManager.inboundBusStopsMap == null && isInbound)||(Stores.dataManager.outboundBusStopsMap == null && !isInbound)) {
        await Stores.dataManager.updateBusStopsMap(routeCode, isInbound, [], saveInTmp: saveInTmp);
      }
    }
    return code;
  }

  Future<void> parseRouteDetail(String routeCode, String companyCode, bool isInbound, Map<String, dynamic> responseData, {bool saveInTmp = false}) async{
    var list = responseData["data"] as List<dynamic>;
    var dataList = <Map<String, dynamic>>[];
    for (var data in list) {
      if (data is Map<String, dynamic>) {
        if (data["co"] == null){
          data["co"] = companyCode;
        }
        dataList.add(data);
      }
    }
    await Stores.dataManager.updateBusStopsMap(routeCode, isInbound, dataList, saveInTmp: saveInTmp);
  }

    Future<int> getBusStopDetail(String stopId, String companyCode, {bool saveInTmp = false}) async {
    var result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.wifi && result != ConnectivityResult.mobile){
      return -1;
    }
    var response = await http.get(
        "${_busStopDetailAPIs[companyCode.toLowerCase()]}$stopId").catchError((e){
      return null;// connectivity issue
    });
    var code = response != null? response.statusCode : -1;
    if (code == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey("data")) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(CacheUtils.sharedInstance().getBusStopDetailCacheKey(stopId, companyCode), response.body);
        await parseBusStopDetail(stopId, responseData, saveInTmp: saveInTmp);
      }
    }
    return code;
  }

  Future<void> parseBusStopDetail(String stopId,  Map<String, dynamic> responseData, {bool saveInTmp = false} ) async{
      var data = responseData["data"] as Map<String, dynamic>;
      Stores.dataManager.updateBusStopDetailMap(stopId, data, saveInTmp: saveInTmp);
  }

  Future<int> getETA(ETAQuery query) async {
    var result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.wifi && result != ConnectivityResult.mobile){
      return -1;
    }
    var response = await http.get("${_etaAPIs[query.companyCode.toLowerCase()]}${query.stopId}/${query.routeCode}/${query.serviceType}").catchError((e){
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
            if (data["stop"] == null){
              data["stop"] = query.stopId;
            }
            dataList.add(data);
          }
        }
        Stores.dataManager.updateETAMap(query.stopId, query.routeCode,query.companyCode, query.serviceType, dataList);
      }
    }
    return code;
  }

  Future<void> getETAForBookmarkedRouteStops() async{
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

  Future<void> getETAForRoute(BusRoute route, bool isInbound) async{
    var queries = <ETAQuery>[];
    var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
    if(routeStopsMap == null){
      return;
    }
    var busStopsList = routeStopsMap[route.routeCode];
    if(busStopsList == null){
      return;
    }
    for(BusStop busStop in busStopsList){

      var query = ETAQuery.fromBusStop(busStop);
      if(!queries.contains(query)){
        queries.add(query);
      }

      for(var query in queries){
        await NetworkUtil.sharedInstance().getETA(query);
      }
    }
  }

  Future<void> downloadNewRouteData(List<BusRoute> newRoutes) async{
    for(BusRoute b in newRoutes){
      if (b.bound.length == 0) {
        await getRouteDetail(b.routeCode, b.companyCode, true, b.serviceType);
        await getRouteDetail(b.routeCode, b.companyCode, false, b.serviceType);
      }else{
        await getRouteDetail(b.routeCode, b.companyCode, b.bound == "I", b.serviceType);
      }
     Set<String> stopIdSet = Set();

     List<Future<bool>> futures = [];

     if( Stores.dataManager.inboundBusStopsMap.containsKey(b.routeCode)) {
       for (BusStop s in Stores.dataManager.inboundBusStopsMap[b.routeCode]) {
         if(!stopIdSet.contains(s.identifier)) {
           stopIdSet.add(s.identifier);
           futures.add(CacheUtils.sharedInstance().getBusStopDetail(s.identifier, s.companyCode));
         }
       }
     }
     if( Stores.dataManager.outboundBusStopsMap.containsKey(b.routeCode)) {
       for (BusStop s in Stores.dataManager.outboundBusStopsMap[b.routeCode]) {
         if(!stopIdSet.contains(s.identifier)) {
           stopIdSet.add(s.identifier);
           futures.add(CacheUtils.sharedInstance().getBusStopDetail(s.identifier, s.companyCode));
         }
       }
     }

     await Future.wait(futures);
    }
  }

}

