import 'package:minimal_bus_hk/interface/localized_data.dart';
import 'package:mobx/mobx.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

part 'localization_store.g.dart';
enum LocalizationPref{
  english,
  TC,
  SC
}
class LocalizationStore = LocalizationStoreBase
    with _$LocalizationStore;

abstract class LocalizationStoreBase with Store {

  @observable
  var localizationPref = LocalizationPref.TC;

  @action
  void setLocalizationPref(LocalizationPref pref){
    localizationPref = pref;
  }

  @observable
  ObservableMap<String, Map<String, String>> _localizationMap;

  @action
  Future<void> loadDataFromAsset() async {
    if(_localizationMap == null) {
      _localizationMap = ObservableMap<String, Map<String, String>>();
      String jsonString = await rootBundle.loadString(
          "assets/localization.json");
      final jsonResponse = jsonDecode(jsonString);
      if (jsonResponse is List) {
        for (var obj in jsonResponse) {
          if (obj is Map<String, dynamic>) {
            var localizationDataMap = Map<String, String>();
            for(var key in obj.keys){
              if(obj[key] is String){
                localizationDataMap[key] = obj[key];
              }
            }


            String localizationKey = localizationDataMap["key"];
            if (localizationKey != null) {
              _localizationMap[localizationKey] = localizationDataMap;
            }
          }
        }
      }
    }
  }


  String localizedString(String key, LocalizationPref pref){
    if(_localizationMap == null || !_localizationMap.containsKey(key)) {
      return "";
    }
    var lang = "en";
    if(pref == LocalizationPref.TC){
      lang = "tc";
    }else if(pref == LocalizationPref.SC){
      lang = "sc";
    }
    Map<String, String> map = _localizationMap[key];
    if(map.containsKey(lang)){
      return map[lang];
    }
    return "";
  }
  String localizedStringFrom(LocalizedData data, String key, LocalizationPref pref){
    if(data.getLocalizedData() == null || !data.getLocalizedData().containsKey(key)) {
      return "";
    }
    var lang = "en";
    if(pref == LocalizationPref.TC){
      lang = "tc";
    }else if(pref == LocalizationPref.SC){
      lang = "sc";
    }
    Map<String, String> map = data.getLocalizedData()[key];
    if(map.containsKey(lang)){
      return map[lang];
    }
    return "";
  }
}