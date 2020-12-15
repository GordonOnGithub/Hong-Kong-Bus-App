import 'package:minimal_bus_hk/localization_util.dart';

class BusStopDetail{
  final String identifier;
  final String englishName;
  final String TCName;
  final String SCName;
  final String latitude;
  final String longitude;
  final DateTime timestamp;

BusStopDetail.fromJson(Map<String, dynamic> json):
      identifier = json["stop"],
      englishName = json["name_en"],
      TCName = json["name_tc"],
      SCName = json["name_sc"],
      latitude = json["lat"],
      longitude = json["long"],
      timestamp = DateTime.tryParse(json["data_timestamp"]);

  BusStopDetail.empty(String identifier):
        identifier =identifier,
        englishName = "loading...",
        TCName = "loading...",
        SCName = "loading...",
        latitude = "loading...",
        longitude  = "loading...",
        timestamp = DateTime.now();

  String localizedName(){
    switch(LocalizationUtil.localizationPref){
      case LocalizationPref.english:
        return englishName != null? englishName : "";
      case LocalizationPref.TC:
        return TCName!= null? TCName : "";
      case LocalizationPref.SC:
        return SCName!= null? SCName : "";
      default:
        return englishName;
    }
  }
}