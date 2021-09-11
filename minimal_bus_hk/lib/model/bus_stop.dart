
class BusStop{
  final String routeCode;
  final String companyCode;
  final int sequence;
  final String identifier;
  final DateTime timestamp;
  final String serviceType;

  BusStop.fromJson(Map<String, dynamic> json):
        routeCode = json["route"],
        companyCode = (json["co"] as String).toLowerCase(),
        sequence =  (json["seq"] is int)? json["seq"]: (int.tryParse(json["seq"]) ?? 0) ,
        identifier = json["stop"],
        timestamp = DateTime.tryParse(json["data_timestamp"]?? "") ?? DateTime.now(),
        serviceType = json["service_type"] ?? "";
}