import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/stores/localization_store.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:minimal_bus_hk/stores/setting_view_store.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingViewPage();
  }
}

class SettingViewPage extends StatefulWidget {
  SettingViewPage({Key key}) : super(key: key);

  @override
  _SettingViewPageState createState() => _SettingViewPageState();
}

class _SettingViewPageState extends State<SettingViewPage> {
  @override
  void dispose() {
    super.dispose();
    Stores.settingViewStore.setSelectedOption(SelectedOption.none);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Observer(
              builder: (_) => Text(_getTitle(Stores.settingViewStore.selectedOption))),
        ),
        body: Center( child: Observer(
    builder: (_) => Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getWidgetList(Stores.settingViewStore.selectedOption),))
        ),)
    );
  }

  List<Widget> _getWidgetList(SelectedOption option){
    switch(option) {
      case SelectedOption.none:
        return [
          InkWell(child: Container(height: 50, alignment: Alignment.center, child:
          Row( mainAxisAlignment: MainAxisAlignment.center, children:[
            Icon(Icons.language),
          Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForSettingLanguage, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))
              ]))
    , onTap: (){
            Stores.settingViewStore.setSelectedOption(SelectedOption.language);
          },),

          InkWell(child: Container(height: 50, alignment: Alignment.center, child:
          Row( mainAxisAlignment: MainAxisAlignment.center, children:[
              Icon(Icons.info_outline),
          Text("About", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 , decoration: TextDecoration.underline)),
            ]
          )), onTap: (){
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);

          },),
        ];
      case SelectedOption.language:
        return [
          InkWell(child: Container(height: 50, alignment: Alignment.center, child: Text("English", style: TextStyle(fontSize: 20,fontWeight: Stores.localizationStore.localizationPref == LocalizationPref.english? FontWeight.bold : FontWeight.w400 , decoration: TextDecoration.underline),),), onTap: () {
            Stores.localizationStore.setLocalizationPref(LocalizationPref.english);
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);
          },),
          InkWell(child: Container(height: 50, alignment: Alignment.center, child: Text("繁體中文", style: TextStyle(fontSize: 20,fontWeight: Stores.localizationStore.localizationPref == LocalizationPref.TC? FontWeight.bold : FontWeight.w400 , decoration: TextDecoration.underline)),), onTap: () {
            Stores.localizationStore.setLocalizationPref(LocalizationPref.TC);
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);
          },),
          InkWell(child: Container(height: 50, alignment: Alignment.center, child: Text("簡體中文", style: TextStyle(fontSize: 20,fontWeight: Stores.localizationStore.localizationPref == LocalizationPref.SC? FontWeight.bold : FontWeight.w400 , decoration: TextDecoration.underline)),), onTap: () {
            Stores.localizationStore.setLocalizationPref(LocalizationPref.SC);
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);
          },),

        ];

      case SelectedOption.about:
        return [];
  }
  return [];
  }

  String _getTitle(SelectedOption option){
    switch(option){
      case SelectedOption.none:
        return LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForSettingView, Stores.localizationStore.localizationPref);
      case SelectedOption.language:
        return LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForSettingLanguage, Stores.localizationStore.localizationPref);
      case SelectedOption.about:
        return "About";
    }
    return "";

  }
}