// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RouteListStore on RouteListStoreBase, Store {
  Computed<List<String>> _$_keywordsComputed;

  @override
  List<String> get _keywords =>
      (_$_keywordsComputed ??= Computed<List<String>>(() => super._keywords,
              name: 'RouteListStoreBase._keywords'))
          .value;
  Computed<ObservableList<BusRoute>> _$displayedRoutesComputed;

  @override
  ObservableList<BusRoute> get displayedRoutes => (_$displayedRoutesComputed ??=
          Computed<ObservableList<BusRoute>>(() => super.displayedRoutes,
              name: 'RouteListStoreBase.displayedRoutes'))
      .value;

  final _$filterKeywordAtom = Atom(name: 'RouteListStoreBase.filterKeyword');

  @override
  String get filterKeyword {
    _$filterKeywordAtom.reportRead();
    return super.filterKeyword;
  }

  @override
  set filterKeyword(String value) {
    _$filterKeywordAtom.reportWrite(value, super.filterKeyword, () {
      super.filterKeyword = value;
    });
  }

  final _$selectedRouteAtom = Atom(name: 'RouteListStoreBase.selectedRoute');

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

  final _$dataFetchingErrorAtom =
      Atom(name: 'RouteListStoreBase.dataFetchingError');

  @override
  bool get dataFetchingError {
    _$dataFetchingErrorAtom.reportRead();
    return super.dataFetchingError;
  }

  @override
  set dataFetchingError(bool value) {
    _$dataFetchingErrorAtom.reportWrite(value, super.dataFetchingError, () {
      super.dataFetchingError = value;
    });
  }

  final _$RouteListStoreBaseActionController =
      ActionController(name: 'RouteListStoreBase');

  @override
  void setFilterKeyword(String keyword) {
    final _$actionInfo = _$RouteListStoreBaseActionController.startAction(
        name: 'RouteListStoreBase.setFilterKeyword');
    try {
      return super.setFilterKeyword(keyword);
    } finally {
      _$RouteListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedRoute(BusRoute busRoute) {
    final _$actionInfo = _$RouteListStoreBaseActionController.startAction(
        name: 'RouteListStoreBase.setSelectedRoute');
    try {
      return super.setSelectedRoute(busRoute);
    } finally {
      _$RouteListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataFetchingError(bool hasError) {
    final _$actionInfo = _$RouteListStoreBaseActionController.startAction(
        name: 'RouteListStoreBase.setDataFetchingError');
    try {
      return super.setDataFetchingError(hasError);
    } finally {
      _$RouteListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filterKeyword: ${filterKeyword},
selectedRoute: ${selectedRoute},
dataFetchingError: ${dataFetchingError},
displayedRoutes: ${displayedRoutes}
    ''';
  }
}
