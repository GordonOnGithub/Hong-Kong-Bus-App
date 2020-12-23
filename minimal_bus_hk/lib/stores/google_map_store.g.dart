// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GoogleMapStore on GoogleMapStoreBase, Store {
  Computed<ObservableList<BusStopDetail>> _$busStopsComputed;

  @override
  ObservableList<BusStopDetail> get busStops => (_$busStopsComputed ??=
          Computed<ObservableList<BusStopDetail>>(() => super.busStops,
              name: 'GoogleMapStoreBase.busStops'))
      .value;

  final _$selectedBusStopAtom =
      Atom(name: 'GoogleMapStoreBase.selectedBusStop');

  @override
  BusStopDetail get selectedBusStop {
    _$selectedBusStopAtom.reportRead();
    return super.selectedBusStop;
  }

  @override
  set selectedBusStop(BusStopDetail value) {
    _$selectedBusStopAtom.reportWrite(value, super.selectedBusStop, () {
      super.selectedBusStop = value;
    });
  }

  final _$selectedRouteAtom = Atom(name: 'GoogleMapStoreBase.selectedRoute');

  @override
  BusRoute get selectedRoute {
    _$selectedRouteAtom.reportRead();
    return super.selectedRoute;
  }

  @override
  set selectedRoute(BusRoute value) {
    _$selectedRouteAtom.reportWrite(value, super.selectedRoute, () {
      super.selectedRoute = value;
    });
  }

  final _$isInboundAtom = Atom(name: 'GoogleMapStoreBase.isInbound');

  @override
  bool get isInbound {
    _$isInboundAtom.reportRead();
    return super.isInbound;
  }

  @override
  set isInbound(bool value) {
    _$isInboundAtom.reportWrite(value, super.isInbound, () {
      super.isInbound = value;
    });
  }

  final _$currentZoomLevelAtom =
      Atom(name: 'GoogleMapStoreBase.currentZoomLevel');

  @override
  double get currentZoomLevel {
    _$currentZoomLevelAtom.reportRead();
    return super.currentZoomLevel;
  }

  @override
  set currentZoomLevel(double value) {
    _$currentZoomLevelAtom.reportWrite(value, super.currentZoomLevel, () {
      super.currentZoomLevel = value;
    });
  }

  final _$locationPermissionGrantedAtom =
      Atom(name: 'GoogleMapStoreBase.locationPermissionGranted');

  @override
  bool get locationPermissionGranted {
    _$locationPermissionGrantedAtom.reportRead();
    return super.locationPermissionGranted;
  }

  @override
  set locationPermissionGranted(bool value) {
    _$locationPermissionGrantedAtom
        .reportWrite(value, super.locationPermissionGranted, () {
      super.locationPermissionGranted = value;
    });
  }

  final _$GoogleMapStoreBaseActionController =
      ActionController(name: 'GoogleMapStoreBase');

  @override
  void setSelectedBusStop(BusStopDetail busStop) {
    final _$actionInfo = _$GoogleMapStoreBaseActionController.startAction(
        name: 'GoogleMapStoreBase.setSelectedBusStop');
    try {
      return super.setSelectedBusStop(busStop);
    } finally {
      _$GoogleMapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedRoute(BusRoute selectedRoute) {
    final _$actionInfo = _$GoogleMapStoreBaseActionController.startAction(
        name: 'GoogleMapStoreBase.setSelectedRoute');
    try {
      return super.setSelectedRoute(selectedRoute);
    } finally {
      _$GoogleMapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsInbound(bool isInbound) {
    final _$actionInfo = _$GoogleMapStoreBaseActionController.startAction(
        name: 'GoogleMapStoreBase.setIsInbound');
    try {
      return super.setIsInbound(isInbound);
    } finally {
      _$GoogleMapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentZoomLevel(double zoom) {
    final _$actionInfo = _$GoogleMapStoreBaseActionController.startAction(
        name: 'GoogleMapStoreBase.setCurrentZoomLevel');
    try {
      return super.setCurrentZoomLevel(zoom);
    } finally {
      _$GoogleMapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLocationPermissionGranted(bool locationPermissionGranted) {
    final _$actionInfo = _$GoogleMapStoreBaseActionController.startAction(
        name: 'GoogleMapStoreBase.setLocationPermissionGranted');
    try {
      return super.setLocationPermissionGranted(locationPermissionGranted);
    } finally {
      _$GoogleMapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedBusStop: ${selectedBusStop},
selectedRoute: ${selectedRoute},
isInbound: ${isInbound},
currentZoomLevel: ${currentZoomLevel},
locationPermissionGranted: ${locationPermissionGranted},
busStops: ${busStops}
    ''';
  }
}
