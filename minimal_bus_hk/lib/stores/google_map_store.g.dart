// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GoogleMapStore on GoogleMapStoreBase, Store {
  final _$selectedBusStopAtom =
      Atom(name: 'GoogleMapStoreBase.selectedBusStop');

  @override
  BusStopDetail get selectedBusStop {
    _$selectedBusStopAtom.reportRead();
    return super.selectedBusStop;
  }

  @override
  set selectedBusStop(BusStopDetail value) {
    _$selectedBusStopAtom.reportWrite(value, super.selectedBusStop, () {
      super.selectedBusStop = value;
    });
  }

  final _$GoogleMapStoreBaseActionController =
      ActionController(name: 'GoogleMapStoreBase');

  @override
  void setSelectedBusStop(BusStopDetail busStop) {
    final _$actionInfo = _$GoogleMapStoreBaseActionController.startAction(
        name: 'GoogleMapStoreBase.setSelectedBusStop');
    try {
      return super.setSelectedBusStop(busStop);
    } finally {
      _$GoogleMapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedBusStop: ${selectedBusStop}
    ''';
  }
}
