// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppConfigStore on AppConfigStoreBase, Store {
  final _$arrivalImminentTimeMillisecondsAtom =
      Atom(name: 'AppConfigStoreBase.arrivalImminentTimeMilliseconds');

  @override
  int get arrivalImminentTimeMilliseconds {
    _$arrivalImminentTimeMillisecondsAtom.reportRead();
    return super.arrivalImminentTimeMilliseconds;
  }

  @override
  set arrivalImminentTimeMilliseconds(int value) {
    _$arrivalImminentTimeMillisecondsAtom
        .reportWrite(value, super.arrivalImminentTimeMilliseconds, () {
      super.arrivalImminentTimeMilliseconds = value;
    });
  }

  final _$arrivalExpiryTimeMillisecondsAtom =
      Atom(name: 'AppConfigStoreBase.arrivalExpiryTimeMilliseconds');

  @override
  int get arrivalExpiryTimeMilliseconds {
    _$arrivalExpiryTimeMillisecondsAtom.reportRead();
    return super.arrivalExpiryTimeMilliseconds;
  }

  @override
  set arrivalExpiryTimeMilliseconds(int value) {
    _$arrivalExpiryTimeMillisecondsAtom
        .reportWrite(value, super.arrivalExpiryTimeMilliseconds, () {
      super.arrivalExpiryTimeMilliseconds = value;
    });
  }

  final _$downloadAllDataAtom =
      Atom(name: 'AppConfigStoreBase.downloadAllData');

  @override
  bool get downloadAllData {
    _$downloadAllDataAtom.reportRead();
    return super.downloadAllData;
  }

  @override
  set downloadAllData(bool value) {
    _$downloadAllDataAtom.reportWrite(value, super.downloadAllData, () {
      super.downloadAllData = value;
    });
  }

  final _$_routeSearchReminderAtom =
      Atom(name: 'AppConfigStoreBase._routeSearchReminder');

  @override
  bool get _routeSearchReminder {
    _$_routeSearchReminderAtom.reportRead();
    return super._routeSearchReminder;
  }

  @override
  set _routeSearchReminder(bool value) {
    _$_routeSearchReminderAtom.reportWrite(value, super._routeSearchReminder,
        () {
      super._routeSearchReminder = value;
    });
  }

  final _$showSearchButtonReminderAtom =
      Atom(name: 'AppConfigStoreBase.showSearchButtonReminder');

  @override
  bool get showSearchButtonReminder {
    _$showSearchButtonReminderAtom.reportRead();
    return super.showSearchButtonReminder;
  }

  @override
  set showSearchButtonReminder(bool value) {
    _$showSearchButtonReminderAtom
        .reportWrite(value, super.showSearchButtonReminder, () {
      super.showSearchButtonReminder = value;
    });
  }

  final _$showRouteDetailReminderAtom =
      Atom(name: 'AppConfigStoreBase.showRouteDetailReminder');

  @override
  bool get showRouteDetailReminder {
    _$showRouteDetailReminderAtom.reportRead();
    return super.showRouteDetailReminder;
  }

  @override
  set showRouteDetailReminder(bool value) {
    _$showRouteDetailReminderAtom
        .reportWrite(value, super.showRouteDetailReminder, () {
      super.showRouteDetailReminder = value;
    });
  }

  final _$shouldDownloadAllDataAsyncAction =
      AsyncAction('AppConfigStoreBase.shouldDownloadAllData');

  @override
  Future<bool> shouldDownloadAllData() {
    return _$shouldDownloadAllDataAsyncAction
        .run(() => super.shouldDownloadAllData());
  }

  final _$setShouldDownloadAllDataAsyncAction =
      AsyncAction('AppConfigStoreBase.setShouldDownloadAllData');

  @override
  Future<void> setShouldDownloadAllData(bool shouldDownload) {
    return _$setShouldDownloadAllDataAsyncAction
        .run(() => super.setShouldDownloadAllData(shouldDownload));
  }

  final _$shouldShowRouteSearchReminderAsyncAction =
      AsyncAction('AppConfigStoreBase.shouldShowRouteSearchReminder');

  @override
  Future<bool> shouldShowRouteSearchReminder() {
    return _$shouldShowRouteSearchReminderAsyncAction
        .run(() => super.shouldShowRouteSearchReminder());
  }

  final _$setShouldShowRouteSearchReminderAsyncAction =
      AsyncAction('AppConfigStoreBase.setShouldShowRouteSearchReminder');

  @override
  Future<void> setShouldShowRouteSearchReminder(bool shouldRemind) {
    return _$setShouldShowRouteSearchReminderAsyncAction
        .run(() => super.setShouldShowRouteSearchReminder(shouldRemind));
  }

  final _$checkShowSearchButtonReminderAsyncAction =
      AsyncAction('AppConfigStoreBase.checkShowSearchButtonReminder');

  @override
  Future<void> checkShowSearchButtonReminder() {
    return _$checkShowSearchButtonReminderAsyncAction
        .run(() => super.checkShowSearchButtonReminder());
  }

  final _$setShowSearchButtonReminderAsyncAction =
      AsyncAction('AppConfigStoreBase.setShowSearchButtonReminder');

  @override
  Future<void> setShowSearchButtonReminder(bool shouldShow) {
    return _$setShowSearchButtonReminderAsyncAction
        .run(() => super.setShowSearchButtonReminder(shouldShow));
  }

  final _$checkShowRouteDetailReminderAsyncAction =
      AsyncAction('AppConfigStoreBase.checkShowRouteDetailReminder');

  @override
  Future<void> checkShowRouteDetailReminder() {
    return _$checkShowRouteDetailReminderAsyncAction
        .run(() => super.checkShowRouteDetailReminder());
  }

  final _$setShowRouteDetailReminderAsyncAction =
      AsyncAction('AppConfigStoreBase.setShowRouteDetailReminder');

  @override
  Future<void> setShowRouteDetailReminder(bool shouldShow) {
    return _$setShowRouteDetailReminderAsyncAction
        .run(() => super.setShowRouteDetailReminder(shouldShow));
  }

  final _$AppConfigStoreBaseActionController =
      ActionController(name: 'AppConfigStoreBase');

  @override
  void setArrivalImminentTimeMilliseconds(int timeMilliseconds) {
    final _$actionInfo = _$AppConfigStoreBaseActionController.startAction(
        name: 'AppConfigStoreBase.setArrivalImminentTimeMilliseconds');
    try {
      return super.setArrivalImminentTimeMilliseconds(timeMilliseconds);
    } finally {
      _$AppConfigStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setArrivalExpiryTimeMilliseconds(int timeMilliseconds) {
    final _$actionInfo = _$AppConfigStoreBaseActionController.startAction(
        name: 'AppConfigStoreBase.setArrivalExpiryTimeMilliseconds');
    try {
      return super.setArrivalExpiryTimeMilliseconds(timeMilliseconds);
    } finally {
      _$AppConfigStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
arrivalImminentTimeMilliseconds: ${arrivalImminentTimeMilliseconds},
arrivalExpiryTimeMilliseconds: ${arrivalExpiryTimeMilliseconds},
downloadAllData: ${downloadAllData},
showSearchButtonReminder: ${showSearchButtonReminder},
showRouteDetailReminder: ${showRouteDetailReminder}
    ''';
  }
}
