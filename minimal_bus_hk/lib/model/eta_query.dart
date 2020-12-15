import 'package:minimal_bus_hk/model/route_stop.dart';

class ETAQuery{
  final String routeCode;
  final String stopId;

  ETAQuery.fromRouteStop(RouteStop routeStop) : routeCode = routeStop.routeCode, stopId = routeStop.stopId;

  bool operator ==(Object other){
    if(other is ETAQuery) {
      return routeCode == other.routeCode && stopId == other.stopId;
    }else{
      return false;
    }
  }

  @override
  int get hashCode {
    return "$routeCode$stopId".hashCode;
  }

}