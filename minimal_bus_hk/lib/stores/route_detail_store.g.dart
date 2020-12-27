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
  Computed<List<String>> _$_keywordsComputed;

  @override
  List<String> get _keywords =>
      (_$_keywordsComputed ??= Computed<List<String>>(() => super._keywords,
              name: 'RouteDetailStoreBase._keywords'))
          .value;
  Computed<ObservableList<BusStopDetailWithETA>> _$displayedStopsComputed;

  @override
  ObservableList<BusStopDetailWithETA> get displayedStops =>
      (_$displayedStopsComputed ??=
              Computed<ObservableList<BusStopDetailWithETA>>(
                  () => super.displayedStops,
                  name: 'RouteDetailStoreBase.displayedStops'))
          .value;
  Computed<ObservableList<List<ETA>>> _$routesETAListComputed;

  @override
  ObservableList<List<ETA>> get routesETAList => (_$routesETAListComputed ??=
          Computed<ObservableList<List<ETA>>>(() => super.routesETAList,
              name: 'RouteDetailStoreBase.routesETAList'))
      .value;
  Computed<ObservableMap<String, ETA>> _$displayedETAMapComputed;

  @override
  ObservableMap<String, ETA> get displayedETAMap =>
      (_$displayedETAMapComputed ??= Computed<ObservableMap<String, ETA>>(
              () => super.displayedETAMap,
              name: 'RouteDetailStoreBase.displayedETAMap'))
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

  final _$selectedStopIdAtom =
      Atom(name: 'RouteDetailStoreBase.selectedStopId');

  @override
  String get selectedStopId {
    _$selectedStopIdAtom.reportRead();
    return super.selectedStopId;
  }

  @override
  set selectedStopId(String value) {
    _$selectedStopIdAtom.reportWrite(value, super.selectedStopId, () {
      super.selectedStopId = value;
    });
  }

  final _$dataFetchingErrorAtom =
      Atom(name: 'RouteDetailStoreBase.dataFetchingError');

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

  final _$filterKeywordAtom = Atom(name: 'RouteDetailStoreBase.filterKeyword');

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

  final _$selectedSequenceAtom =
      Atom(name: 'RouteDetailStoreBase.selectedSequence');

  @override
  int get selectedSequence {
    _$selectedSequenceAtom.reportRead();
    return super.selectedSequence;
  }

  @override
  set selectedSequence(int value) {
    _$selectedSequenceAtom.reportWrite(value, super.selectedSequence, () {
      super.selectedSequence = value;
    });
  }

  final _$timeStampForCheckingAtom =
      Atom(name: 'RouteDetailStoreBase.timeStampForChecking');

  @override
  DateTime get timeStampForChecking {
    _$timeStampForCheckingAtom.reportRead();
    return super.timeStampForChecking;
  }

  @override
  set timeStampForChecking(DateTime value) {
    _$timeStampForCheckingAtom.reportWrite(value, super.timeStampForChecking,
        () {
      super.timeStampForChecking = value;
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
  void setSelectedStopId(String stopId) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setSelectedStopId');
    try {
      return super.setSelectedStopId(stopId);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataFetchingError(bool hasError) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setDataFetchingError');
    try {
      return super.setDataFetchingError(hasError);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilterKeyword(String keyword) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setFilterKeyword');
    try {
      return super.setFilterKeyword(keyword);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedSequence(int seq) {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.setSelectedSequence');
    try {
      return super.setSelectedSequence(seq);
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateTimeStampForChecking() {
    final _$actionInfo = _$RouteDetailStoreBaseActionController.startAction(
        name: 'RouteDetailStoreBase.updateTimeStampForChecking');
    try {
      return super.updateTimeStampForChecking();
    } finally {
      _$RouteDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
route: ${route},
isInbound: ${isInbound},
selectedStopId: ${selectedStopId},
dataFetchingError: ${dataFetchingError},
filterKeyword: ${filterKeyword},
selectedSequence: ${selectedSequence},
timeStampForChecking: ${timeStampForChecking},
selectedRouteBusStops: ${selectedRouteBusStops},
displayedStops: ${displayedStops},
routesETAList: ${routesETAList},
displayedETAMap: ${displayedETAMap}
    ''';
  }
}
