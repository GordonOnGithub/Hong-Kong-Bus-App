import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/directional_route.dart';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:minimal_bus_hk/utils/network_util.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
part 'data_manager.g.dart';

class DataManager = DataManagerBase with _$DataManager;

abstract class DataManagerBase with Store {
  @observable
  ObservableMap<String,List<BusRoute>>? companyRoutesMap;

  @computed
  ObservableList<BusRoute>? get routes{
    if(companyRoutesMap == null){
      return null;
    }

    var result = ObservableList<BusRoute>();
    for(var routes in companyRoutesMap!.values){
      for(var route in routes){
          result.add(route);
      }
    }
    return result;

  }

  @computed
  ObservableMap<String, BusRoute>? get routesMap{
    var result = ObservableMap<String, BusRoute>();
    if(routes != null) {
      for (var route in routes!) {
        result[route.routeUniqueIdentifier] = route;
      }
    }
    return result;
  }

  @action
  Future<void> setRoutes(List<Map<String, dynamic>> dataArray,String companyCode) async{

    ObservableList<BusRoute> result = ObservableList();
    for(Map<String, dynamic> data in dataArray){
      result.add(BusRoute.fromJson(data));
    }
    if(companyRoutesMap==null){
      companyRoutesMap = ObservableMap();
    }else if(companyRoutesMap!.containsKey(companyCode) && Stores.appConfig.downloadAllData == true){
      var oldData = companyRoutesMap![companyCode];
      if(oldData != null) {
        var delta = result.where((element) {
          return !oldData.contains(element);
        });

        if (delta.isNotEmpty) {
          NetworkUtil.sharedInstance().downloadNewRouteData(delta.toList());
        }
      }
    }
    companyRoutesMap![companyCode] = result;
  }


  @observable
  ObservableMap<String, ObservableList<DirectionalRoute>> stopRoutesMap = ObservableMap<String, ObservableList<DirectionalRoute>>();

  @action
  void updateStopRouteCodeMap(DirectionalRoute directionalRoute, ObservableList<BusStop> busStops){
    for(BusStop busStop in busStops){
      String identifier = busStop.identifier;
      bool containKey  = stopRoutesMap.containsKey(identifier);
      ObservableList<DirectionalRoute>? routeList = containKey ? stopRoutesMap[identifier] : ObservableList<DirectionalRoute>();
      if(routeList == null) { continue; }
      if(!containKey){
        stopRoutesMap[identifier] = routeList;
      }
      routeList.add(directionalRoute);

    }
  }

  @computed
  ObservableList<DirectionalRoute> get directionalRouteList {
    var result = ObservableList<DirectionalRoute>();
    if(routes != null) {
      for (var route in routes!) {
        if (route.bound.length == 0) {
          result.add(DirectionalRoute( route, true));
          result.add(DirectionalRoute( route, false));
        }else{
          result.add(DirectionalRoute( route, route.bound == "I"));
        }
      }
    }
    return result;
  }

  @computed
  ObservableList<DirectionalRoute> get directionalRouteListOfNWFBAndCTB {
    var result = ObservableList<DirectionalRoute>();
    if(routes != null) {
      for (var route in routes!) {
        if (route.companyCode != NetworkUtil.companyCodeKMB) {
          result.add(DirectionalRoute( route, true));
          result.add(DirectionalRoute( route, false));
        }
      }
    }
    return result;
  }

  @computed
  ObservableList<DirectionalRoute> get directionalRouteListOfKMB {
    var result = ObservableList<DirectionalRoute>();
    if(routes != null) {
      for (var route in routes!) {
        if (route.companyCode == NetworkUtil.companyCodeKMB) {
          result.add(DirectionalRoute( route, route.bound == "I"));
        }
      }
    }
    return result;
  }

  @observable
  ObservableMap<String, List<BusStop>>? inboundBusStopsMap;
  @observable
  ObservableMap<String, List<BusStop>>? outboundBusStopsMap;

  Map<String, List<BusStop>>? _tmpInboundBusStopsMap;
  Map<String, List<BusStop>>? _tmpOutboundBusStopsMap;

