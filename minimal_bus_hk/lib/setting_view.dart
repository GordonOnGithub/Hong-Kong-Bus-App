import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/stores/localization_store.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Stores.settingViewStore.checkVersion();
  }

  @override
  void dispose() {
    super.dispose();
    Stores.settingViewStore.setSelectedOption(SelectedOption.none);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
        appBar: AppBar(
          title: Observer(
              builder: (_) => Text(_getTitle(Stores.settingViewStore.selectedOption))),
        ),
        body: Center( child: Observer(
    builder: (_) => Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _getWidgetList(Stores.settingViewStore.selectedOption, Stores.settingViewStore.version),))
        ),)
    ), onWillPop: () async{
      if(Stores.settingViewStore.selectedOption != SelectedOption.none){
        Stores.settingViewStore.setSelectedOption(SelectedOption.none);
        return false;
      }else{
        return true;
      }
    },);
  }

  List<Widget> _getWidgetList(SelectedOption option, String version){
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
            Icon(Icons.archive_outlined),
            Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForSettingData, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))
          ]))
            , onTap: (){
              Stores.settingViewStore.setSelectedOption(SelectedOption.data);
            },),
          InkWell(child: Container(height: 50, alignment: Alignment.center, child:
          Row( mainAxisAlignment: MainAxisAlignment.center, children:[
              Icon(Icons.info_outline),
          Text("About", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 , decoration: TextDecoration.underline)),
          ]
          )), onTap: (){
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);

          },),
          Expanded(child: Container()),
          Text("v $version")
        ];
      case SelectedOption.language:
        return [
          Row( mainAxisAlignment:  MainAxisAlignment.center, children: [
            Stores.localizationStore.localizationPref == LocalizationPref.english? Icon(Icons.check_circle_outline): Container() ,
          InkWell(child: Container(height: 50, alignment: Alignment.center, child: Text("English", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400 , decoration: TextDecoration.underline),),), onTap: () {
            Stores.localizationStore.setLocalizationPref(LocalizationPref.english);
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);
          },),
          ],),
         Row(mainAxisAlignment:  MainAxisAlignment.center, children: [
           Stores.localizationStore.localizationPref == LocalizationPref.TC? Icon(Icons.check_circle_outline): Container() ,
          InkWell(child: Container(height: 50, alignment: Alignment.center, child: Text("繁體中文", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w400 , decoration: TextDecoration.underline)),), onTap: () {
            Stores.localizationStore.setLocalizationPref(LocalizationPref.TC);
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);
          },),]),
          Row(mainAxisAlignment:  MainAxisAlignment.center, children: [
         Stores.localizationStore.localizationPref == LocalizationPref.SC? Icon(Icons.check_circle_outline): Container() ,
          InkWell(child: Container(height: 50, alignment: Alignment.center, child: Text("簡體中文", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400 , decoration: TextDecoration.underline)),), onTap: () {
            Stores.localizationStore.setLocalizationPref(LocalizationPref.SC);
            Stores.settingViewStore.setSelectedOption(SelectedOption.none);
          },),]),
          Expanded(child: Container())
        ];
      case SelectedOption.data:
        return [
        Row(mainAxisAlignment:  MainAxisAlignment.center, children: [
        Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDownloadData, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500 ),),
          Switch(value: Stores.appConfig.downloadAllData == true, onChanged: (_){
              Stores.appConfig.setShouldDownloadAllData(!(Stores.appConfig.downloadAllData == true));
              if(Stores.appConfig.downloadAllData ){
                CacheUtils.sharedInstance().fetchAllData();
              }
          })]),
          Row(children:[ Expanded(child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDownloadAllDataPopupContent, Stores.localizationStore.localizationPref), maxLines: 3,))]),
          Expanded(child: Container())

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
      case SelectedOption.data:
        return LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForSettingData, Stores.localizationStore.localizationPref);
      case SelectedOption.about:
        return "About";
    }
    return "";

  }
}