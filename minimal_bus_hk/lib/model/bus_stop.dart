
class BusStop{
  final String routeCode;
  final String companyCode;
  final int sequence;
  final String identifier;
  final DateTime timestamp;

  BusStop.fromJson(Map<String, dynamic> json):
        routeCode = json["route"],
        companyCode = json["co"],
        sequence =  (json["seq"] is int)? json["seq"]: 0 ,
        identifier = json["stop"],
        timestamp = DateTime.tryParse(json["data_timestamp"]) ?? DateTime.now();
}