import 'package:minimal_bus_hk/interface/localized_data.dart';

class BusStopDetail extends LocalizedData{
  final String identifier;
  final String englishName;
  final String TCName;
  final String SCName;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  Map<String, Map<String, String>> _localizedData = Map();

  static final String localizationKeyForName = "name";

BusStopDetail.fromJson(Map<String, dynamic> json):
      identifier = json["stop"],
      englishName = json["name_en"],
      TCName = json["name_tc"],
      SCName = json["name_sc"],
      latitude = double.tryParse(json["lat"]),
      longitude = double.tryParse(json["long"]),
      timestamp = DateTime.tryParse(json["data_timestamp"]){
      Map<String, String> nameData = Map();
      nameData["en"] = englishName;
      nameData["tc"] = TCName;
      nameData["sc"] = SCName;
      _localizedData[localizationKeyForName] = nameData;
}

  BusStopDetail.empty(String identifier):
        identifier = identifier,
        englishName = "",
        TCName = "",
        SCName = "",
        latitude = null,
        longitude  = null,
        timestamp = DateTime.now(){
    Map<String, String> nameData = Map();
    nameData["en"] = "loading";
    nameData["tc"] = "載入中";
    nameData["sc"] = "載入中";
    _localizedData[localizationKeyForName] = nameData;
  }

  @override
  Map<String, Map<String, String>> getLocalizedData() {
    return _localizedData;
  }
}