  @action
  Future<void> updateBusStopsMap(String routeCode, String companyCode, bool isInbound, List<Map<String, dynamic>> dataArray, {bool saveInTmp = false}) async{
    ObservableList<BusStop> result = ObservableList();
    for(Map<String, dynamic> data in dataArray){
      result.add(BusStop.fromJson(data));
    }
    String routeUniqueIdentifier = "${routeCode}_$companyCode";
    if(routesMap!.containsKey(routeUniqueIdentifier)) {
      BusRoute? route =  routesMap![routeUniqueIdentifier];
      if (route == null) { return; }
      DirectionalRoute directionalRoute = DirectionalRoute( route, isInbound);
      updateStopRouteCodeMap(directionalRoute, result);
    }
    if(saveInTmp){
      if (isInbound) {
        if (_tmpInboundBusStopsMap == null) {
          _tmpInboundBusStopsMap = Map();
        }
        _tmpInboundBusStopsMap![routeUniqueIdentifier] = result;
      } else {
        if (_tmpOutboundBusStopsMap == null) {
          _tmpOutboundBusStopsMap = Map();
        }
        _tmpOutboundBusStopsMap![routeUniqueIdentifier] = result;
      }
    }else {
      if (isInbound) {
        if (inboundBusStopsMap == null) {
          inboundBusStopsMap = ObservableMap();
        }
        inboundBusStopsMap![routeUniqueIdentifier] = result;
      } else {
        if (outboundBusStopsMap == null) {
          outboundBusStopsMap = ObservableMap();
        }
        outboundBusStopsMap![routeUniqueIdentifier] = result;
      }
    }
  }

  @observable
  ObservableMap<String, BusStopDetail>? busStopDetailMap;
  Map<String, BusStopDetail>? _tmpBusStopDetailMap;

  @action
  void updateBusStopDetailMapFromList(List<Map<String, dynamic>> busStopDataList){
    Map<String, BusStopDetail> tmpBusStopDetailMap = Map();
    for (Map<String, dynamic> busStopData in busStopDataList) {
      String stopId = busStopData["stop"];
      if (stopId != null) {
        var busStopDetail = busStopData.keys.length > 0 ? BusStopDetail
            .fromJson(
            busStopData) : BusStopDetail.invalid(stopId);
        tmpBusStopDetailMap[stopId] = busStopDetail;
      }
    }
    if (_tmpBusStopDetailMap == null) {
      _tmpBusStopDetailMap = Map();
    }
    _tmpBusStopDetailMap!.addAll(tmpBusStopDetailMap);
  }

  @action
  void updateBusStopDetailMap(String stopId, Map<String, dynamic> busStopData, {bool saveInTmp = false}){
    var busStopDetail = busStopData.keys.length > 0 ? BusStopDetail.fromJson(busStopData) : BusStopDetail.invalid(stopId);

    if(saveInTmp) {
      if (_tmpBusStopDetailMap == null) {
        _tmpBusStopDetailMap = Map();
      }
      _tmpBusStopDetailMap![stopId] = busStopDetail;
    }else{
      if (busStopDetailMap == null) {
        busStopDetailMap = ObservableMap();
      }
      busStopDetailMap![stopId] = busStopDetail;
    }
  }

  @action
  void applyTmpBusStopsDetailData(){
    if (busStopDetailMap == null) {
      busStopDetailMap = ObservableMap();
    }
    if(_tmpBusStopDetailMap != null) {
      busStopDetailMap!.addAll(_tmpBusStopDetailMap!);
      _tmpBusStopDetailMap!.clear();
    }
  }

  @action
  void applyTmpBusStopsData(){
    if (inboundBusStopsMap == null) {
      inboundBusStopsMap = ObservableMap();
    }

    if(_tmpInboundBusStopsMap != null) {
      inboundBusStopsMap!.addAll(_tmpInboundBusStopsMap!);
      _tmpInboundBusStopsMap!.clear();
    }

    if (outboundBusStopsMap == null) {
      outboundBusStopsMap = ObservableMap();
    }
    if(_tmpOutboundBusStopsMap != null) {
      outboundBusStopsMap!.addAll(_tmpOutboundBusStopsMap!);
      _tmpOutboundBusStopsMap!.clear();
    }
  }

  @observable
  ObservableMap<RouteStop, List<ETA>>? ETAMap;

  @action
  void updateETAMap(String stopId, String routeCode, String companyCode, String serviceType, List<Map<String, dynamic>> dataArray){
    List<ETA> inboundResult = [];
    List<ETA> outboundResult = [];

    for(Map<String, dynamic> data in dataArray) {
      if (data["eta"] != null) {
        var eta = ETA.fromJson(data);
        if (eta.isInbound) {
          inboundResult.add(eta);
        } else {
          outboundResult.add(eta);
        }
      }
    }
    if(ETAMap == null){
      ETAMap = ObservableMap();
    }
    ETAMap![RouteStop(routeCode, stopId, companyCode, true, serviceType)] = inboundResult;
    ETAMap![RouteStop(routeCode, stopId, companyCode, false, serviceType)] = outboundResult;

  }

