import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/google_map_view.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/route_list_view.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'main.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';

class BusRouteDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BusRouteDetailPage(),
    );
  }
}

class BusRouteDetailPage extends StatefulWidget {
  BusRouteDetailPage({Key key}) : super(key: key);


  @override
  BusRouteDetailPageState createState() => BusRouteDetailPageState();
}

class BusRouteDetailPageState extends State<BusRouteDetailPage> {

  @override
  void initState() {
    super.initState();
    Stores.routeDetailStore.setSelectedStopId(null);
    Stores.routeDetailStore.setFilterKeyword("");

    CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound).then((value) => Stores.routeDetailStore.setDataFetchingError(!value));
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async{
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => RouteListView()),
        // );
        return false;
      },
        child: Scaffold(
        appBar: AppBar(
          title:  Observer(
        builder: (_) =>Text("${Stores.routeDetailStore.route.routeCode} (${Stores.localizationStore.localizedString( Stores.routeDetailStore.isInbound ?LocalizationUtil.localizationKeyForInbound : LocalizationUtil.localizationKeyForOutbound, Stores.localizationStore.localizationPref) })")),
        ),
        body: Observer(
            builder: (_) =>Center(child:
            Padding(padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child:(Stores.routeDetailStore.selectedRouteBusStops != null)?
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(flex:1,
                    child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child: TextField(
                      onChanged: (text){
                        Stores.routeDetailStore.setFilterKeyword(text);
                      },
                      decoration: InputDecoration(
                          hintText: Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForStopSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                      ),))
                ),

                Expanded(flex: 9,child:(Stores.routeDetailStore.displayedStops != null && Stores.routeDetailStore.displayedStops.length > 0?
                Padding(padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child:
                Scrollbar(child:ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                itemCount:  Stores.routeDetailStore.displayedStops.length ,
                itemBuilder: (BuildContext context, int index) {
                  return Observer(
                      builder: (_) =>InkWell(child:Container(
                    height: Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].identifier ? 130 : 100,
                    color: Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].identifier ? Colors.lightBlue[50] : Colors.grey[50],
                    child:Observer(
                      builder: (_) =>Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(padding: const EdgeInsets.fromLTRB(0 , 10, 0, 5),child:Text( "${Stores.localizationStore.localizedStringFrom(Stores.routeDetailStore.displayedStops[index], BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref)}" , style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),

                          Padding(padding: const EdgeInsets.fromLTRB(0 , 0, 0, 0),child:Container(height: 20,child:Text(
                              (Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.displayedStops[index].identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                              Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForBookmarked, Stores.localizationStore.localizationPref):"", style: TextStyle(fontSize: 15)))),
                          Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].identifier ? Container( height: 30,child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            InkWell(child:
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                    Stores.localizationStore.localizedString((Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.displayedStops[index].identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                                    LocalizationUtil.localizationKeyForUnbookmark : LocalizationUtil.localizationKeyForBookmark, Stores.localizationStore.localizationPref)
                                    ,
                                style:  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, decoration: TextDecoration.underline )), ), onTap: (){
                              var routeStop = RouteStop( Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.displayedStops[index].identifier, Stores.routeDetailStore.route.companyCode ,  Stores.routeDetailStore.isInbound);

                              if (Stores.dataManager.bookmarkedRouteStops == null || !Stores.dataManager.bookmarkedRouteStops.contains(
                                  routeStop)) {
                                Stores.dataManager.addRouteStopToBookmark(routeStop);
                              } else {
                                Stores.dataManager.removeRouteStopFromBookmark(
                                    routeStop);
                              }
                          },),
                          InkWell(child:
                            Container(
                                alignment: Alignment.center,
                                child: Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForLocation, Stores.localizationStore.localizationPref),  style:  TextStyle(fontSize: 20, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))),
                            onTap: (){
                              Stores.googleMapStore.setSelectedBusStop(Stores.dataManager.busStopDetailMap[Stores.routeDetailStore.selectedStopId]);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GoogleMapView()),
                              );
                            },
                            )
                          ],),):Container(height: 0,),
                          Container(height: 1, color: Colors.grey,)
                        ]))),
                  ),
                    onTap: (){
                        var stop = Stores.routeDetailStore.displayedStops[index];
                        if(stop.latitude != null && stop.longitude != null) {
                          Stores.routeDetailStore.setSelectedStopId(
                              stop.identifier);
                        }


                    },));
                }
                ).build(context)))
                    : Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForNoRouteDataFound, Stores.localizationStore.localizationPref), textAlign: TextAlign.center,))),
                 Observer( builder: (_) =>(Stores.routeDetailStore.dataFetchingError ) ?
                  InkWell(child:
                  Container( color: Colors.yellow, height: 50, alignment: Alignment.center, child:
                  Observer(
                      builder: (_) =>Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForFailedToLoadData, Stores.localizationStore.localizationPref), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),))),
                    onTap: (){
                      Stores.routeDetailStore.setDataFetchingError(false);
                      CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound).then((value) => Stores.routeDetailStore.setDataFetchingError(!value));
                    },)
                      : Container())
                ]):
            Observer(
                builder: (_) =>Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref)))
          ,))),
    ));
  }
}