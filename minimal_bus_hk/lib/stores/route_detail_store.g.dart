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

  final _$routeCodeAtom = Atom(name: 'RouteDetailStoreBase.routeCode');

  @override
  String get routeCode {
    _$routeCodeAtom.reportRead();
    return super.routeCode;
  }

  @override
  set routeCode(String value) {
    _$routeCodeAtom.reportWrite(value, super.routeCode, () {
      super.routeCode = value;
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

  final _$RouteDetailStoreBaseActionController =
      ActionController(name: 'RouteDetailStoreBase');

  @override
  void setRouteCode(String routeCode) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setRouteCode');
    try {
      return super.setRouteCode(routeCode);
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
  String toString() {
    return '''
routeCode: ${routeCode},
isInbound: ${isInbound},
selectedRouteBusStops: ${selectedRouteBusStops}
    ''';
  }
}
