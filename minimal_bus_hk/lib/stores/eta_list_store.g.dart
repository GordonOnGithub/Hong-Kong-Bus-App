// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eta_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ETAListStore on ETAListStoreBase, Store {
  Computed<ObservableList<List<ETA>>> _$routesETAListComputed;

  @override
  ObservableList<List<ETA>> get routesETAList => (_$routesETAListComputed ??=
          Computed<ObservableList<List<ETA>>>(() => super.routesETAList,
              name: 'ETAListStoreBase.routesETAList'))
      .value;
  Computed<ObservableList<ETA>> _$displayedETAsComputed;

  @override
  ObservableList<ETA> get displayedETAs => (_$displayedETAsComputed ??=
          Computed<ObservableList<ETA>>(() => super.displayedETAs,
              name: 'ETAListStoreBase.displayedETAs'))
      .value;

  final _$isLoadingAtom = Atom(name: 'ETAListStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$selectedETAListIndexAtom =
      Atom(name: 'ETAListStoreBase.selectedETAListIndex');

  @override
  int get selectedETAListIndex {
    _$selectedETAListIndexAtom.reportRead();
    return super.selectedETAListIndex;
  }

  @override
  set selectedETAListIndex(int value) {
    _$selectedETAListIndexAtom.reportWrite(value, super.selectedETAListIndex,
        () {
      super.selectedETAListIndex = value;
    });
  }

  final _$timeStampForCheckingAtom =
      Atom(name: 'ETAListStoreBase.timeStampForChecking');

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

  final _$ETAListStoreBaseActionController =
      ActionController(name: 'ETAListStoreBase');

  @override
  void setIsLoading(bool isLoading) {
    final _$actionInfo = _$ETAListStoreBaseActionController.startAction(
        name: 'ETAListStoreBase.setIsLoading');
    try {
      return super.setIsLoading(isLoading);
    } finally {
      _$ETAListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedETAListIndex(int index) {
    final _$actionInfo = _$ETAListStoreBaseActionController.startAction(
        name: 'ETAListStoreBase.setSelectedETAListIndex');
    try {
      return super.setSelectedETAListIndex(index);
    } finally {
      _$ETAListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateTimeStampForChecking() {
    final _$actionInfo = _$ETAListStoreBaseActionController.startAction(
        name: 'ETAListStoreBase.updateTimeStampForChecking');
    try {
      return super.updateTimeStampForChecking();
    } finally {
      _$ETAListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
selectedETAListIndex: ${selectedETAListIndex},
timeStampForChecking: ${timeStampForChecking},
routesETAList: ${routesETAList},
displayedETAs: ${displayedETAs}
    ''';
  }
}
