import 'package:flutter/foundation.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/directional_route.dart';
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

  // @deprecated
  // @observable
  // BusRoute selectedRoute;
  //
  // @deprecated
  // @action
  // void setSelectedRoute(BusRoute busRoute){
  //   if(selectedRoute != busRoute) {
  //     selectedRoute = busRoute;
  //   }else{
  //     selectedRoute = null;
  //   }
  // }

  @observable
  DirectionalRoute selectedDirectionalRoute;

  @action
  void setSelectedDirectionalRoute(DirectionalRoute busRoute){
    if(selectedDirectionalRoute != busRoute) {
      selectedDirectionalRoute = busRoute;
    }else{
      selectedDirectionalRoute = null;
    }
  }


  @computed
  ObservableList<DirectionalRoute> get displayedDirectionalRoutes {
    if(filterKeyword != null && Stores.dataManager.directionalRouteList != null) {
      var result =  ObservableList<DirectionalRoute>();
      result.addAll(Stores.dataManager.directionalRouteList.where((element) {
        for(var keyword in _keywords) {
          if(element.route.routeCode.toLowerCase().contains(keyword.toLowerCase())
            || (element.isInbound &&
                  ( element.route.originEnglishName.toLowerCase().contains(
                  keyword.toLowerCase())
                  || element.route.originEnglishName.toLowerCase().contains(
                  keyword.toLowerCase())
                  || element.route.originSCName.toLowerCase().contains(
                  keyword.toLowerCase())))
              ||(!element.isInbound &&
                  ( element.route.destinationEnglishName.toLowerCase().contains(
                  keyword.toLowerCase())
                  || element.route.destinationSCName.toLowerCase().contains(
                  keyword.toLowerCase())
                  || element.route.destinationTCName.toLowerCase().contains(
                  keyword.toLowerCase())))){

          }else{
            return false;
          }
        }
        return true;
      }
      ).toList());

      result.sort((a,b){
        var result = a.route.routeCode.length.compareTo(b.route.routeCode.length);
        if(result == 0){
          result = a.route.routeCode.compareTo(b.route.routeCode);
        }
        return result;
      });
      return result;
    }else {
      var result = Stores.dataManager.directionalRouteList;

      return result;
    }

  }
  // @deprecated
  // @computed
  // ObservableList<BusRoute> get displayedRoutes{
  //   if(filterKeyword != null && Stores.dataManager.routes != null) {
  //     var result =  ObservableList<BusRoute>();
  //       result.addAll(Stores.dataManager.routes.where((element) {
  //       for(var keyword in _keywords) {
  //         if(element.routeCode.toLowerCase().contains(keyword.toLowerCase())
  //             || element.destinationEnglishName.toLowerCase().contains(
  //             keyword.toLowerCase())
  //             || element.originEnglishName.toLowerCase().contains(
  //             keyword.toLowerCase())
  //             || element.destinationTCName.toLowerCase().contains(
  //             keyword.toLowerCase())
  //             || element.originTCName.toLowerCase().contains(
  //             keyword.toLowerCase())
  //             || element.destinationSCName.toLowerCase().contains(
  //             keyword.toLowerCase())
  //             || element.originSCName.toLowerCase().contains(
  //             keyword.toLowerCase())){
  //
  //         }else{
  //           return false;
  //         }
  //       }
  //       return true;
  //       }
  //       ).toList());
  //
  //     result.sort((a,b){
  //       var result = a.routeCode.length.compareTo(b.routeCode.length);
  //       if(result == 0){
  //         result = a.routeCode.compareTo(b.routeCode);
  //       }
  //       return result;
  //     });
  //     return result;
  //   }else {
  //     var result = Stores.dataManager.routes;
  //
  //     return result;
  //   }
  // }

  @observable
  bool dataFetchingError = false;

  @action
  void setDataFetchingError(bool hasError){
    dataFetchingError = hasError;
  }
}