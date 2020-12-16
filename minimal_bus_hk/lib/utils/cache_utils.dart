import 'dart:convert';
import 'package:minimal_bus_hk/model/bus_route.dart';
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
  final int _defaultRoutesCacheExpiryDays = 7;
  final int _defaultRouteDetailsCacheExpiryDays = 7;
  final int _defaultBusStopDetailsCacheExpiryDays = 7;

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

  Future<bool> getRoutes() async {
    bool nwfbResult = await getRouteFor(NetworkUtil.companyCodeNWFB);
    bool ctbResult = await getRouteFor(NetworkUtil.companyCodeCTB);
    return nwfbResult && ctbResult;
  }

    Future<bool> getRouteFor(String companyCode) async {
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

      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds)){
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getRouteFor(companyCode);
        return code == 200;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getRouteFor(companyCode);
      return code == 200;

  }

  Future<bool> getRouteDetail(String routeCode, String companyCode, bool isInbound) async {
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
      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds)) {
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getRouteDetail(routeCode, companyCode, isInbound);
        return code == 200;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getRouteDetail(routeCode, companyCode, isInbound);
      return code == 200;

  }

  Future<bool> getBusStopDetail(String stopId) async {
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
      if(!_checkCacheContentExpired(cachedData, expiryDay * _dayInMicroseconds)) {
        return true;
      }else{
        var code = await  NetworkUtil.sharedInstance().getBusStopDetail(stopId);
        return code == 200;
      }
    }
      var code = await  NetworkUtil.sharedInstance().getBusStopDetail(stopId);
      return code == 200;
  }

  Future<void> getRouteAndStopsDetail(BusRoute route, bool isInbound) async {

    bool success = await getRouteDetail(route.routeCode, route.companyCode, isInbound);
    if(success){
      var routeStopsMap = isInbound? Stores.dataManager.inboundBusStopsMap:Stores.dataManager.outboundBusStopsMap;
      if(routeStopsMap != null && routeStopsMap.containsKey(route.routeCode)){
        for(var stop in routeStopsMap[route.routeCode]){
          if( Stores.dataManager.busStopDetailMap == null || !Stores.dataManager.busStopDetailMap.containsKey(stop.identifier)) {
            await getBusStopDetail(stop.identifier);
          }
        }
      }
    }
  }

  Future<void> getBookmarkedRouteStop() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String content = prefs.getString(bookmarkedRouteStop);
    List<RouteStop> list = List<RouteStop>();
    if(content != null){
        List<dynamic> decodedList = jsonDecode(content);
        for(var obj in decodedList) {
          list.add(RouteStop.fromJson(obj));
        }
    }

    Stores.dataManager.setRoutStopBookmarks(list);


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