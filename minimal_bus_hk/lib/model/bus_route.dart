import 'package:minimal_bus_hk/interface/localized_data.dart';

class BusRoute extends LocalizedData{
final String routeCode;
final String companyCode;
final String serviceType;
final String bound;
final String originEnglishName;
final String originTCName;
final String originSCName;
final String destinationEnglishName;
final String destinationTCName;
final String destinationSCName;
final DateTime timestamp;
Map<String, Map<String, String>> _localizedData = Map();

static final String localizationKeyForOrigin = "origin";
static final String localizationKeyForDestination = "destination";


BusRoute.fromJson(Map<String, dynamic> json):
      routeCode = json["route"],
      companyCode = (json["co"] as String).toLowerCase(),
      serviceType = json["service_type"]??"",
      bound = json["bound"]??"",
      originEnglishName = json["orig_en"],
      originTCName = json["orig_tc"],
      originSCName = json["orig_sc"],
      destinationEnglishName = json["dest_en"],
      destinationTCName = json["dest_tc"],
      destinationSCName = json["dest_sc"],
      timestamp = DateTime.tryParse(json["data_timestamp"]?? "")  ?? DateTime.now(){
      Map<String, String> destinationNameData = Map();
      destinationNameData["en"] = bound == "I"? originEnglishName : destinationEnglishName;
      destinationNameData["tc"] = bound == "I"? originTCName : destinationTCName;
      destinationNameData["sc"] = bound == "I"? originSCName : destinationSCName;
      _localizedData[localizationKeyForDestination] = destinationNameData;

      Map<String, String> originNameData = Map();
      originNameData["en"] = bound == "I"? destinationEnglishName : originEnglishName;
      originNameData["tc"] = bound == "I"? destinationTCName : originTCName;
      originNameData["sc"] = bound == "I"? destinationSCName : originSCName;
      _localizedData[localizationKeyForOrigin] = originNameData;

}

  @override
  Map<String, Map<String, String>> getLocalizedData() {
  return _localizedData;
  }

  @override
  bool operator ==(Object other) {
    if(other is BusRoute) {
      return routeCode == other.routeCode && companyCode == other.companyCode;
    }else{
      return false;
    }
  }

  @override
  int get hashCode => ("$routeCode$companyCode").hashCode ;



}