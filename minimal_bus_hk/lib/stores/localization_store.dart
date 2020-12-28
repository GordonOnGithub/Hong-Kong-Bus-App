import 'package:minimal_bus_hk/interface/localized_data.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:mobx/mobx.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

part 'localization_store.g.dart';
enum LocalizationPref{
  english,
  TC,
  SC
}

class LocalizationStore = LocalizationStoreBase
    with _$LocalizationStore;

abstract class LocalizationStoreBase with Store {

  Map<LocalizationPref, String> _localizationStringMap = {LocalizationPref.english : "en",LocalizationPref.TC : "tc",LocalizationPref.SC : "sc"};

  @observable
  var localizationPref = LocalizationPref.english;

  String _localeKey = "localization";

  @action
  Future<LocalizationPref> checkLocalizationPref()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String systemLangCode = ui.window.locale.languageCode;
    String systemScriptCode = ui.window.locale.scriptCode;

    String locale = prefs.getString(_localeKey);
    if(locale != null){
      for(LocalizationPref p in _localizationStringMap.keys){
        if(_localizationStringMap[p] == locale){
          localizationPref = p;
          break;
        }
      }
    }else if (systemLangCode == "zh"){
      if(systemScriptCode == "Hans"){
        localizationPref = LocalizationPref.SC;
      }else{
        localizationPref = LocalizationPref.TC;
      }
    }
    return localizationPref;
  }

  @action
  Future<void> setLocalizationPref(LocalizationPref pref) async{
    localizationPref = pref;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_localeKey, _localizationStringMap[pref]);

  }

  @observable
  ObservableMap<String, Map<String, String>> localizationMap;

  @action
  Future<void> loadDataFromAsset() async {
    if(localizationMap == null) {
      localizationMap = ObservableMap<String, Map<String, String>>();
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
              localizationMap[localizationKey] = localizationDataMap;
            }
          }
        }
      }
    }
  }

  @deprecated
  String localizedString(String key, LocalizationPref pref){
    return LocalizationUtil.localizedString(key, pref);
  }

  @deprecated
  String localizedStringFrom(LocalizedData data, String key, LocalizationPref pref){
    return LocalizationUtil.localizedStringFrom(data, key, pref);

  }
}