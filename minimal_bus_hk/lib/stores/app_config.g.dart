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
arrivalExpiryTimeMilliseconds: ${arrivalExpiryTimeMilliseconds}
    ''';
  }
}
