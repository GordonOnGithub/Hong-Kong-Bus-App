import 'package:minimal_bus_hk/interface/localized_data.dart';

class BusStopDetail extends LocalizedData{
  final String identifier;
  final String englishName;
  final String TCName;
  final String SCName;
  final String latitude;
  final String longitude;
  final DateTime timestamp;
  Map<String, Map<String, String>> _localizedData = Map();

  static final String localizationKeyForName = "name";

BusStopDetail.fromJson(Map<String, dynamic> json):
      identifier = json["stop"],
      englishName = json["name_en"],
      TCName = json["name_tc"],
      SCName = json["name_sc"],
      latitude = json["lat"],
      longitude = json["long"],
      timestamp = DateTime.tryParse(json["data_timestamp"]){
      Map<String, String> nameData = Map();
      nameData["en"] = englishName;
      nameData["tc"] = TCName;
      nameData["sc"] = SCName;
      _localizedData[localizationKeyForName] = nameData;
}

  BusStopDetail.empty(String identifier):
        identifier =identifier,
        englishName = "loading...",
        TCName = "loading...",
        SCName = "loading...",
        latitude = "loading...",
        longitude  = "loading...",
        timestamp = DateTime.now();

  @override
  Map<String, Map<String, String>> getLocalizedData() {
    return _localizedData;
  }
}