import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';

import 'package:mobx/mobx.dart';
part 'route_list_store.g.dart';

class RouteListStore = RouteListStoreBase with _$RouteListStore;

abstract class RouteListStoreBase with Store {

  @observable
  String filterKeyword = "";

  @action
  void setFilterKeyword(String keyword){
    filterKeyword = keyword;
  }

  @observable
  BusRoute selectedRoute;

  @action
  void setSelectedRoute(BusRoute busRoute){
    selectedRoute = busRoute;
  }

  @computed
  ObservableList<BusRoute> get displayedRoutes{
    if(filterKeyword != null && Stores.dataManager.routes != null) {
      var result =  ObservableList<BusRoute>();
      result.addAll(Stores.dataManager.routes.where((element) =>
          element.routeCode.toLowerCase().contains(filterKeyword.toLowerCase())
              || element.destinationEnglishName.toLowerCase().contains(filterKeyword.toLowerCase())
              || element.originEnglishName.toLowerCase().contains(filterKeyword.toLowerCase())
              || element.destinationTCName.toLowerCase().contains(filterKeyword.toLowerCase())
              || element.originTCName.toLowerCase().contains(filterKeyword.toLowerCase())
              || element.destinationSCName.toLowerCase().contains(filterKeyword.toLowerCase())
              || element.originSCName.toLowerCase().contains(filterKeyword.toLowerCase())
            ).toList() );

      return result;
    }else {
      var result = Stores.dataManager.routes;
      // if(result == null){
      //   result = ObservableList<BusRoute>();
      // }
      return result;
    }
  }
}