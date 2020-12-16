import 'package:minimal_bus_hk/localization_util.dart';

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

  String toTimeDescription(DateTime timestampForChecking){
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
    var timeLeft = remainedTimeInMilliseconds > -30000?( remainedTimeInMilliseconds > 60000?"[~${(remainedTimeInMilliseconds~/60000)}  minute(s)]":("[< 1 minute]")) : "";
    return "${localTime.hour.toString().padLeft(2, "0")}:${localTime.minute.toString().padLeft(2, "0")} $timeLeft";
  }

  int getRemainTimeInMilliseconds(DateTime timestampForChecking){
    if(timestampForChecking == null){
      timestampForChecking = DateTime.now();
    }
    return  (etaTimestamp != null? etaTimestamp.millisecondsSinceEpoch:0) - DateTime.now().millisecondsSinceEpoch;
  }

}