import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';

class ETAQuery{
  final String routeCode;
  final String stopId;
  final String companyCode;
  final String serviceType;
  ETAQuery.fromBusStop(BusStop busStop) : routeCode = busStop.routeCode, stopId = busStop.identifier, companyCode = busStop.companyCode, serviceType = busStop.serviceType;
  ETAQuery.fromRouteStop(RouteStop routeStop) : routeCode = routeStop.routeCode, stopId = routeStop.stopId, companyCode = routeStop.companyCode, serviceType = routeStop.serviceType;

  bool operator ==(Object other){
    if(other is ETAQuery) {
      return routeCode == other.routeCode && stopId == other.stopId && serviceType == other.serviceType;
    }else{
      return false;
    }
  }

  @override
  int get hashCode {
    return "$routeCode$stopId$serviceType".hashCode;
  }

}