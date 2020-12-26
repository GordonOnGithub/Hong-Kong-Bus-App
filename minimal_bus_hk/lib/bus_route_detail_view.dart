import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/google_map_view.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/route_list_view.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'model/bus_route.dart';
import 'model/eta.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'main.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';

class BusRouteDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BusRouteDetailPage();
  }
}

class BusRouteDetailPage extends StatefulWidget {
  BusRouteDetailPage({Key key}) : super(key: key);


  @override
  BusRouteDetailPageState createState() => BusRouteDetailPageState();
}

class BusRouteDetailPageState extends State<BusRouteDetailPage> {
  Timer _updateTimer;
  bool _callETAApi = false;

  @override
  void initState() {
    super.initState();
    Stores.routeDetailStore.setSelectedStopId(null);
    Stores.routeDetailStore.setSelectedIndex(null);
    Stores.routeDetailStore.setFilterKeyword("");

    CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound).then((value) {
      Stores.routeDetailStore.setDataFetchingError(!value);
      if(value) {
        CacheUtils.sharedInstance().getETAForRoute(
            Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound);
      }
    });

    _updateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      Stores.routeDetailStore.updateTimeStampForChecking();
      if(_callETAApi) {
        CacheUtils.sharedInstance().getETAForRoute(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound);
      }
      _callETAApi = !_callETAApi;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_updateTimer != null) {
      _updateTimer.cancel();
      _updateTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title:  Observer(
        builder: (_) =>Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRoute, Stores.localizationStore.localizationPref)} ${Stores.routeDetailStore.route.routeCode}, ${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${LocalizationUtil.localizedStringFrom(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound ? BusRoute.localizationKeyForOrigin : BusRoute.localizationKeyForDestination, Stores.localizationStore.localizationPref) }")),
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
                          hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForStopSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                      ),))
                ),

                Expanded(flex: 9,child:(Stores.routeDetailStore.displayedStops != null && Stores.routeDetailStore.displayedStops.length > 0?
                Padding(padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child:
                Scrollbar(child: Observer(
                    builder: (_) =>ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                itemCount:  Stores.routeDetailStore.displayedStops.length ,
                itemBuilder: (BuildContext context, int index) {
                  ETA eta = Stores.routeDetailStore.displayedStops[index].eta;

                  return Observer(
                      builder: (_) =>InkWell(child:Container(
                    height:( Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier && Stores.routeDetailStore.selectedIndex == index)? 120 : 90,
                    color: ( Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier && Stores.routeDetailStore.selectedIndex == index)? Colors.lightBlue[50] : Colors.grey[50],
                    child:Observer(
                      builder: (_) =>Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                      Padding(padding: const EdgeInsets.fromLTRB(0 , 10, 0, 0),child:
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween ,children:[
                          Icon((Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                       Icons.bookmark:Icons.bookmark_border),

                        Expanded(child: Text( "${LocalizationUtil.localizedStringFrom(Stores.routeDetailStore.displayedStops[index].busStopDetail, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref)}" , style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),

                        Icon(( Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier && Stores.routeDetailStore.selectedIndex == index)? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      ])),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:

                          Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end ,  children: [
                            Icon(Icons.access_time, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black,),
                          Expanded(child:Text(" ${ eta.toClockDescription(Stores.routeDetailStore.timeStampForChecking)}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black ), textAlign: TextAlign.left,), ),
                            Icon(Icons.timer, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),
                            Text(" ${ eta.getTimeLeftDescription(Stores.routeDetailStore.timeStampForChecking)}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),  textAlign: TextAlign.right),
                          ],), height: 20,)
                          ),


                          ( Stores.routeDetailStore.selectedStopId == Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier && Stores.routeDetailStore.selectedIndex == index) ? Container( height: 30,child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                            InkWell(child:
                              Container(
                                alignment: Alignment.center,
                                child:(Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                                  Row( mainAxisAlignment: MainAxisAlignment.start,children: [Icon(Icons.remove_circle_outline), Text( LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForUnbookmark,Stores.localizationStore.localizationPref ), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))],):
                                 Row(mainAxisAlignment: MainAxisAlignment.start,children: [Icon(Icons.add_circle_outline), Text( LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForBookmark,Stores.localizationStore.localizationPref ), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))],)
                                 ) , onTap: (){
                              var routeStop = RouteStop( Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier, Stores.routeDetailStore.route.companyCode ,  Stores.routeDetailStore.isInbound);

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
                                child:  Row( mainAxisAlignment: MainAxisAlignment.start,children: [
                                  Icon(Icons.location_on_outlined,),
                                Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLocation, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline)),
                            ])),
                            onTap: (){
                              _onOpenMapView(Stores.dataManager.busStopDetailMap[Stores.routeDetailStore.selectedStopId]);
                            },
                            )
                          ],),):Container(height: 0,),
                          Container(height: 1, color: Colors.grey,)
                        ]))),
                  ),
                    onTap: (){
                      _onSelectedRouteStop(index);
                    },));
                }
                ).build(context))))
                    : Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForNoRouteDataFound, Stores.localizationStore.localizationPref), textAlign: TextAlign.center,))),
                 Observer( builder: (_) =>(Stores.routeDetailStore.dataFetchingError ) ?
                  InkWell(child:
                  Container( color: Colors.yellow, height: 50, alignment: Alignment.center, child:
                  Observer(
                      builder: (_) =>Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForFailedToLoadData, Stores.localizationStore.localizationPref), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),))),
                    onTap: (){
                      Stores.routeDetailStore.setDataFetchingError(false);
                      CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound).then((value) => Stores.routeDetailStore.setDataFetchingError(!value));
                    },)
                      : Container())
                ]):
            Observer(
                builder: (_) =>Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref)))
          ,))),
          floatingActionButton:  Observer(
    builder: (_) =>(Stores.routeDetailStore.selectedRouteBusStops != null?FloatingActionButton(
            child: Icon(Icons.map),
            onPressed: (){
              _onOpenMapView(null);
            },):Container()),)

        );
  }

  void _onOpenMapView(BusStopDetail busStopDetail){
    Stores.googleMapStore.setSelectedBusStop(busStopDetail);
    Stores.googleMapStore.setIsInbound(Stores.routeDetailStore.isInbound);
    Stores.googleMapStore.setSelectedRoute(Stores.routeDetailStore.route);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoogleMapView()),
    );
  }

  void _onSelectedRouteStop(int index){
    var stop = Stores.routeDetailStore.displayedStops[index];
    if(stop.busStopDetail.latitude != null && stop.busStopDetail.longitude != null) {
      Stores.routeDetailStore.setSelectedStopId(
          stop.busStopDetail.identifier);
      Stores.routeDetailStore.setSelectedIndex(index);
    }
  }
}