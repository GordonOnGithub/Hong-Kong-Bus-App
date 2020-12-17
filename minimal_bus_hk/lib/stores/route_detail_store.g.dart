// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RouteDetailStore on RouteDetailStoreBase, Store {
  Computed<ObservableList<BusStopDetail>> _$selectedRouteBusStopsComputed;

  @override
  ObservableList<BusStopDetail> get selectedRouteBusStops =>
      (_$selectedRouteBusStopsComputed ??=
              Computed<ObservableList<BusStopDetail>>(
                  () => super.selectedRouteBusStops,
                  name: 'RouteDetailStoreBase.selectedRouteBusStops'))
          .value;

  final _$routeAtom = Atom(name: 'RouteDetailStoreBase.route');

  @override
  BusRoute get route {
    _$routeAtom.reportRead();
    return super.route;
  }

  @override
  set route(BusRoute value) {
    _$routeAtom.reportWrite(value, super.route, () {
      super.route = value;
    });
  }

  final _$isInboundAtom = Atom(name: 'RouteDetailStoreBase.isInbound');

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

  final _$selectedBusStopIndexAtom =
      Atom(name: 'RouteDetailStoreBase.selectedBusStopIndex');

  @override
  int get selectedBusStopIndex {
    _$selectedBusStopIndexAtom.reportRead();
    return super.selectedBusStopIndex;
  }

  @override
  set selectedBusStopIndex(int value) {
    _$selectedBusStopIndexAtom.reportWrite(value, super.selectedBusStopIndex,
        () {
      super.selectedBusStopIndex = value;
    });
  }

  final _$RouteDetailStoreBaseActionController =
      ActionController(name: 'RouteDetailStoreBase');

  @override
  void setBusRoute(BusRoute route) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setBusRoute');
    try {
      return super.setBusRoute(route);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsInbound(bool isInbound) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setIsInbound');
    try {
      return super.setIsInbound(isInbound);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedBusStopIndex(int index) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setSelectedBusStopIndex');
    try {
      return super.setSelectedBusStopIndex(index);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
route: ${route},
isInbound: ${isInbound},
selectedBusStopIndex: ${selectedBusStopIndex},
selectedRouteBusStops: ${selectedRouteBusStops}
    ''';
  }
}
