import 'package:mobx/mobx.dart';
import 'package:package_info/package_info.dart';

part 'setting_view_store.g.dart';

class SettingViewStore = SettingViewStoreBase with _$SettingViewStore;

enum SelectedOption{
  none,
  language,
  data,
  appStore,
  about,
}

abstract class SettingViewStoreBase with Store {
  @observable
  SelectedOption selectedOption = SelectedOption.none;

  @action
  void setSelectedOption(SelectedOption option){
    selectedOption = option;
  }

  @observable
  String version = "";

  @action
  Future<void> checkVersion() async{
    if(version.length == 0){
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = "${packageInfo.version}(${packageInfo.buildNumber})";
    }
  }
}