import 'package:minimal_bus_hk/stores/data_manager.dart';
import 'package:minimal_bus_hk/stores/route_list_store.dart';
import 'package:minimal_bus_hk/stores/route_detail_store.dart';
import 'package:minimal_bus_hk/stores/eta_list_store.dart';
class Stores{
  static DataManager _dataManager = DataManager();
  static DataManager get dataManager => _dataManager;

  static RouteListStore _routeListStore = RouteListStore();
  static RouteListStore get routeListStore => _routeListStore;

  static RouteDetailStore _routeDetailStore = RouteDetailStore();
  static RouteDetailStore get routeDetailStore => _routeDetailStore;

  static ETAListStore _etaListStore = ETAListStore();
  static ETAListStore get etaListStore => _etaListStore;
}