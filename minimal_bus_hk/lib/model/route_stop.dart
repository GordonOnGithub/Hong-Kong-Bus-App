import 'package:minimal_bus_hk/model/eta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'route_stop.g.dart';
@JsonSerializable()
class RouteStop{
  final String routeCode;
  final String stopId;
  final String companyCode;
  final bool isInbound;
  final String serviceType;

  RouteStop( String routeCode, String stopId, String companyCode, bool isInbound, String serviceType ):routeCode = routeCode,this.stopId = stopId, this.companyCode = companyCode, this.isInbound = isInbound, this.serviceType = serviceType;


  bool operator ==(Object other){
    if(other is RouteStop) {
      return routeCode == other.routeCode && stopId == other.stopId && isInbound == other.isInbound && companyCode == other.companyCode && serviceType == other.serviceType;
    }else{
      return false;
    }
  }
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RouteStop.fromJson(Map<String, dynamic> json) => _$RouteStopFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RouteStopToJson(this);

  @override
  int get hashCode {
    return "$routeCode$stopId${isInbound?1:0}$companyCode".hashCode;
  }
  bool matchETA(ETA eta){
    return eta.routeCode == this.routeCode && eta.stopId == this.stopId && eta.isInbound == this.isInbound && eta.companyCode == this.companyCode;
  }

}