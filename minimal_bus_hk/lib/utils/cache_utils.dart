import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/model/eta_query.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
class CacheUtils{
  static final String routesCacheKey = "routes";
  static final String _routeDetailsCacheKey = "route_details_";
  static final String _busStopDetailCacheKey = "bus_stop_detail_";
  static final String bookmarkedRouteStop = "bookmarked_route_stop";

  static final String routesCacheExpiryDaysKey = "routes_cache_expiry_days_key";
  static final String routeDetailsCacheExpiryDaysKey = "route_details_expiry_days_key";
  static final String busStopDetailsCacheExpiryDaysKey = "bus_stop_details_expiry_days_key";

  static final int _dayInMicroseconds = 86400000;
  final int _defaultRoutesCacheExpiryDays = 14;
  final int _defaultRouteDetailsCacheExpiryDays = 14;
  final int _defaultBusStopDetailsCacheExpiryDays = 14;

  static CacheUtils _sharedInstance;

  static CacheUtils sharedInstance(){
    if(_sharedInstance == null){
      _sharedInstance = CacheUtils._();
    }

    return _sharedInstance;
  }

  CacheUtils._();

  String getRouteDetailsCacheKey(String routeCode, String companyCode, bool isInbound){
    return "${_routeDetailsCacheKey}_${companyCode}_${routeCode}_${isInbound ? "I":"O"}";
  }

  String getBusStopDetailCacheKey(String stopId){
    return "${_busStopDetailCacheKey}_$stopId";
  }

  Future<void> fetchAllData() async{
    await getRoutes();
    if(Stores.dataManager.routes != null){
      for(var route in Stores.dataManager.routes) {
        await CacheUtils.sharedInstance().getRouteDetail(
            route.routeCode, route.companyCode, true);
        await CacheUtils.sharedInstance().getRouteDetail(
            route.routeCode, route.companyCode, false);

        var inboundBusRouteCount = Stores.dataManager.inboundBusStopsMap != null? Stores.dataManager.inboundBusStopsMap.values.length : 0;
        var outboundBusRouteCount = Stores.dataManager.outboundBusStopsMap != null? Stores.dataManager.outboundBusStopsMap.values.length : 0;

        debugPrint("route data fetch progress: ${inboundBusRouteCount + outboundBusRouteCount}/${Stores.dataManager.routes.length * 2}");

      }
        int count = 0;
      for(var list in Stores.dataManager.inboundBusStopsMap.values){
          for(var busStop in list){
            await CacheUtils.sharedInstance().getBusStopDetail(busStop.identifier);
          }
          count += 1;
          debugPrint("bus stop data fetch progress: $count/${Stores.dataManager.routes.length * 2}");
      }
      for(var list in Stores.dataManager.outboundBusStopsMap.values){
        for(var busStop in list){
          await CacheUtils.sharedInstance().getBusStopDetail(busStop.identifier);
        }
        count += 1;
        debugPrint("bus stop data fetch progress: $count/${Stores.dataManager.routes.length * 2}");
      }
    }

  }

  Future<bool> getRoutes() async {
    bool result = true;

    for(var code in NetworkUtil.companyCodeList){
      result = await getRouteFor(code) && result;
    }
    return result;
  }

