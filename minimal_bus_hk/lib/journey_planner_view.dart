import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/stores/journey_planner_store.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:mobx/mobx.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class JourneyPlannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JourneyPlannerViewPage();
  }
}

class JourneyPlannerViewPage extends StatefulWidget {
  JourneyPlannerViewPage({Key key}) : super(key: key);

  @override
  _JourneyPlannerViewPageState createState() => _JourneyPlannerViewPageState();
}

class _JourneyPlannerViewPageState extends State<JourneyPlannerViewPage> {
  TextEditingController _originSearchFieldController;
  TextEditingController _destinationSearchFieldController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _originSearchFieldController = TextEditingController();
    _destinationSearchFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForJourneyPlanner, Stores.localizationStore.localizationPref)),
        ),
        body: Observer(
        builder: (_) =>Center(child:Stores.dataManager.allDataFetchCount >= Stores.dataManager.totalDataCount?
        Padding( padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20) , child:
        Column(mainAxisAlignment: MainAxisAlignment.center , children: [
              InkWell(child: Container(height:50,color:  Stores.journeyPlannerStore.selectionMode == StopSelectionMode.origin? Colors.blue[50] : Colors.grey[50], child:Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.trip_origin),
                Text(Stores.journeyPlannerStore.originBusStop != null? LocalizationUtil.localizedStringFrom( Stores.journeyPlannerStore.originBusStop, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref) : "select origin",
                style: TextStyle(color:Stores.journeyPlannerStore.originBusStop != null? Colors.black : Colors.grey, fontSize: 17,),),
              ],)),
                onTap: (){
                    Stores.journeyPlannerStore.setSelectionMode(Stores.journeyPlannerStore.selectionMode != StopSelectionMode.origin ? StopSelectionMode.origin : StopSelectionMode.none);
              },),
          Container(height: 1, color: Colors.grey,),
              Stores.journeyPlannerStore.selectionMode == StopSelectionMode.origin?
              Container(height:50, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children:[
                Icon(Icons.search),
                Expanded(child: TextField(
                  controller: _originSearchFieldController,
                  onChanged: (text){
                    Stores.journeyPlannerStore.setFilterKeywords(text);
                  },
                  // decoration: InputDecoration(
                  //     hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                  // ),
                ),
                ),
                Stores.journeyPlannerStore.filterKeywords.length > 0?
                IconButton(icon: Icon(Icons.cancel_outlined), onPressed: (){
                  _originSearchFieldController.text = "";
                  Stores.journeyPlannerStore.setFilterKeywords("");
                },):Container()
              ])):Container(),
            Stores.journeyPlannerStore.selectionMode == StopSelectionMode.origin? Expanded(child:
              Scrollbar( child:
              ListView.builder(
                  itemCount: Stores.journeyPlannerStore.filteredBusStopDetailList.length ,
                  itemBuilder: (BuildContext context, int index) {
                    var busStop = Stores.journeyPlannerStore.filteredBusStopDetailList[index];
                    return InkWell(child: Container( height: 50, color: index % 2 == 0? Colors.white : Colors.grey[100],alignment: Alignment.centerLeft, child:
                    Padding( padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:
                    Row(children:[ Expanded(child: Text(LocalizationUtil.localizedStringFrom(busStop, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref), maxLines: 2,))])),
                    ), onTap: (){
                        Stores.journeyPlannerStore.setOriginStopId(busStop.identifier);
                        Stores.journeyPlannerStore.selectionMode = StopSelectionMode.none;
                        _originSearchFieldController.text = "";
                    },);
                  }).build(context))
                ): Container()
                 ,
           InkWell(child: Container(height:50, color:Stores.journeyPlannerStore.selectionMode == StopSelectionMode.destination? Colors.blue[50]:Colors.grey[50] , child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.flag),
                Text(Stores.journeyPlannerStore.destinationBusStop != null? LocalizationUtil.localizedStringFrom(  Stores.journeyPlannerStore.destinationBusStop, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref) : "select destination",
                    style: TextStyle(color:Stores.journeyPlannerStore.destinationBusStop != null? Colors.black : Colors.grey, fontSize: 17 )),
              ],)),
                onTap: (){
                  Stores.journeyPlannerStore.setSelectionMode(Stores.journeyPlannerStore.selectionMode != StopSelectionMode.destination ? StopSelectionMode.destination : StopSelectionMode.none);
                },),
          Container(height: 1, color: Colors.grey,),
          Stores.journeyPlannerStore.selectionMode == StopSelectionMode.destination?
              Container(height:50 ,child: Row( crossAxisAlignment: CrossAxisAlignment.center, children:[
                Icon(Icons.search),
                Expanded(child: TextField(
                  controller: _destinationSearchFieldController,
                  onChanged: (text){
                    Stores.journeyPlannerStore.setFilterKeywords(text);
                  },
                  // decoration: InputDecoration(
                  //     hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                  // ),
                ),
                ),
                Stores.journeyPlannerStore.filterKeywords.length > 0?
                IconButton(icon: Icon(Icons.cancel_outlined), onPressed: (){
                  _destinationSearchFieldController.text = "";
                  Stores.journeyPlannerStore.setFilterKeywords("");
                },) : Container()
              ])) : Container(),
              Stores.journeyPlannerStore.selectionMode == StopSelectionMode.destination?
              Expanded(child:
              Scrollbar( child:
              ListView.builder(

                  itemCount: Stores.journeyPlannerStore.filteredBusStopDetailList.length ,
                  itemBuilder: (BuildContext context, int index) {
                    var busStop = Stores.journeyPlannerStore.filteredBusStopDetailList[index];
                    return InkWell(child: Container( height: 50, color: index % 2 == 0? Colors.white : Colors.grey[100], alignment: Alignment.centerLeft, child:
                    Padding( padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:
                    Row(children:[ Expanded(child:Text(LocalizationUtil.localizedStringFrom(busStop, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref), maxLines: 2,))])),
                    ), onTap: (){
                        Stores.journeyPlannerStore.setDestinationStopId(busStop.identifier);
                        Stores.journeyPlannerStore.selectionMode = StopSelectionMode.none;
                        _destinationSearchFieldController.text = "";
                    },);
                  }).build(context))
                      ) :  Stores.journeyPlannerStore.selectionMode == StopSelectionMode.none? Expanded(child: Container(),) : Container()
              ,
              Container(height: 120,)
            ],))
            : _getProgressView(Stores.dataManager.allDataFetchCount),)),
      floatingActionButton: Stores.journeyPlannerStore.originStopId != null && Stores.journeyPlannerStore.destinationStopId != null ?
      FloatingActionButton.extended(icon: Icon(Icons.search), label:  Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearch, Stores.localizationStore.localizationPref)), onPressed: (){

    },):Container(),
    );
  }

  Widget _getProgressView(int currentCount){
    return Column(children: [
      Text("Route Data Download Progress:"),
      Text("$currentCount/${(Stores.dataManager.totalDataCount)}"),
      Text("This could take several minutes for the first time.")
    ],);

  }
}