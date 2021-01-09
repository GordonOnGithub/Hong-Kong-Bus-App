import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/google_map_view.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'model/bus_stop_detail.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class StopListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StopListViewPage();
  }
}

class StopListViewPage extends StatefulWidget {
  StopListViewPage({Key key}) : super(key: key);

  @override
  _StopListViewPageState createState() => _StopListViewPageState();
}

class _StopListViewPageState extends State<StopListViewPage> {
  TextEditingController _searchFieldController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchFieldController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          title: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForBusStopList, Stores.localizationStore.localizationPref)),
        ),
        body: Observer(
        builder: (_) =>Center(child: Stores.dataManager.allDataFetchCount >= Stores.dataManager.totalDataCount? Padding( padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20) , child:
         Column(mainAxisAlignment: MainAxisAlignment.center , children: [
           Expanded(flex: 1, child: Container( child: Row(crossAxisAlignment: CrossAxisAlignment.center, children:[
             Icon(Icons.search),
             Expanded(child: TextField(
               controller: _searchFieldController,
               onChanged: (text){
                 Stores.stopListViewStore.setFilterKeywords(text);
               },
                 decoration: InputDecoration(
                     hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForStopSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                 )
             ),
             ),
             Stores.stopListViewStore.filterKeywords.length > 0 ?
             IconButton(icon: Icon(Icons.cancel_outlined), onPressed: (){
               _searchFieldController.text = "";
               Stores.stopListViewStore.setFilterKeywords("");
             },):Container()
           ]))),
           Expanded(flex: 9, child:
           Scrollbar( child:
               MediaQuery.removePadding(context: context, removeTop: true, child:
            ListView.builder(
               itemCount: Stores.stopListViewStore.filteredBusStopDetailList.length ,
               itemBuilder: (BuildContext context, int index) {
                 var busStop = Stores.stopListViewStore.filteredBusStopDetailList[index];
                 return InkWell(child: Container( height: 80, color: index % 2 == 0? Colors.white : Colors.grey[100],alignment: Alignment.centerLeft, child:
                 Padding( padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:
                 Row(children:[ Expanded(child: Text(LocalizationUtil.localizedStringFrom(busStop, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref), style: TextStyle(fontWeight: FontWeight.w600), maxLines: 2,)), Icon(Icons.arrow_forward)])),
                 ), onTap: (){
                      Stores.routeListStore.setFilterStopIdentifier(busStop.identifier);
                      Navigator.pop(context);
                 },);
               }).build(context))))

        ])
      ) : _getProgressView(Stores.dataManager.allDataFetchCount)
    )),
    // floatingActionButton: FloatingActionButton(child: Icon(Icons.map), onPressed: (){
    //   Stores.googleMapStore.setSelectedBusStop(null);
    //   Stores.googleMapStore.setIsInbound(false);
    //   Stores.googleMapStore.setSelectedRoute(null);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => GoogleMapView()),
    //   );
    //
    // },)
      ));
  }

  Widget _getProgressView(int currentCount){
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),child: Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDataPreparationProgress, Stores.localizationStore.localizationPref)}", style: TextStyle(fontWeight: FontWeight.w600),)),
    Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),child:Container( height: 40, width: 250, color: Colors.grey, alignment: Alignment.centerLeft, child: Container(height: 40, width: 250 * currentCount / Stores.dataManager.totalDataCount, color: Colors.blue,),)),//Text("$currentCount/${(Stores.dataManager.totalDataCount)}"),
    Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),child:Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDataPreparationReminder, Stores.localizationStore.localizationPref)}", maxLines: 3,)),
      Expanded(child: Container())
    ],);
  }
}