    Future<bool> getRouteFor(String companyCode, {bool silentUpdate = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString("$routesCacheKey/$companyCode");
    var expiryDay = prefs.getInt(routesCacheExpiryDaysKey);

    if(expiryDay == null || expiryDay < 1){
      expiryDay = _defaultRoutesCacheExpiryDays;
    }

    if(content != null){
      Map<String, dynamic> cachedData = jsonDecode(content);
      if(Stores.dataManager.routesMap == null || !Stores.dataManager.routesMap.containsKey(companyCode)) {
        NetworkUtil.sharedInstance().parseRouteData(cachedData, companyCode);
      }

      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds) && !silentUpdate){
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getRouteFor(companyCode);
        return code == 200 || silentUpdate;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getRouteFor(companyCode);
      return code == 200;

  }

  Future<bool> getRouteDetail(String routeCode, String companyCode, bool isInbound, {bool silentUpdate = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString(getRouteDetailsCacheKey(routeCode, companyCode, isInbound));
    var expiryDay = prefs.getInt(routeDetailsCacheExpiryDaysKey);

    if(expiryDay == null || expiryDay < 1){
      expiryDay = _defaultRouteDetailsCacheExpiryDays;
    }

    if(content != null){
      Map<String, dynamic> cachedData = jsonDecode(content);
      if((isInbound && (Stores.dataManager.inboundBusStopsMap == null || !Stores.dataManager.inboundBusStopsMap.containsKey(routeCode))) ||
          (!isInbound && (Stores.dataManager.outboundBusStopsMap == null || !Stores.dataManager.outboundBusStopsMap.containsKey(routeCode)))){
        NetworkUtil.sharedInstance().parseRouteDetail(
            routeCode, companyCode, isInbound, cachedData);
      }
      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds) && !silentUpdate) {
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getRouteDetail(routeCode, companyCode, isInbound);
        return code == 200 || silentUpdate;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getRouteDetail(routeCode, companyCode, isInbound);
      return code == 200;

  }

  Future<bool> getBusStopDetail(String stopId, {bool silentUpdate = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString(getBusStopDetailCacheKey(stopId));
    var expiryDay = prefs.getInt(busStopDetailsCacheExpiryDaysKey);

    if(expiryDay == null || expiryDay < 1){
      expiryDay = _defaultBusStopDetailsCacheExpiryDays;
    }
    if(content != null){
      Map<String, dynamic> cachedData = jsonDecode(content);
      if(Stores.dataManager.busStopDetailMap == null || !Stores.dataManager.busStopDetailMap.containsKey(stopId)) {
        NetworkUtil.sharedInstance().parseBusStopDetail(stopId, cachedData);
      }
      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds) && !silentUpdate) {
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getBusStopDetail(stopId);
        return code == 200 || !silentUpdate;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getBusStopDetail(stopId);
      return code == 200;
  }

  Future<bool> getRouteAndStopsDetail(BusRoute route, bool isInbound, {bool silentUpdate = false}) async {

    bool success = await getRouteDetail(route.routeCode, route.companyCode, isInbound, silentUpdate: silentUpdate);
    if(success){
      var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap:Stores.dataManager.outboundBusStopsMap;
      if(routeStopsMap != null && routeStopsMap.containsKey(route.routeCode)){
        for(var stop in routeStopsMap[route.routeCode]){
          if( Stores.dataManager.busStopDetailMap == null || !Stores.dataManager.busStopDetailMap.containsKey(stop.identifier)) {
            success = success && await getBusStopDetail(stop.identifier, silentUpdate: silentUpdate);
          }
        }
      }
    }
    return success;
  }

  Future<void> getBookmarkedRouteStop() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString(bookmarkedRouteStop);
    List<RouteStop> list = <RouteStop>[];
    if(content != null){
        List<dynamic> decodedList = jsonDecode(content);
        for(var obj in decodedList) {
          list.add(RouteStop.fromJson(obj));
        }
    }

    Stores.dataManager.setRoutStopBookmarks(list);
  }

  Future<bool> getETAForBookmarkedRouteStops() async{
    var queries = <ETAQuery>[];
    bool result = true;
    if(Stores.dataManager.bookmarkedRouteStops == null)return result;

    List<RouteStop> list = List.from(Stores.dataManager.bookmarkedRouteStops);
    for(RouteStop routeStop in list){

      var query = ETAQuery.fromRouteStop(routeStop);
      if(!queries.contains(query)){
        queries.add(query);
      }

      for(var query in queries){
        result = await getETA(query) && result;
      }
    }
    return result;
  }

  Future<void> getETAForRoute(BusRoute route, bool isInbound) async{
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
      await getETA(query);

    }
  }

  Future<bool> getETA(ETAQuery query) async {
    if(Stores.dataManager.routesMap != null && Stores.dataManager.routesMap.containsKey(query.routeCode) &&
        Stores.dataManager.ETAMap != null && Stores.dataManager.ETAMap.containsKey( Stores.dataManager.routesMap[query.routeCode])){
      List<ETA> ETAs = Stores.dataManager.ETAMap[Stores.dataManager.routesMap[query.routeCode]];
        if(ETAs.length > 0 &&  DateTime.now().millisecondsSinceEpoch - ETAs.first.dataTimestamp.millisecondsSinceEpoch  < Stores.appConfig.etaExpiryTimeMilliseconds && ETAs.first.status == ETAStatus.found){
          return true;
        }
    }
    var result = await NetworkUtil.sharedInstance().getETA(query);
    return result == 200;
  }

    bool _checkCacheContentExpired( Map<String, dynamic> cachedData, int expiryDuration ){
    var key = "generated_timestamp ";//API issue, there is an extra space in key
    if(!cachedData.containsKey(key)){
      return true;
    }
    if(cachedData["data"] is List) {
      var data = cachedData["data"] as List;
      if (data == null || data.length < 1) {
        return true;
      }
    }
    var dataTimestamp = DateTime.tryParse( cachedData[key]);
    if(dataTimestamp != null && (DateTime.now().millisecondsSinceEpoch - dataTimestamp.millisecondsSinceEpoch) < expiryDuration) {
      return false;
    }
    return true;
  }
}