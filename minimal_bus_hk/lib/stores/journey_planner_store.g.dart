// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_planner_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$JourneyPlannerStore on JourneyPlannerStoreBase, Store {
  Computed<BusStopDetail> _$originBusStopComputed;

  @override
  BusStopDetail get originBusStop => (_$originBusStopComputed ??=
          Computed<BusStopDetail>(() => super.originBusStop,
              name: 'JourneyPlannerStoreBase.originBusStop'))
      .value;
  Computed<BusStopDetail> _$destinationBusStopComputed;

  @override
  BusStopDetail get destinationBusStop => (_$destinationBusStopComputed ??=
          Computed<BusStopDetail>(() => super.destinationBusStop,
              name: 'JourneyPlannerStoreBase.destinationBusStop'))
      .value;
  Computed<List<String>> _$_keywordsComputed;

  @override
  List<String> get _keywords =>
      (_$_keywordsComputed ??= Computed<List<String>>(() => super._keywords,
              name: 'JourneyPlannerStoreBase._keywords'))
          .value;
  Computed<List<BusStopDetail>> _$filteredBusStopDetailListComputed;

  @override
  List<BusStopDetail> get filteredBusStopDetailList =>
      (_$filteredBusStopDetailListComputed ??= Computed<List<BusStopDetail>>(
              () => super.filteredBusStopDetailList,
              name: 'JourneyPlannerStoreBase.filteredBusStopDetailList'))
          .value;

  final _$selectionModeAtom =
      Atom(name: 'JourneyPlannerStoreBase.selectionMode');

  @override
  StopSelectionMode get selectionMode {
    _$selectionModeAtom.reportRead();
    return super.selectionMode;
  }

  @override
  set selectionMode(StopSelectionMode value) {
    _$selectionModeAtom.reportWrite(value, super.selectionMode, () {
      super.selectionMode = value;
    });
  }

  final _$filterKeywordsAtom =
      Atom(name: 'JourneyPlannerStoreBase.filterKeywords');

  @override
  String get filterKeywords {
    _$filterKeywordsAtom.reportRead();
    return super.filterKeywords;
  }

  @override
  set filterKeywords(String value) {
    _$filterKeywordsAtom.reportWrite(value, super.filterKeywords, () {
      super.filterKeywords = value;
    });
  }

  final _$originStopIdAtom = Atom(name: 'JourneyPlannerStoreBase.originStopId');

  @override
  String get originStopId {
    _$originStopIdAtom.reportRead();
    return super.originStopId;
  }

  @override
  set originStopId(String value) {
    _$originStopIdAtom.reportWrite(value, super.originStopId, () {
      super.originStopId = value;
    });
  }

  final _$destinationStopIdAtom =
      Atom(name: 'JourneyPlannerStoreBase.destinationStopId');

  @override
  String get destinationStopId {
    _$destinationStopIdAtom.reportRead();
    return super.destinationStopId;
  }

  @override
  set destinationStopId(String value) {
    _$destinationStopIdAtom.reportWrite(value, super.destinationStopId, () {
      super.destinationStopId = value;
    });
  }

  final _$JourneyPlannerStoreBaseActionController =
      ActionController(name: 'JourneyPlannerStoreBase');

  @override
  void setSelectionMode(StopSelectionMode mode) {
    final _$actionInfo = _$JourneyPlannerStoreBaseActionController.startAction(
        name: 'JourneyPlannerStoreBase.setSelectionMode');
    try {
      return super.setSelectionMode(mode);
    } finally {
      _$JourneyPlannerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilterKeywords(String keywords) {
    final _$actionInfo = _$JourneyPlannerStoreBaseActionController.startAction(
        name: 'JourneyPlannerStoreBase.setFilterKeywords');
    try {
      return super.setFilterKeywords(keywords);
    } finally {
      _$JourneyPlannerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOriginStopId(String id) {
    final _$actionInfo = _$JourneyPlannerStoreBaseActionController.startAction(
        name: 'JourneyPlannerStoreBase.setOriginStopId');
    try {
      return super.setOriginStopId(id);
    } finally {
      _$JourneyPlannerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDestinationStopId(String id) {
    final _$actionInfo = _$JourneyPlannerStoreBaseActionController.startAction(
        name: 'JourneyPlannerStoreBase.setDestinationStopId');
    try {
      return super.setDestinationStopId(id);
    } finally {
      _$JourneyPlannerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectionMode: ${selectionMode},
filterKeywords: ${filterKeywords},
originStopId: ${originStopId},
destinationStopId: ${destinationStopId},
originBusStop: ${originBusStop},
destinationBusStop: ${destinationBusStop},
filteredBusStopDetailList: ${filteredBusStopDetailList}
    ''';
  }
}
