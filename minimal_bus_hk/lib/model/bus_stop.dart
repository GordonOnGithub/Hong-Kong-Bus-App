
class BusStop{
  final String routeCode;
  final int sequence;
  final String identifier;
  final DateTime timestamp;

  BusStop.fromJson(Map<String, dynamic> json):
        routeCode = json["route"],
        sequence = json["seq"],
        identifier = json["stop"],
        timestamp = DateTime.tryParse(json["data_timestamp"]);

}