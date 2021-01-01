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
  Computed<ObservableList<DirectionalRoute>>
      _$displayedDirectionalRoutesComputed;

  @override
  ObservableList<DirectionalRoute> get displayedDirectionalRoutes =>
      (_$displayedDirectionalRoutesComputed ??=
              Computed<ObservableList<DirectionalRoute>>(
                  () => super.displayedDirectionalRoutes,
                  name: 'RouteListStoreBase.displayedDirectionalRoutes'))
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

  final _$selectedDirectionalRouteAtom =
      Atom(name: 'RouteListStoreBase.selectedDirectionalRoute');

  @override
  DirectionalRoute get selectedDirectionalRoute {
    _$selectedDirectionalRouteAtom.reportRead();
    return super.selectedDirectionalRoute;
  }

  @override
  set selectedDirectionalRoute(DirectionalRoute value) {
    _$selectedDirectionalRouteAtom
        .reportWrite(value, super.selectedDirectionalRoute, () {
      super.selectedDirectionalRoute = value;
    });
  }

  final _$filterStopIdentifierAtom =
      Atom(name: 'RouteListStoreBase.filterStopIdentifier');

  @override
  String get filterStopIdentifier {
    _$filterStopIdentifierAtom.reportRead();
    return super.filterStopIdentifier;
  }

  @override
  set filterStopIdentifier(String value) {
    _$filterStopIdentifierAtom.reportWrite(value, super.filterStopIdentifier,
        () {
      super.filterStopIdentifier = value;
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
  void setSelectedDirectionalRoute(DirectionalRoute busRoute) {
    final _$actionInfo = _$RouteListStoreBaseActionController.startAction(
        name: 'RouteListStoreBase.setSelectedDirectionalRoute');
    try {
      return super.setSelectedDirectionalRoute(busRoute);
    } finally {
      _$RouteListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilterStopIdentifier(String identifier) {
    final _$actionInfo = _$RouteListStoreBaseActionController.startAction(
        name: 'RouteListStoreBase.setFilterStopIdentifier');
    try {
      return super.setFilterStopIdentifier(identifier);
    } finally {
      _$RouteListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$RouteListStoreBaseActionController.startAction(
        name: 'RouteListStoreBase.clearFilters');
    try {
      return super.clearFilters();
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
selectedDirectionalRoute: ${selectedDirectionalRoute},
filterStopIdentifier: ${filterStopIdentifier},
dataFetchingError: ${dataFetchingError},
displayedDirectionalRoutes: ${displayedDirectionalRoutes}
    ''';
  }
}
