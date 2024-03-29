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

import '../utils/localization_util.dart';
import '../utils/network_util.dart';

part 'route_list_store.g.dart';

class RouteListStore = RouteListStoreBase with _$RouteListStore;

abstract class RouteListStoreBase with Store {
  @observable
  String filterKeyword = "";

  @action
  void setFilterKeyword(String keyword) {
    filterKeyword = keyword;
  }

  @computed
  List<String> get _keywords {
    return filterKeyword.split(" ");
  }

  @observable
  DirectionalRoute? selectedDirectionalRoute;

  @action
  void setSelectedDirectionalRoute(DirectionalRoute? busRoute) {
    if (selectedDirectionalRoute != busRoute) {
      selectedDirectionalRoute = busRoute;
    } else {
      selectedDirectionalRoute = null;
    }
  }

  @observable
  String filterStopIdentifier = "";

  @action
  void setFilterStopIdentifier(String identifier) {
    filterStopIdentifier = identifier;
  }

  @action
  void clearFilters() {
    filterKeyword = "";
    filterStopIdentifier = "";
  }

  @computed
  ObservableList<DirectionalRoute> get displayedDirectionalRoutesForNWFBAndCTB {
    if (filterKeyword.isNotEmpty &&
        Stores.dataManager.directionalRouteListOfNWFBAndCTB != null) {
      var directionalRouteList = filterStopIdentifier != null &&
              filterStopIdentifier.length > 0 &&
              Stores.dataManager.stopRoutesMap.containsKey(filterStopIdentifier)
          ? Stores.dataManager.directionalRouteListOfNWFBAndCTB
              .where((element) {
              var directionalRoutesOfStop =
                  Stores.dataManager.stopRoutesMap[filterStopIdentifier];
              for (DirectionalRoute directionalRoute
                  in directionalRoutesOfStop!) {
                if (directionalRoute.route.routeUniqueIdentifier ==
                        element.route.routeUniqueIdentifier &&
                    directionalRoute.isInbound == element.isInbound) {
                  return true;
                }
              }
              return false;
            })
          : Stores.dataManager.directionalRouteListOfNWFBAndCTB;

      var result = ObservableList<DirectionalRoute>();
      result.addAll(directionalRouteList.where((element) {
        if (element == null) {
          return false;
        }
        for (var keyword in _keywords) {
          if (element.route.routeCode
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              (element.isInbound &&
                  ((keyword.isNotEmpty &&
                          element.route.originEnglishName
                              .toLowerCase()
                              .contains(keyword.toLowerCase())) ||
                      element.route.originTCName.contains(keyword) ||
                      element.route.originSCName.contains(keyword))) ||
              (!element.isInbound &&
                  ((keyword.isNotEmpty &&
                          element.route.destinationEnglishName
                              .toLowerCase()
                              .contains(keyword.toLowerCase())) ||
                      element.route.destinationSCName.contains(keyword) ||
                      element.route.destinationTCName.contains(keyword)))) {
          } else {
            return false;
          }
        }
        return true;
      }).toList());

      result.sort((a, b) {
        var result =
            a.route.routeCode.length.compareTo(b.route.routeCode.length);
        if (result == 0) {
          result = a.route.routeCode.compareTo(b.route.routeCode);
        }
        return result;
      });
      return result;
    } else {
      var result = Stores.dataManager.directionalRouteListOfNWFBAndCTB;

      return result;
    }
  }

  @computed
  ObservableList<DirectionalRoute> get displayedDirectionalRoutesForKMB {
    if (filterKeyword.isNotEmpty &&
        Stores.dataManager.directionalRouteListOfKMB != null) {
      var directionalRouteList = filterStopIdentifier != null &&
              filterStopIdentifier.length > 0 &&
              Stores.dataManager.stopRoutesMap.containsKey(filterStopIdentifier)
          ? Stores.dataManager.directionalRouteListOfKMB.where((element) {
              var directionalRoutesOfStop =
                  Stores.dataManager.stopRoutesMap[filterStopIdentifier];
              for (DirectionalRoute directionalRoute
                  in directionalRoutesOfStop!) {
                if (directionalRoute.route.routeUniqueIdentifier ==
                        element.route.routeUniqueIdentifier &&
                    directionalRoute.isInbound == element.isInbound) {
                  return true;
                }
              }
              return false;
            })
          : Stores.dataManager.directionalRouteListOfKMB;

      var result = ObservableList<DirectionalRoute>();
      result.addAll(directionalRouteList.where((element) {
        if (element == null) {
          return false;
        }
        for (var keyword in _keywords) {
          if (element.route.routeCode
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              (element.isInbound &&
                  ((keyword.isNotEmpty &&
                          element.route.originEnglishName
                              .toLowerCase()
                              .contains(keyword.toLowerCase())) ||
                      element.route.originTCName
                          .toLowerCase()
                          .contains(keyword.toLowerCase()) ||
                      element.route.originSCName
                          .toLowerCase()
                          .contains(keyword.toLowerCase()))) ||
              (!element.isInbound &&
                  ((keyword.isNotEmpty &&
                          element.route.destinationEnglishName
                              .toLowerCase()
                              .contains(keyword.toLowerCase())) ||
                      element.route.destinationSCName
                          .toLowerCase()
                          .contains(keyword.toLowerCase()) ||
                      element.route.destinationTCName
                          .toLowerCase()
                          .contains(keyword.toLowerCase())))) {
          } else {
            return false;
          }
        }
        return true;
      }).toList());

      result.sort((a, b) {
        var result =
            a.route.routeCode.length.compareTo(b.route.routeCode.length);
        if (result == 0) {
          result = a.route.routeCode.compareTo(b.route.routeCode);
        }
        return result;
      });
      return result;
    } else {
      var result = Stores.dataManager.directionalRouteListOfKMB;

      return result;
    }
  }

  @observable
  bool dataFetchingError = false;

  @action
  void setDataFetchingError(bool hasError) {
    dataFetchingError = hasError;
  }

  @computed
  String get nwfbTabTitle {
    String title =
        "${LocalizationUtil.localizedString(NetworkUtil.companyCodeCTB, Stores.localizationStore.localizationPref)}";

    if (filterKeyword.isNotEmpty) {
      title = "${title} (${displayedDirectionalRoutesForNWFBAndCTB.length})";
    }

    return title;
  }

  @computed
  String get kmbTabTitle {
    String title =
        "${LocalizationUtil.localizedString(NetworkUtil.companyCodeKMB, Stores.localizationStore.localizationPref)}";

    if (filterKeyword.isNotEmpty) {
      title = "${title} (${displayedDirectionalRoutesForKMB.length})";
    }

    return title;
  }
}
