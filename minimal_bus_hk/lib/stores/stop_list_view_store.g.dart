// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_list_view_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StopListViewStore on StopListViewStoreBase, Store {
  Computed<List<String>> _$_keywordsComputed;

  @override
  List<String> get _keywords =>
      (_$_keywordsComputed ??= Computed<List<String>>(() => super._keywords,
              name: 'StopListViewStoreBase._keywords'))
          .value;
  Computed<List<BusStopDetail>> _$filteredBusStopDetailListComputed;

  @override
  List<BusStopDetail> get filteredBusStopDetailList =>
      (_$filteredBusStopDetailListComputed ??= Computed<List<BusStopDetail>>(
              () => super.filteredBusStopDetailList,
              name: 'StopListViewStoreBase.filteredBusStopDetailList'))
          .value;

  final _$filterKeywordsAtom =
      Atom(name: 'StopListViewStoreBase.filterKeywords');

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

  final _$StopListViewStoreBaseActionController =
      ActionController(name: 'StopListViewStoreBase');

  @override
  void setFilterKeywords(String keywords) {
    final _$actionInfo = _$StopListViewStoreBaseActionController.startAction(
        name: 'StopListViewStoreBase.setFilterKeywords');
    try {
      return super.setFilterKeywords(keywords);
    } finally {
      _$StopListViewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filterKeywords: ${filterKeywords},
filteredBusStopDetailList: ${filteredBusStopDetailList}
    ''';
  }
}
