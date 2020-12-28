import 'package:minimal_bus_hk/interface/localized_data.dart';
import 'package:minimal_bus_hk/stores/localization_store.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:minimal_bus_hk/utils/stores.dart';

enum ETAStatus{
  found,
  notFound,
  unknown
}

class ETA extends LocalizedData{
  final String stopId;
  final String routeCode;
  final String companyCode;
  final String englishRemark;
  final String TCRemark;
  final String SCRemark;
  final DateTime etaTimestamp;
  final DateTime dataTimestamp;
  final bool isInbound;
  final ETAStatus status;

  Map<String, Map<String, String>> _localizedData = Map();
  static final String localizationKeyForRemark = "remark";

  ETA.fromJson(Map<String, dynamic> json):
        stopId = json["stop"],
        routeCode = json["route"],
        companyCode = json["co"],
        englishRemark = json["rmk_en"],
        TCRemark = json["rmk_tc"],
        SCRemark = json["rmk_sc"],
        etaTimestamp = DateTime.tryParse(json["eta"]),
        dataTimestamp = DateTime.tryParse(json["data_timestamp"]) ?? DateTime.now(),
        isInbound = json["dir"] == "I",
        status = ETAStatus.found{
    Map<String, String> nameData = Map();
    nameData["en"] = englishRemark;
    nameData["tc"] = TCRemark;
    nameData["sc"] = SCRemark;
    _localizedData[localizationKeyForRemark] = nameData;
  }


  ETA.notFound(String routeCode, String stopId, String companyCode, bool isInbound):
        routeCode = routeCode,
        stopId = stopId,
        companyCode = companyCode,
        isInbound = isInbound,
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
      isInbound = isInbound,
        englishRemark = "",
        TCRemark = "",
        SCRemark = "",
        etaTimestamp = null,
        dataTimestamp = DateTime.now(),
        status = ETAStatus.unknown;


  String toClockDescription(){

    if(status == ETAStatus.unknown){
      return LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref);
    }
    if(status == ETAStatus.notFound){
      return "- - : - -";
    }
    if(etaTimestamp == null){
      return "- - : - -";
    }


    var localTime = etaTimestamp.add(Duration(hours: 8));
    return "${localTime.hour.toString().padLeft(2, "0")}:${localTime.minute.toString().padLeft(2, "0")}";
  }

  String getTimeLeftDescription(DateTime timestampForChecking){
    var remainedTimeInMilliseconds = getRemainTimeInMilliseconds(timestampForChecking);
    return remainedTimeInMilliseconds > Stores.appConfig.arrivalExpiryTimeMilliseconds ?( remainedTimeInMilliseconds > Stores.appConfig.arrivalImminentTimeMilliseconds?"~${(remainedTimeInMilliseconds~/Stores.appConfig.arrivalImminentTimeMilliseconds)} ${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForMinute, Stores.localizationStore.localizationPref)}":("< 1 ${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForMinute, Stores.localizationStore.localizationPref)}")) : "-";

  }

  int getRemainTimeInMilliseconds(DateTime timestampForChecking){
    if(timestampForChecking == null){
      timestampForChecking = DateTime.now();
    }
    return  (etaTimestamp != null? etaTimestamp.millisecondsSinceEpoch:0) - timestampForChecking.millisecondsSinceEpoch;
  }
  @override
  Map<String, Map<String, String>> getLocalizedData() {
    return _localizedData;
  }
}