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

  final _$_downloadAllDataAtom =
      Atom(name: 'AppConfigStoreBase._downloadAllData');

  @override
  bool get _downloadAllData {
    _$_downloadAllDataAtom.reportRead();
    return super._downloadAllData;
  }

  @override
  set _downloadAllData(bool value) {
    _$_downloadAllDataAtom.reportWrite(value, super._downloadAllData, () {
      super._downloadAllData = value;
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
showSearchButtonReminder: ${showSearchButtonReminder}
    ''';
  }
}
