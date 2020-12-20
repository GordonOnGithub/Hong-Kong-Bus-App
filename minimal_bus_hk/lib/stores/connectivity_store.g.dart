// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConnectivityStore on ConnectivityStoreBase, Store {
  final _$connectedAtom = Atom(name: 'ConnectivityStoreBase.connected');

  @override
  bool get connected {
    _$connectedAtom.reportRead();
    return super.connected;
  }

  @override
  set connected(bool value) {
    _$connectedAtom.reportWrite(value, super.connected, () {
      super.connected = value;
    });
  }

  final _$ConnectivityStoreBaseActionController =
      ActionController(name: 'ConnectivityStoreBase');

  @override
  void setConnected(bool isConnected) {
    final _$actionInfo = _$ConnectivityStoreBaseActionController.startAction(
        name: 'ConnectivityStoreBase.setConnected');
    try {
      return super.setConnected(isConnected);
    } finally {
      _$ConnectivityStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
connected: ${connected}
    ''';
  }
}
