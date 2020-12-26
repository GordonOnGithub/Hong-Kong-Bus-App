import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';

class ETAQuery{
  final String routeCode;
  final String stopId;
  final String companyCode;
  ETAQuery.fromBusStop(BusStop busStop) : routeCode = busStop.routeCode, stopId = busStop.identifier, companyCode = busStop.companyCode;
  ETAQuery.fromRouteStop(RouteStop routeStop) : routeCode = routeStop.routeCode, stopId = routeStop.stopId, companyCode = routeStop.companyCode;

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