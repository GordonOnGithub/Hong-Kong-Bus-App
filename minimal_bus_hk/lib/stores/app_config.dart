import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_config.g.dart';

class AppConfigStore = AppConfigStoreBase with _$AppConfigStore;

abstract class AppConfigStoreBase with Store {
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
  bool _downloadAllData;

  static final String _downloadAllDataConfigKey = "downloadAllData";
  @action
  Future<bool> shouldDownloadAllData() async{
    if(_downloadAllData != null){
      return _downloadAllData;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _downloadAllData = prefs.getBool(_downloadAllDataConfigKey);
    return _downloadAllData;
  }

  @action
  Future<void> setShouldDownloadAllData(bool shouldDownload) async{
    _downloadAllData = shouldDownload;
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