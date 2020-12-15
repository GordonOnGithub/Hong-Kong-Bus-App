import 'package:minimal_bus_hk/localization_util.dart';

class BusRoute{
final String routeCode;
final String originEnglishName;
final String originTCName;
final String originSCName;
final String destinationEnglishName;
final String destinationTCName;
final String destinationSCName;
final DateTime timestamp;
BusRoute.fromJson(Map<String, dynamic> json):
      routeCode = json["route"],
      originEnglishName = json["orig_en"],
      originTCName = json["orig_tc"],
      originSCName = json["orig_sc"],
      destinationEnglishName = json["dest_en"],
      destinationTCName = json["dest_tc"],
      destinationSCName = json["dest_sc"],
      timestamp = DateTime.tryParse(json["data_timestamp"]);

    String localizedOriginName(){
      switch(LocalizationUtil.localizationPref){
        case LocalizationPref.english:
          return originEnglishName;
        case LocalizationPref.TC:
          return originTCName;
        case LocalizationPref.SC:
          return originSCName;
        default:
          return originEnglishName;
      }
    }

    String localizedDestinationName(){
      switch(LocalizationUtil.localizationPref){
        case LocalizationPref.english:
          return destinationEnglishName;
        case LocalizationPref.TC:
          return destinationTCName;
        case LocalizationPref.SC:
          return destinationSCName;
        default:
          return destinationEnglishName;
      }
    }
}