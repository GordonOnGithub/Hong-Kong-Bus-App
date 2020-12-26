// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_manager.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DataManager on DataManagerBase, Store {
  Computed<ObservableList<BusRoute>> _$routesComputed;

  @override
  ObservableList<BusRoute> get routes => (_$routesComputed ??=
          Computed<ObservableList<BusRoute>>(() => super.routes,
              name: 'DataManagerBase.routes'))
      .value;
  Computed<ObservableMap<String, BusRoute>> _$routesMapComputed;

  @override
  ObservableMap<String, BusRoute> get routesMap => (_$routesMapComputed ??=
          Computed<ObservableMap<String, BusRoute>>(() => super.routesMap,
              name: 'DataManagerBase.routesMap'))
      .value;
  Computed<ObservableList<DirectionalRoute>> _$directionalRouteListComputed;

  @override
  ObservableList<DirectionalRoute> get directionalRouteList =>
      (_$directionalRouteListComputed ??=
              Computed<ObservableList<DirectionalRoute>>(
                  () => super.directionalRouteList,
                  name: 'DataManagerBase.directionalRouteList'))
          .value;

  final _$companyRoutesMapAtom = Atom(name: 'DataManagerBase.companyRoutesMap');

  @override
  ObservableMap<String, List<BusRoute>> get companyRoutesMap {
    _$companyRoutesMapAtom.reportRead();
    return super.companyRoutesMap;
  }

  @override
  set companyRoutesMap(ObservableMap<String, List<BusRoute>> value) {
    _$companyRoutesMapAtom.reportWrite(value, super.companyRoutesMap, () {
      super.companyRoutesMap = value;
    });
  }

  final _$inboundBusStopsMapAtom =
      Atom(name: 'DataManagerBase.inboundBusStopsMap');

  @override
  ObservableMap<String, List<BusStop>> get inboundBusStopsMap {
    _$inboundBusStopsMapAtom.reportRead();
    return super.inboundBusStopsMap;
  }

  @override
  set inboundBusStopsMap(ObservableMap<String, List<BusStop>> value) {
    _$inboundBusStopsMapAtom.reportWrite(value, super.inboundBusStopsMap, () {
      super.inboundBusStopsMap = value;
    });
  }

  final _$outboundBusStopsMapAtom =
      Atom(name: 'DataManagerBase.outboundBusStopsMap');

  @override
  ObservableMap<String, List<BusStop>> get outboundBusStopsMap {
    _$outboundBusStopsMapAtom.reportRead();
    return super.outboundBusStopsMap;
  }

  @override
  set outboundBusStopsMap(ObservableMap<String, List<BusStop>> value) {
    _$outboundBusStopsMapAtom.reportWrite(value, super.outboundBusStopsMap, () {
      super.outboundBusStopsMap = value;
    });
  }

  final _$busStopDetailMapAtom = Atom(name: 'DataManagerBase.busStopDetailMap');

  @override
  ObservableMap<String, BusStopDetail> get busStopDetailMap {
    _$busStopDetailMapAtom.reportRead();
    return super.busStopDetailMap;
  }

  @override
  set busStopDetailMap(ObservableMap<String, BusStopDetail> value) {
    _$busStopDetailMapAtom.reportWrite(value, super.busStopDetailMap, () {
      super.busStopDetailMap = value;
    });
  }

  final _$ETAMapAtom = Atom(name: 'DataManagerBase.ETAMap');

  @override
  ObservableMap<RouteStop, List<ETA>> get ETAMap {
    _$ETAMapAtom.reportRead();
    return super.ETAMap;
  }

  @override
  set ETAMap(ObservableMap<RouteStop, List<ETA>> value) {
    _$ETAMapAtom.reportWrite(value, super.ETAMap, () {
      super.ETAMap = value;
    });
  }

  final _$bookmarkedRouteStopsAtom =
      Atom(name: 'DataManagerBase.bookmarkedRouteStops');

  @override
  ObservableList<RouteStop> get bookmarkedRouteStops {
    _$bookmarkedRouteStopsAtom.reportRead();
    return super.bookmarkedRouteStops;
  }

  @override
  set bookmarkedRouteStops(ObservableList<RouteStop> value) {
    _$bookmarkedRouteStopsAtom.reportWrite(value, super.bookmarkedRouteStops,
        () {
      super.bookmarkedRouteStops = value;
    });
  }

  final _$addRouteStopToBookmarkAsyncAction =
      AsyncAction('DataManagerBase.addRouteStopToBookmark');

  @override
  Future<void> addRouteStopToBookmark(RouteStop routeStop) {
    return _$addRouteStopToBookmarkAsyncAction
        .run(() => super.addRouteStopToBookmark(routeStop));
  }

  final _$removeRouteStopFromBookmarkAsyncAction =
      AsyncAction('DataManagerBase.removeRouteStopFromBookmark');

  @override
  Future<void> removeRouteStopFromBookmark(RouteStop routeStop) {
    return _$removeRouteStopFromBookmarkAsyncAction
        .run(() => super.removeRouteStopFromBookmark(routeStop));
  }

  final _$DataManagerBaseActionController =
      ActionController(name: 'DataManagerBase');

  @override
  void setRoutes(List<Map<String, dynamic>> dataArray, String companyCode) {
    final _$actionInfo = _$DataManagerBaseActionController.startAction(
        name: 'DataManagerBase.setRoutes');
    try {
      return super.setRoutes(dataArray, companyCode);
    } finally {
      _$DataManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateBusStopsMap(
      String routeCode, bool isInbound, List<Map<String, dynamic>> dataArray) {
    final _$actionInfo = _$DataManagerBaseActionController.startAction(
        name: 'DataManagerBase.updateBusStopsMap');
    try {
      return super.updateBusStopsMap(routeCode, isInbound, dataArray);
    } finally {
      _$DataManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateBusStopDetailMap(String stopId, Map<String, dynamic> busStopData) {
    final _$actionInfo = _$DataManagerBaseActionController.startAction(
        name: 'DataManagerBase.updateBusStopDetailMap');
    try {
      return super.updateBusStopDetailMap(stopId, busStopData);
    } finally {
      _$DataManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateETAMap(String stopId, String routeCode, String companyCode,
      List<Map<String, dynamic>> dataArray) {
    final _$actionInfo = _$DataManagerBaseActionController.startAction(
        name: 'DataManagerBase.updateETAMap');
    try {
      return super.updateETAMap(stopId, routeCode, companyCode, dataArray);
    } finally {
      _$DataManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRoutStopBookmarks(List<RouteStop> list) {
    final _$actionInfo = _$DataManagerBaseActionController.startAction(
        name: 'DataManagerBase.setRoutStopBookmarks');
    try {
      return super.setRoutStopBookmarks(list);
    } finally {
      _$DataManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
companyRoutesMap: ${companyRoutesMap},
inboundBusStopsMap: ${inboundBusStopsMap},
outboundBusStopsMap: ${outboundBusStopsMap},
busStopDetailMap: ${busStopDetailMap},
ETAMap: ${ETAMap},
bookmarkedRouteStops: ${bookmarkedRouteStops},
routes: ${routes},
routesMap: ${routesMap},
directionalRouteList: ${directionalRouteList}
    ''';
  }
}
