import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
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
      home: BusRouteDetailPage(title: ''),
    );
  }
}

class BusRouteDetailPage extends StatefulWidget {
  BusRouteDetailPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  BusRouteDetailPageState createState() => BusRouteDetailPageState();
}

class BusRouteDetailPageState extends State<BusRouteDetailPage> {

  @override
  void initState() {
    super.initState();
    Stores.routeDetailStore.setSelectedBusStopIndex(null);
    CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Observer(
        builder: (_) =>Text("${Stores.routeDetailStore.route.routeCode} (${Stores.localizationStore.localizedString( Stores.routeDetailStore.isInbound ?LocalizationUtil.localizationKeyForInbound : LocalizationUtil.localizationKeyForOutbound, Stores.localizationStore.localizationPref) })")),
        ),
        body: Observer(
            builder: (_) =>Center(child: (Stores.routeDetailStore.selectedRouteBusStops != null)?
            ((Stores.routeDetailStore.selectedRouteBusStops.length > 0?
                ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                itemCount:  Stores.routeDetailStore.selectedRouteBusStops.length ,
                itemBuilder: (BuildContext context, int index) {
                  return Observer(
                      builder: (_) =>InkWell(child:Container(
                    height: Stores.routeDetailStore.selectedBusStopIndex == index ? 120 : 100,
                    color: Stores.routeDetailStore.selectedBusStopIndex == index ? Colors.lightBlue[50] : Colors.grey[50],
                    child:Observer(
                      builder: (_) =>Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(padding: const EdgeInsets.fromLTRB(0 , 10, 0, 5),child:Text( "${index + 1}. ${Stores.localizationStore.localizedStringFrom(Stores.routeDetailStore.selectedRouteBusStops[index], BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref)}" , style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                          (Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.selectedRouteBusStops[index].identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                          Padding(padding: const EdgeInsets.fromLTRB(0 , 0, 0, 0),child:Container(height: 20,child:Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForBookmarked, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 15)))) : Container(height: 30,),
                          index == Stores.routeDetailStore.selectedBusStopIndex? Container( height: 20,child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            InkWell(child:
                              Container( child:
                                Text(
                                    Stores.localizationStore.localizedString((Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.selectedRouteBusStops[index].identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                                    LocalizationUtil.localizationKeyForUnbookmark : LocalizationUtil.localizationKeyForBookmark, Stores.localizationStore.localizationPref)
                                    ,
                                style:  TextStyle(fontSize: 15, fontWeight: FontWeight.w500, decoration: TextDecoration.underline )), ), onTap: (){
                              var routeStop = RouteStop( Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.selectedRouteBusStops[index].identifier, Stores.routeDetailStore.route.companyCode ,  Stores.routeDetailStore.isInbound);

                              if (Stores.dataManager.bookmarkedRouteStops == null || !Stores.dataManager.bookmarkedRouteStops.contains(
                                  routeStop)) {
                                Stores.dataManager.addRouteStopToBookmark(routeStop);
                              } else {
                                Stores.dataManager.removeRouteStopFromBookmark(
                                    routeStop);
                              }
                          },),
                          InkWell(child:
                            Container( child:
                               Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForLocation, Stores.localizationStore.localizationPref),  style:  TextStyle(fontSize: 15, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline)))
                            )
                          ],),):Container(height: 0,),
                          Container(height: 1, color: Colors.grey,)
                        ]))),
                  ),
                    onTap: (){
                      Stores.routeDetailStore.setSelectedBusStopIndex(index);


                    },));
                }
            ).build(context) : Text("No route is found."))):
            Observer(
                builder: (_) =>Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref)))
          ,)),

    );
  }

}