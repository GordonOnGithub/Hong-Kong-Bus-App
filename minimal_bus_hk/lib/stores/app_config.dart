import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_config.g.dart';

class AppConfigStore = AppConfigStoreBase with _$AppConfigStore;

abstract class AppConfigStoreBase with Store {

  final String appStoreUrl = "https://play.google.com/store/apps/details?id=com.gordon.minimal_bus_hk";
  final int launchCountToShowRatingMessage = 10;
  @observable
  int arrivalImminentTimeMilliseconds = 60000;

  @action
  void setArrivalImminentTimeMilliseconds(int timeMilliseconds){
    arrivalImminentTimeMilliseconds = timeMilliseconds;
  }

  @observable
  int arrivalExpiryTimeMilliseconds = -30000;//should be < 0

  @action
  void setArrivalExpiryTimeMilliseconds(int timeMilliseconds){
    arrivalExpiryTimeMilliseconds = timeMilliseconds;
  }

  final int etaExpiryTimeMilliseconds = 30000;

  @observable
  bool downloadAllData;

  static final String _downloadAllDataConfigKey = "downloadAllData";
  @action
  Future<bool> shouldDownloadAllData() async{
    if(downloadAllData != null){
      return downloadAllData;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    downloadAllData = prefs.getBool(_downloadAllDataConfigKey);
    return downloadAllData;
  }

  @action
  Future<void> setShouldDownloadAllData(bool shouldDownload) async{
    downloadAllData = shouldDownload;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_downloadAllDataConfigKey, shouldDownload);
  }

  @observable
  bool _routeSearchReminder;

  static final String _routeSearchReminderConfigKey = "routeSearchReminder";
  @action
  Future<bool> shouldShowRouteSearchReminder() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _routeSearchReminder = prefs.getBool(_routeSearchReminderConfigKey);
    if(_routeSearchReminder != null){
      return _routeSearchReminder;
    }
    _routeSearchReminder = true;
    return _routeSearchReminder;
  }

  @action
  Future<void> setShouldShowRouteSearchReminder(bool shouldRemind) async{
    _routeSearchReminder = shouldRemind;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_routeSearchReminderConfigKey, shouldRemind);
  }

  @observable
  bool showSearchButtonReminder = false;
  static final String _showSearchButtonReminderConfigKey = "showSearchButtonReminder";

  @action
  Future<void> checkShowSearchButtonReminder() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showSearchButtonReminder = prefs.getBool(_showSearchButtonReminderConfigKey);
    if(showSearchButtonReminder == null){
      showSearchButtonReminder = true;
    }
  }

  @action
  Future<void> setShowSearchButtonReminder(bool shouldShow) async{
    showSearchButtonReminder = shouldShow;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_showSearchButtonReminderConfigKey, shouldShow);
  }

  @observable
  bool didSearchKMBStopList = false;
  static final String _didSearchKMBStopListConfigKey = "didSearchKMBStopList";

  @action
  Future<void> checkDidSearchKMBStopList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    didSearchKMBStopList = prefs.getBool(_didSearchKMBStopListConfigKey);
    if(didSearchKMBStopList == null){
      didSearchKMBStopList = false;
    }
  }

  @action
  Future<void> setDidSearchKMBStopList(bool didSearch) async{
    didSearchKMBStopList = didSearch;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_didSearchKMBStopListConfigKey, didSearch);
  }

  @observable
  bool hideRatingDialogue = true;

  @action
  void setHideRatingDialogue(bool hide){
    hideRatingDialogue = hide;
  }

  @observable
  int appLaunchCount = 0;
  static final String _appLaunchCountConfigKey = "appLaunchCount";

  @action
  Future<void> checkAppLaunchCount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appLaunchCount = prefs.getInt(_appLaunchCountConfigKey);
    if(appLaunchCount == null){
      appLaunchCount = 0;
    }
  }

  @action
  Future<void> increaseAppLaunchCount() async{
    appLaunchCount += 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_appLaunchCountConfigKey, appLaunchCount);
  }

  @observable
  bool showRouteDetailReminder = false;
  static final String _showRouteDetailReminderConfigKey = "showRouteDetailReminder";

  @action
  Future<void> checkShowRouteDetailReminder() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showRouteDetailReminder = prefs.getBool(_showRouteDetailReminderConfigKey);
    if(showRouteDetailReminder == null){
      showRouteDetailReminder = true;
    }
  }

  @action
  Future<void> setShowRouteDetailReminder(bool shouldShow) async{
    showRouteDetailReminder = shouldShow;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_showRouteDetailReminderConfigKey, shouldShow);
  }
}