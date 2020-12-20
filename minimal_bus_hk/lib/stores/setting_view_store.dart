import 'package:mobx/mobx.dart';

part 'setting_view_store.g.dart';

class SettingViewStore = SettingViewStoreBase with _$SettingViewStore;

enum SelectedOption{
  none,
  language,
  about

}

abstract class SettingViewStoreBase with Store {
  @observable
  SelectedOption selectedOption = SelectedOption.none;

  @action
  void setSelectedOption(SelectedOption option){
    selectedOption = option;
  }
}