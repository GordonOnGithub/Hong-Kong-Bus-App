import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/model/eta_query.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/utils/network_util.dart';
import 'package:mobx/mobx.dart';
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

  String getStopListCacheKey( String companyCode){
    return "${_routeDetailsCacheKey}_stopList_$companyCode}";
  }

  String getRouteDetailsCacheKey(String routeCode, String companyCode, bool isInbound){
    return "${_routeDetailsCacheKey}_${companyCode}_${routeCode}_${isInbound ? "I":"O"}";
  }

  String getBusStopDetailCacheKey(String stopId, String companyCode){
    return "${_busStopDetailCacheKey}_$stopId${companyCode == NetworkUtil.companyCodeKMB? "_$companyCode" : ""}";//backward compatibility, no company code needed for CTB/NWFB
  }

  bool _isFetchingAllData = false;


  Future<void> fetchAllData() async{
    if(_isFetchingAllData) return;
    _isFetchingAllData = true;
    Stores.dataManager.addAllDataFetchCount(0);


    await getRoutes();
    var routes = Stores.dataManager.routes;
    if(routes != null){
      Stores.dataManager.setTotalDataCount((Stores.dataManager.companyRoutesMap[NetworkUtil.companyCodeNWFB].length + Stores.dataManager.companyRoutesMap[NetworkUtil.companyCodeCTB].length) * 4 +
          Stores.dataManager.companyRoutesMap[NetworkUtil.companyCodeKMB].length + 1 ); //assume every route of NWFB/CTB has inbound & outbound route , only KMB has provide if their routes are inbound/outbound
      List<Future<bool>> futures = [];

      await getStopListFor(NetworkUtil.companyCodeKMB);

      for(var route in routes) {
        if(Stores.appConfig.downloadAllData != true){
          _isFetchingAllData = false;
          return;
        }

        if (route.bound.length == 0) {//no direction specified
          futures.add(CacheUtils.sharedInstance().getRouteDetail(
              route.routeCode, route.companyCode, true, route.serviceType,
              saveInTmp: true));
          futures.add(CacheUtils.sharedInstance().getRouteDetail(
              route.routeCode, route.companyCode, false, route.serviceType,
              saveInTmp: true));
        }else{
          futures.add(CacheUtils.sharedInstance().getRouteDetail(
              route.routeCode, route.companyCode, route.bound == "I", route.serviceType,
              saveInTmp: true));
        }
        if(futures.length > 19) {
          await Future.wait(futures);
          Stores.dataManager.addAllDataFetchCount(futures.length);
          futures = [];
        }
      }
      if(futures.length > 0) {
        await Future.wait(futures);
        Stores.dataManager.addAllDataFetchCount(futures.length);
        futures = [];
      }
      Stores.dataManager.applyTmpBusStopsData();

      Set<String> stopIdSet = Set();

      var inboundBusStopsMap = Map.from(Stores.dataManager.inboundBusStopsMap);
      var outboundBusStopsMap =  Map.from(Stores.dataManager.outboundBusStopsMap);
      //re-evaluate the progress count
      Stores.dataManager.setTotalDataCount( (Stores.dataManager.companyRoutesMap[NetworkUtil.companyCodeNWFB].length + Stores.dataManager.companyRoutesMap[NetworkUtil.companyCodeCTB].length) * 2 + Stores.dataManager.companyRoutesMap[NetworkUtil.companyCodeKMB].length + 1 + (Stores.dataManager.inboundBusStopsMap.length + Stores.dataManager.outboundBusStopsMap.length));
     // log("revised data count: ${Stores.dataManager.totalDataCount}");
      for(var list in inboundBusStopsMap.values){
        if(Stores.appConfig.downloadAllData != true){
          _isFetchingAllData = false;
          return;
        }
        List<Future<bool>> futures = [];
         for(var busStop in list){
           if (busStop.companyCode == NetworkUtil.companyCodeKMB){
             Stores.dataManager.addAllDataFetchCount(1);
             break;//no need to download KMB bus stop data individually
           }
           if(!stopIdSet.contains(busStop.identifier)) {
             futures.add(CacheUtils.sharedInstance().getBusStopDetail(
                 busStop.identifier, busStop.companyCode, saveInTmp: true));
             stopIdSet.add(busStop.identifier);
           }
         }

        await Future.wait(futures);
        Stores.dataManager.addAllDataFetchCount(1);
      }
      stopIdSet.clear();
      for(var list in outboundBusStopsMap.values){
        if(Stores.appConfig.downloadAllData != true){
          _isFetchingAllData = false;
          return;
        }
        List<Future<bool>> futures = [];
        for(var busStop in list){
          if (busStop.companyCode == NetworkUtil.companyCodeKMB){
            Stores.dataManager.addAllDataFetchCount(1);
            break;//no need to download KMB bus stop data individually
          }
          if(!stopIdSet.contains(busStop.identifier)) {
            futures.add(CacheUtils.sharedInstance().getBusStopDetail(
                busStop.identifier,busStop.companyCode, saveInTmp: true));
            stopIdSet.add(busStop.identifier);
          }
        }

        await Future.wait(futures);
        Stores.dataManager.addAllDataFetchCount(1);
      }
    }
    //log("Stores.dataManager.allDataFetchCount: ${ Stores.dataManager.allDataFetchCount}");
    Stores.dataManager.applyTmpBusStopsDetailData();
    Stores.dataManager.setLastFetchDataCompleteTimestamp( DateTime.now().millisecondsSinceEpoch);
    _isFetchingAllData = false;
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
      if(Stores.dataManager.companyRoutesMap == null || !Stores.dataManager.companyRoutesMap.containsKey(companyCode)) {
        await NetworkUtil.sharedInstance().parseRouteData(cachedData, companyCode);
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

  Future<bool> getStopListFor(String companyCode, {bool silentUpdate = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString("${getStopListCacheKey(companyCode)}");
    var expiryDay = prefs.getInt(routesCacheExpiryDaysKey);

    if(expiryDay == null || expiryDay < 1){
      expiryDay = _defaultRoutesCacheExpiryDays;
    }

    if(content != null){
      Map<String, dynamic> cachedData = jsonDecode(content);
      await NetworkUtil.sharedInstance().parseStopListData(cachedData, companyCode);

      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds) && !silentUpdate){
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getStopListFor(companyCode);
        return code == 200 || silentUpdate;
      }
    }
    var code = await  NetworkUtil.sharedInstance().getStopListFor(companyCode);
    return code == 200;
  }

  Future<bool> getRouteDetail(String routeCode, String companyCode, bool isInbound, String serviceType, { bool silentUpdate = false, bool saveInTmp = false}) async {
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
        await NetworkUtil.sharedInstance().parseRouteDetail(
            routeCode, companyCode, isInbound, cachedData,  saveInTmp: saveInTmp);
      }
      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds) && !silentUpdate) {
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getRouteDetail(routeCode, companyCode, isInbound, serviceType, saveInTmp: saveInTmp);
        return code == 200 || silentUpdate;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getRouteDetail(routeCode, companyCode, isInbound, serviceType, saveInTmp: saveInTmp);
      return code == 200;

  }

  Future<bool> getBusStopDetail(String stopId,String companyCode, { bool silentUpdate = false, bool saveInTmp = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString(getBusStopDetailCacheKey(stopId, companyCode));
    var expiryDay = prefs.getInt(busStopDetailsCacheExpiryDaysKey);

    if(expiryDay == null || expiryDay < 1){
      expiryDay = _defaultBusStopDetailsCacheExpiryDays;
    }
    if(content != null){
      Map<String, dynamic> cachedData = jsonDecode(content);
      if(Stores.dataManager.busStopDetailMap == null || !Stores.dataManager.busStopDetailMap.containsKey(stopId)) {
        await NetworkUtil.sharedInstance().parseBusStopDetail(stopId,companyCode, cachedData, saveInTmp: saveInTmp);
      }
      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds) && !silentUpdate) {
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getBusStopDetail(stopId, companyCode, saveInTmp: saveInTmp);
        return code == 200 || !silentUpdate;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getBusStopDetail(stopId, companyCode, saveInTmp: saveInTmp);
      return code == 200;
  }

  Future<bool> getRouteAndStopsDetail(BusRoute route, bool isInbound,  {bool silentUpdate = false}) async {

    bool success = await getRouteDetail(route.routeCode, route.companyCode, isInbound, route.serviceType, silentUpdate: silentUpdate);
    if(success){
      var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap:Stores.dataManager.outboundBusStopsMap;
      if(routeStopsMap != null && routeStopsMap.containsKey(route.routeUniqueIdentifier)){
        var futures = <Future<bool>>[];

        for(var stop in routeStopsMap[route.routeUniqueIdentifier]){
          if( Stores.dataManager.busStopDetailMap == null || !Stores.dataManager.busStopDetailMap.containsKey(stop.identifier)) {
            futures.add(getBusStopDetail(stop.identifier,  stop.companyCode, silentUpdate: silentUpdate));
          }
        }
        List<bool> results = await Future.wait(futures);
        for(bool result in results){
          if(!result){
            success = false;
            break;
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
          if (obj["serviceType"] == null){
            obj["serviceType"] = "";
          }
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
      List <Future<bool>> futures = [];
      for(var query in queries){
        result = await getETA(query) && result;
        futures.add(getETA(query));
      }
      await Future.wait(futures);
    }
    return result;
  }

  Future<void> getETAForRoute(BusRoute route, bool isInbound) async{
    var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
    if(routeStopsMap == null){
      return;
    }
    var busStopsList = routeStopsMap[route.routeUniqueIdentifier];
    if(busStopsList == null){
      return;
    }
   List <Future<bool>> futures = [];
    for(BusStop busStop in busStopsList){
      var query = ETAQuery.fromBusStop(busStop);
      futures.add(getETA(query));
    }
    await Future.wait(futures);
  }

  Future<bool> getETA(ETAQuery query) async {
    if(Stores.dataManager.routesMap != null && Stores.dataManager.routesMap.containsKey(query.routeUniqueIdentifier) &&
        Stores.dataManager.ETAMap != null && Stores.dataManager.ETAMap.containsKey( Stores.dataManager.routesMap[query.routeUniqueIdentifier])){
      List<ETA> ETAs = Stores.dataManager.ETAMap[Stores.dataManager.routesMap[query.routeUniqueIdentifier]];
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