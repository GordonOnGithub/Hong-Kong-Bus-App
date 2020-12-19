// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LocalizationStore on LocalizationStoreBase, Store {
  final _$localizationPrefAtom =
      Atom(name: 'LocalizationStoreBase.localizationPref');

  @override
  LocalizationPref get localizationPref {
    _$localizationPrefAtom.reportRead();
    return super.localizationPref;
  }

  @override
  set localizationPref(LocalizationPref value) {
    _$localizationPrefAtom.reportWrite(value, super.localizationPref, () {
      super.localizationPref = value;
    });
  }

  final _$_localizationMapAtom =
      Atom(name: 'LocalizationStoreBase._localizationMap');

  @override
  ObservableMap<String, Map<String, String>> get _localizationMap {
    _$_localizationMapAtom.reportRead();
    return super._localizationMap;
  }

  @override
  set _localizationMap(ObservableMap<String, Map<String, String>> value) {
    _$_localizationMapAtom.reportWrite(value, super._localizationMap, () {
      super._localizationMap = value;
    });
  }

  final _$loadDataFromAssetAsyncAction =
      AsyncAction('LocalizationStoreBase.loadDataFromAsset');

  @override
  Future<void> loadDataFromAsset() {
    return _$loadDataFromAssetAsyncAction.run(() => super.loadDataFromAsset());
  }

  final _$LocalizationStoreBaseActionController =
      ActionController(name: 'LocalizationStoreBase');

  @override
  void setLocalizationPref(LocalizationPref pref) {
    final _$actionInfo = _$LocalizationStoreBaseActionController.startAction(
        name: 'LocalizationStoreBase.setLocalizationPref');
    try {
      return super.setLocalizationPref(pref);
    } finally {
      _$LocalizationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
localizationPref: ${localizationPref}
    ''';
  }
}