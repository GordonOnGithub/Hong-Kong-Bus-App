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

  @computed
  List<String> get _keywords{
    return filterKeyword.split(" ");

  }

  @observable
  BusRoute selectedRoute;

  @action
  void setSelectedRoute(BusRoute busRoute){
    if(selectedRoute != busRoute) {
      selectedRoute = busRoute;
    }else{
      selectedRoute = null;
    }
  }

  @computed
  ObservableList<BusRoute> get displayedRoutes{
    if(filterKeyword != null && Stores.dataManager.routes != null) {
      var result =  ObservableList<BusRoute>();
        result.addAll(Stores.dataManager.routes.where((element) {
        for(var keyword in _keywords) {
          if(element.routeCode.toLowerCase().contains(keyword.toLowerCase())
              || element.destinationEnglishName.toLowerCase().contains(
              keyword.toLowerCase())
              || element.originEnglishName.toLowerCase().contains(
              keyword.toLowerCase())
              || element.destinationTCName.toLowerCase().contains(
              keyword.toLowerCase())
              || element.originTCName.toLowerCase().contains(
              keyword.toLowerCase())
              || element.destinationSCName.toLowerCase().contains(
              keyword.toLowerCase())
              || element.originSCName.toLowerCase().contains(
              keyword.toLowerCase())){

          }else{
            return false;
          }
        }
        return true;
        }
        ).toList());

      result.sort((a,b){
        var result = a.routeCode.length.compareTo(b.routeCode.length);
        if(result == 0){
          result = a.routeCode.compareTo(b.routeCode);
        }
        return result;
      });
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