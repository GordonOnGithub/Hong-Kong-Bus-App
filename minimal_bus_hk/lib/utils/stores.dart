import 'package:minimal_bus_hk/stores/connectivity_store.dart';
import 'package:minimal_bus_hk/stores/data_manager.dart';
import 'package:minimal_bus_hk/stores/google_map_store.dart';
import 'package:minimal_bus_hk/stores/journey_planner_store.dart';
import 'package:minimal_bus_hk/stores/route_list_store.dart';
import 'package:minimal_bus_hk/stores/route_detail_store.dart';
import 'package:minimal_bus_hk/stores/eta_list_store.dart';
import 'package:minimal_bus_hk/stores/app_config.dart';
import 'package:minimal_bus_hk/stores/localization_store.dart';
import 'package:minimal_bus_hk/stores/setting_view_store.dart';
import 'package:minimal_bus_hk/stores/stop_list_view_store.dart';

class Stores{
  static DataManager _dataManager = DataManager();
  static DataManager get dataManager => _dataManager;

  static RouteListStore _routeListStore = RouteListStore();
  static RouteListStore get routeListStore => _routeListStore;

  static RouteDetailStore _routeDetailStore = RouteDetailStore();
  static RouteDetailStore get routeDetailStore => _routeDetailStore;

  static ETAListStore _etaListStore = ETAListStore();
  static ETAListStore get etaListStore => _etaListStore;

  static AppConfigStore _appConfigStoreBase = AppConfigStore();
  static AppConfigStore get appConfig => _appConfigStoreBase;

  static LocalizationStore _localizationStore = LocalizationStore();
  static LocalizationStore get localizationStore => _localizationStore;

  static SettingViewStore _settingViewStore = SettingViewStore();
  static SettingViewStore get settingViewStore => _settingViewStore;

  static ConnectivityStore _connectivityStore = ConnectivityStore();
  static ConnectivityStore get connectivityStore => _connectivityStore;

  static GoogleMapStore _googleMapStore = GoogleMapStore();
  static GoogleMapStore get googleMapStore => _googleMapStore;

  static JourneyPlannerStore _journeyPlannerStore = JourneyPlannerStore();
  static JourneyPlannerStore get journeyPlannerStore => _journeyPlannerStore;

  static StopListViewStore _stopListViewStore = StopListViewStore();
  static StopListViewStore get stopListViewStore => _stopListViewStore;
}