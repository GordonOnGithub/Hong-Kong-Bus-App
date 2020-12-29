// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_view_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingViewStore on SettingViewStoreBase, Store {
  final _$selectedOptionAtom =
      Atom(name: 'SettingViewStoreBase.selectedOption');

  @override
  SelectedOption get selectedOption {
    _$selectedOptionAtom.reportRead();
    return super.selectedOption;
  }

  @override
  set selectedOption(SelectedOption value) {
    _$selectedOptionAtom.reportWrite(value, super.selectedOption, () {
      super.selectedOption = value;
    });
  }

  final _$versionAtom = Atom(name: 'SettingViewStoreBase.version');

  @override
  String get version {
    _$versionAtom.reportRead();
    return super.version;
  }

  @override
  set version(String value) {
    _$versionAtom.reportWrite(value, super.version, () {
      super.version = value;
    });
  }

  final _$checkVersionAsyncAction =
      AsyncAction('SettingViewStoreBase.checkVersion');

  @override
  Future<void> checkVersion() {
    return _$checkVersionAsyncAction.run(() => super.checkVersion());
  }

  final _$SettingViewStoreBaseActionController =
      ActionController(name: 'SettingViewStoreBase');

  @override
  void setSelectedOption(SelectedOption option) {
    final _$actionInfo = _$SettingViewStoreBaseActionController.startAction(
        name: 'SettingViewStoreBase.setSelectedOption');
    try {
      return super.setSelectedOption(option);
    } finally {
      _$SettingViewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedOption: ${selectedOption},
version: ${version}
    ''';
  }
}
