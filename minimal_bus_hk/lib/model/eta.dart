import 'package:minimal_bus_hk/localization_util.dart';
import 'package:minimal_bus_hk/utils/stores.dart';

enum ETAStatus{
  found,
  notFound,
  unknown
}

class ETA{
  final String stopId;
  final String routeCode;
  final String companyCode;
  final String englishRemark;
  final String TCRemark;
  final String SCRemark;
  final DateTime etaTimestamp;
  final DateTime dataTimestamp;
  final bool isInBound;
  final ETAStatus status;

  ETA.fromJson(Map<String, dynamic> json):
        stopId = json["stop"],
        routeCode = json["route"],
        companyCode = json["co"],
        englishRemark = json["rmk_en"],
        TCRemark = json["rmk_tc"],
        SCRemark = json["rmk_sc"],
        etaTimestamp = DateTime.tryParse(json["eta"]),
        dataTimestamp = DateTime.tryParse(json["data_timestamp"]),
        isInBound = json["dir"] == "I",
        status = ETAStatus.found;


  ETA.notFound(String routeCode, String stopId, String companyCode, bool isInbound):
        routeCode = routeCode,
        stopId = stopId,
        companyCode = companyCode,
        isInBound = isInbound,
        englishRemark = "",
        TCRemark = "",
        SCRemark = "",
        etaTimestamp = null,
        dataTimestamp = DateTime.now(),
        status = ETAStatus.notFound;

  ETA.unknown(String routeCode, String stopId, String companyCode,  bool isInbound):
        routeCode = routeCode,
        stopId = stopId,
        companyCode = companyCode,
      isInBound = isInbound,
        englishRemark = "",
        TCRemark = "",
        SCRemark = "",
        etaTimestamp = null,
        dataTimestamp = DateTime.now(),
        status = ETAStatus.unknown;


  String localizedRemark(){
    switch(LocalizationUtil.localizationPref){
      case LocalizationPref.english:
        return englishRemark;
      case LocalizationPref.TC:
        return TCRemark;
      case LocalizationPref.SC:
        return SCRemark;
      default:
        return englishRemark;
    }
  }

  String toClockDescription(DateTime timestampForChecking){
    if(timestampForChecking == null){
      timestampForChecking = DateTime.now();
    }
    if(status == ETAStatus.unknown){
      return "loading...";
    }
    if(status == ETAStatus.notFound){
      return "-";
    }
    if(etaTimestamp == null){
      return "-";
    }


    var localTime = etaTimestamp.add(Duration(hours: 8));
    var remainedTimeInMilliseconds = getRemainTimeInMilliseconds(timestampForChecking);
    return "${localTime.hour.toString().padLeft(2, "0")}:${localTime.minute.toString().padLeft(2, "0")}";
  }

  String getTimeLeftDescription(DateTime timestampForChecking){
    var remainedTimeInMilliseconds = getRemainTimeInMilliseconds(timestampForChecking);
    return remainedTimeInMilliseconds > Stores.appConfig.arrivalExpiryTimeMilliseconds ?( remainedTimeInMilliseconds > Stores.appConfig.arrivalImminentTimeMilliseconds?"~${(remainedTimeInMilliseconds~/Stores.appConfig.arrivalImminentTimeMilliseconds)}  minute(s)":("< 1 minute")) : "";

  }

  int getRemainTimeInMilliseconds(DateTime timestampForChecking){
    if(timestampForChecking == null){
      timestampForChecking = DateTime.now();
    }
    return  (etaTimestamp != null? etaTimestamp.millisecondsSinceEpoch:0) - DateTime.now().millisecondsSinceEpoch;
  }

}