// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteStop _$RouteStopFromJson(Map<String, dynamic> json) {
  return RouteStop(
    json['routeCode'] as String,
    json['stopId'] as String,
    json['companyCode'] as String,
    json['isInbound'] as bool,
    json['serviceType'] as String,
  );
}

Map<String, dynamic> _$RouteStopToJson(RouteStop instance) => <String, dynamic>{
      'routeCode': instance.routeCode,
      'stopId': instance.stopId,
      'companyCode': instance.companyCode,
      'isInbound': instance.isInbound,
      'serviceType': instance.serviceType,
    };
