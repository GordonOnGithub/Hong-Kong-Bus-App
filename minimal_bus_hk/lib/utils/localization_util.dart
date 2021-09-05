import 'package:minimal_bus_hk/interface/localized_data.dart';
import 'package:minimal_bus_hk/stores/localization_store.dart';
import 'package:minimal_bus_hk/utils/stores.dart';

class LocalizationUtil{
  static final String localizationKeyTo = "to";
  static final String localizationKeyFrom = "from";
  static final String localizationKeyForMinute = "minutes";
  static final String localizationKeyForETA = "eta";
  static final String localizationKeyForRoute = "route";
  static final String localizationKeyForInbound = "inbound";
  static final String localizationKeyForOutbound = "outbound";
  static final String localizationKeyForLocation = "location";
  static final String localizationKeyForBookmark = "bookmark";
  static final String localizationKeyForUnbookmark = "unbookmark";
  static final String localizationKeyForBookmarked = "bookmarked";
  static final String localizationKeyForRemove = "remove";
  static final String localizationKeyForETAListView = "etaListViewTitle";
  static final String localizationKeyForRouteListView = "routeListViewTitle";
  static final String localizationKeyForSettingView = "settingViewTitle";
  static final String localizationKeyForSettingLanguage = "settingLanguage";
  static final String localizationKeyForRouteSearchTextFieldPlaceholder = "routeListViewRouteSearchTextFieldPlaceholder";
  static final String localizationKeyForLoading = "loading";
  static final String localizationKeyForEmptyETAList = "emptyETAList";
  static final String localizationKeyForConnectivityWarning = "connectivityWarning";
  static final String localizationKeyForFailedToLoadData =  "failedToLoadData";
  static final String localizationKeyForStopSearchTextFieldPlaceholder = "routeListViewStopSearchTextFieldPlaceholder";
  static final String localizationKeyForNoRouteDataFound = "noRouteDataFound";
  static final String localizationKeyForRecenter = "recenter";
  static final String localizationKeyForLocationPermissionNotGranted = "locationPermissionNotGranted";
  static final String localizationKeyForRouteSearch = "routeSearch";
  static final String localizationKeyForMap = "map";
  static final String localizationKeyForDownloadAllDataPopupTitle = "downloadAllDataPopupTitle";
  static final String localizationKeyForDownloadAllDataPopupContent = "downloadAllDataPopupContent";
  static final String localizationKeyForDownloadAllDataPopupYes = "downloadAllDataPopupYes";
  static final String localizationKeyForDownloadAllDataPopupNo = "downloadAllDataPopupNo";
  static final String localizationKeyForRouteDetail = "routeDetail";
  static final String localizationKeyForRouteSearchReminder = "routeSearchReminder";
  static final String localizationKeyForUnderstand = "understand";
  static final String localizationKeyForSearchButtonReminder = "searchButtonReminder";
  static final String localizationKeyForRouteDetailReminder = "routeDetailReminder";
  static final String localizationKeyForSettingData = "settingData";
  static final String localizationKeyForSettingAppStore = "settingAppStore";
  static final String localizationKeyForDownloadData = "settingDownloadData";
  static final String localizationKeyForJourneyPlanner = "journeyPlanner";
  static final String localizationKeyForBusStopList = "busStopList";
  static final String localizationKeyForBusStop = "busStop";
  static final String localizationKeyForDataPreparationProgress= "dataPreparationProgress";
  static final String localizationKeyForDataPreparationReminder = "dataPreparationReminder";
  static final String localizationKeyForLastUpdateTime = "lastUpdateTime";
  static final String localizationKeyForAboutThisApp = "aboutThisApp";
  static final String localizationKeyForAboutThisAppDetail = "aboutThisAppDetail";
  static final String localizationKeyForRateThisApp = "rateThisApp";
  static final String localizationKeyForDonation = "donation";


  static String localizedString(String key, LocalizationPref pref){
    if(Stores.localizationStore.localizationMap == null || !Stores.localizationStore.localizationMap.containsKey(key)) {
      return "";
    }
    var lang = "en";
    if(pref == LocalizationPref.TC){
      lang = "tc";
    }else if(pref == LocalizationPref.SC){
      lang = "sc";
    }
    Map<String, String> map = Stores.localizationStore.localizationMap[key];
    if(map.containsKey(lang)){
      return map[lang];
    }
    return "";
  }

  static String localizedStringFrom(LocalizedData data, String key, LocalizationPref pref){
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