  @observable
  ObservableList<RouteStop>? bookmarkedRouteStops;
  bool bookmarkUpdating = false;
  bool savedDataNotUpdated = false;
  @action
  Future<void> saveRouteStopToBookmark() async{
    if (bookmarkUpdating){
      savedDataNotUpdated = true;
      return;
    }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bookmarkUpdating = true;
      if (bookmarkedRouteStops != null && bookmarkedRouteStops!.length > 0) {
         prefs.setString(CacheUtils.bookmarkedRouteStop, jsonEncode(bookmarkedRouteStops)).then((value) {
          bookmarkUpdating = false;
          if(savedDataNotUpdated){
            savedDataNotUpdated = false;
            saveRouteStopToBookmark();
          }
        });
      } else {
         prefs.remove(CacheUtils.bookmarkedRouteStop).then((value) {
          bookmarkUpdating = false;
          if(savedDataNotUpdated){
            savedDataNotUpdated = false;
            saveRouteStopToBookmark();
          }
        });
      }
  }

  @action
  Future<void> addRouteStopToBookmark(RouteStop routeStop) async{
    if(bookmarkedRouteStops == null){
      bookmarkedRouteStops = ObservableList<RouteStop>();
    }
    if(!bookmarkedRouteStops!.contains(routeStop)) {
      bookmarkedRouteStops!.add(routeStop);
      if (bookmarkUpdating){
        savedDataNotUpdated = true;
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bookmarkUpdating = true;
      if (bookmarkedRouteStops != null && bookmarkedRouteStops!.length > 0) {
       prefs.setString(CacheUtils.bookmarkedRouteStop, jsonEncode(bookmarkedRouteStops)).then((value) {
         bookmarkUpdating = false;
         if(savedDataNotUpdated){
           savedDataNotUpdated = false;
           saveRouteStopToBookmark();
         }
       });
      } else {
        prefs.remove(CacheUtils.bookmarkedRouteStop).then((value) {
          bookmarkUpdating = false;
          if(savedDataNotUpdated){
            savedDataNotUpdated = false;
            saveRouteStopToBookmark();
          }
        });
      }
    }
  }

@action
  Future<void> removeRouteStopFromBookmark(RouteStop routeStop) async{

    if(bookmarkedRouteStops != null){
      bookmarkedRouteStops!.removeWhere((element) => element == routeStop);
      if (bookmarkUpdating){
        savedDataNotUpdated = true;
        return;
      }
        SharedPreferences prefs = await SharedPreferences.getInstance();
      bookmarkUpdating = true;
      if( bookmarkedRouteStops != null && bookmarkedRouteStops!.length > 0) {
         prefs.setString( CacheUtils.bookmarkedRouteStop, jsonEncode(bookmarkedRouteStops)).then((value) {
           bookmarkUpdating = false;
           if(savedDataNotUpdated){
             savedDataNotUpdated = false;
             saveRouteStopToBookmark();
           }
         });
        } else {
        prefs.remove(CacheUtils.bookmarkedRouteStop).then((value) {
          bookmarkUpdating = false;
          if(savedDataNotUpdated){
            savedDataNotUpdated = false;
            saveRouteStopToBookmark();
          }
        });
      }
    }
  }

  @action
  void setRoutStopBookmarks(List<RouteStop> list){
    if(bookmarkedRouteStops == null){
      bookmarkedRouteStops = ObservableList<RouteStop>();
    }else {
      bookmarkedRouteStops!.clear();
    }
    for(var routeStop in list){
      bookmarkedRouteStops!.add(routeStop);
    }
  }

  @observable
  int allDataFetchCount = 0;

  @action
  void addAllDataFetchCount(int increment){
    allDataFetchCount += increment;
    // debugPrint("allDataFetchCount: $allDataFetchCount");
  }

  @observable
  int totalDataCount = 0;

  @action
  void setTotalDataCount(int count){
    totalDataCount = count;
  }
  @observable
  int lastFetchDataCompleteTimestamp = 0;

  @action
  void setLastFetchDataCompleteTimestamp(int timestamp){
    lastFetchDataCompleteTimestamp = timestamp;
  }

}