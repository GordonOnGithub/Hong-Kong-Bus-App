import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/google_map_view.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/eta_query.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'model/bus_route.dart';
import 'model/bus_stop.dart';
import 'model/eta.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';

class BusRouteDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BusRouteDetailPage();
  }
}

class BusRouteDetailPage extends StatefulWidget {
  BusRouteDetailPage({Key? key}) : super(key: key);


  @override
  BusRouteDetailPageState createState() => BusRouteDetailPageState();
}

class BusRouteDetailPageState extends State<BusRouteDetailPage> {
  Timer? _updateTimer;
  TextEditingController? _searchFieldController;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Stores.appConfig.checkShowRouteDetailReminder();
    // Stores.routeDetailStore.setSelectedStopId(null);
    Stores.routeDetailStore.setSelectedSequence(null);
    Stores.routeDetailStore.setFilterKeyword("");
    _searchFieldController =
        TextEditingController(text: Stores.routeDetailStore.filterKeyword);

    CacheUtils.sharedInstance().getRouteAndStopsDetail(
        Stores.routeDetailStore.route!, Stores.routeDetailStore.isInbound,
        silentUpdate: true).then((value) {
      Stores.routeDetailStore.setDataFetchingError(!value);
      if (value) {
        //   CacheUtils.sharedInstance().getETAForRoute(
        //       Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound);
        updateSelectedBusStopETA();
      }
    });

    _updateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      Stores.routeDetailStore.updateTimeStampForChecking();
      updateSelectedBusStopETA();
    });
    // if (Stores.routeDetailStore.selectedStopId != null) {
    //   final dispose = when((_) =>
    //   Stores.routeDetailStore.displayedStops != null &&
    //       Stores.routeDetailStore.displayedStops.length > 0 &&
    //       _controller.hasClients, () {
    //       for (var stop in Stores.routeDetailStore.displayedStops) {
    //         if (stop.busStopDetail.identifier ==
    //             Stores.routeDetailStore.selectedStopId) {
    //           _controller.animateTo(
    //               80.0 * (Stores.routeDetailStore.displayedStops.indexOf(stop)),
    //               duration: Duration(seconds: 1), curve: Curves.easeOut);
    //           break;
    //         }
    //
    //     }
    //   });
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_updateTimer != null) {
      _updateTimer!.cancel();
      _updateTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title:  Observer(
        builder: (_) =>Text("${LocalizationUtil.localizedString(Stores.routeDetailStore.route!.companyCode, Stores.localizationStore.localizationPref)} ${Stores.routeDetailStore.route!.routeCode}, ${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${LocalizationUtil.localizedStringFrom(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound ? BusRoute.localizationKeyForOrigin : BusRoute.localizationKeyForDestination, Stores.localizationStore.localizationPref) }", maxLines: 2,)),
        ),
        body: Observer(
            builder: (_) =>Center(child:
            Padding(padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child:(Stores.routeDetailStore.selectedRouteBusStops != null)?
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(flex:1,
                    child: Container(color: Colors.grey[50], child:
                    Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:
                    Row( crossAxisAlignment: CrossAxisAlignment.center, children:[
                      Icon(Icons.search),
                      Expanded(child: TextField(
                        controller: _searchFieldController,
                        onChanged: (text){
                        Stores.routeDetailStore.setFilterKeyword(text);
                      },
                      decoration: InputDecoration(
                          hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForStopSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                      ),)),
                      Stores.routeDetailStore.filterKeyword.length > 0?
                      IconButton(icon: Icon(Icons.cancel_outlined), onPressed: (){
                        _searchFieldController?.text = "";
                        Stores.routeDetailStore.setFilterKeyword("");
                      },):Container()
                    ]
                    )
                    ))
                ),
                Container(height: 1, color: Colors.grey,),
                Expanded(flex: 9,child:( Stores.routeDetailStore.displayedStops.length > 0?
                Padding(padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child:
                Scrollbar(
                    child: Observer(
                    builder: (_) =>ListView.builder(
                        controller: _controller,

                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                itemCount:  Stores.routeDetailStore.displayedStops.length ,
                itemBuilder: (BuildContext context, int index) {
                  ETA eta = Stores.routeDetailStore.displayedStops[index].eta;

                  return Observer(
                      builder: (_) =>InkWell(child:Container(
                    height:( Stores.routeDetailStore.selectedSequence == Stores.routeDetailStore.displayedStops[index].sequence )? 140 : 80,
                    color: ( Stores.routeDetailStore.selectedSequence == Stores.routeDetailStore.displayedStops[index].sequence )? Colors.lightBlue[50] : ( index % 2 == 0? Colors.white : Colors.grey[100]),
                    child:Observer(
                      builder: (_) =>Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                      Padding(padding: const EdgeInsets.fromLTRB(0 , 25, 0, 0),child:
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween , crossAxisAlignment: CrossAxisAlignment.center,children:[
                          Icon((Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops!.contains(RouteStop(  Stores.routeDetailStore.route!.routeCode,  Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier,  Stores.routeDetailStore.route!.companyCode, Stores.routeDetailStore.isInbound, Stores.routeDetailStore.route!.serviceType)))?
                       Icons.bookmark:Icons.bookmark_border),

                        Expanded(child: Text( "${LocalizationUtil.localizedStringFrom(Stores.routeDetailStore.displayedStops[index].busStopDetail, BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref)}" , style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600), textAlign: TextAlign.left,)),

                        Icon(( Stores.routeDetailStore.selectedSequence == Stores.routeDetailStore.displayedStops[index].sequence)? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      ])),
                          ( Stores.routeDetailStore.selectedSequence == Stores.routeDetailStore.displayedStops[index].sequence) ?
                          Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:
                          Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end ,  children: [
                            Icon(Icons.access_time, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black,),
                          Expanded(child:Text(" ${ eta.toClockDescription()}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black ), textAlign: TextAlign.left,), ),
                            Icon(Icons.timer, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),
                            Text(" ${ eta.getTimeLeftDescription(Stores.routeDetailStore.timeStampForChecking)}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.routeDetailStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),  textAlign: TextAlign.right),
                          ],), height: 20,)
                          ) : Container(),

                          ( Stores.routeDetailStore.selectedSequence == Stores.routeDetailStore.displayedStops[index].sequence) ? Container( height: 30,child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center, children: [
                            InkWell(child:
                              Container(
                                alignment: Alignment.center,
                                child:(Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops!.contains(RouteStop(  Stores.routeDetailStore.route!.routeCode,  Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier,  Stores.routeDetailStore.route!.companyCode, Stores.routeDetailStore.isInbound, Stores.routeDetailStore.route!.serviceType)))?
                                  Row( mainAxisAlignment: MainAxisAlignment.start,children: [Icon(Icons.remove_circle_outline), Text( LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForUnbookmark,Stores.localizationStore.localizationPref ), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))],):
                                 Row(mainAxisAlignment: MainAxisAlignment.start,children: [Icon(Icons.add_circle_outline), Text( LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForBookmark,Stores.localizationStore.localizationPref ), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline))],)
                                 ) , onTap: (){
                              var routeStop = RouteStop( Stores.routeDetailStore.route!.routeCode,  Stores.routeDetailStore.displayedStops[index].busStopDetail.identifier, Stores.routeDetailStore.route!.companyCode ,  Stores.routeDetailStore.isInbound, Stores.routeDetailStore.route!.serviceType);

                              if (Stores.dataManager.bookmarkedRouteStops == null || !Stores.dataManager.bookmarkedRouteStops!.contains(
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
                                Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLocation, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500 , decoration: TextDecoration.underline)),
                            ])),
                            onTap: (){
                              _onOpenMapView(Stores.dataManager.busStopDetailMap![Stores.routeDetailStore.selectedStopId]);
                            },
                            )
                          ],),):Container(height: 0,),
                          // Container(height: 1, color: Colors.grey,)
                        ]))),
                  ),
                    onTap: (){
                      _onSelectedRouteStop(index);
                    },));
                }
                ).build(context))))
                    : Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20) ,child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForNoRouteDataFound, Stores.localizationStore.localizationPref), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)))),
                 Observer( builder: (_) =>(Stores.routeDetailStore.dataFetchingError ) ?
                  InkWell(child:
                  Container( color: Colors.yellow, height: 80, alignment: Alignment.center, child:
                  Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20) ,child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForFailedToLoadData, Stores.localizationStore.localizationPref), textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),))),
                    onTap: (){
                      Stores.routeDetailStore.setDataFetchingError(false);
                      CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route!, Stores.routeDetailStore.isInbound, silentUpdate: true).then((value) => Stores.routeDetailStore.setDataFetchingError(!value));
                    },)
                      : ( Stores.appConfig.showRouteDetailReminder?
                     InkWell(child:
                   Container( color: Colors.yellow, height: 80, alignment: Alignment.centerLeft, child:
                   Row(children:[
                   Expanded(child:  Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20) ,child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteDetailReminder, Stores.localizationStore.localizationPref), textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),))),
                    Container(width:120)
                   ])),onTap: (){
                      Stores.appConfig.setShowRouteDetailReminder(false);
                    },)

                     :Container()))
                ]):
            Observer(
                builder: (_) =>Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref), style: TextStyle(fontWeight: FontWeight.bold),))
          ,))),
          floatingActionButton:  Observer(
    builder: (_) =>(Stores.routeDetailStore.selectedRouteBusStops != null && !Stores.routeDetailStore.dataFetchingError?FloatingActionButton.extended(
            icon: Icon(Icons.map),
            label: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForMap, Stores.localizationStore.localizationPref), ),
            onPressed: (){
              _onOpenMapView(null);
            },):Container()),)

        );
  }

  void _onOpenMapView(BusStopDetail? busStopDetail){

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
    if(stop.busStopDetail.latitude != 0 && stop.busStopDetail.longitude != 0) {
      Stores.appConfig.setShowRouteDetailReminder(false);
      Stores.routeDetailStore.setSelectedStopId(
          stop.busStopDetail.identifier);
      if(Stores.routeDetailStore.selectedSequence != stop.sequence) {
        Stores.routeDetailStore.setSelectedSequence(stop.sequence);
        updateSelectedBusStopETA();

      }else{
        Stores.routeDetailStore.setSelectedSequence(null);
      }
    }
  }

  void updateSelectedBusStopETA(){
    var routeStopsMap = Stores.routeDetailStore.isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
    if(routeStopsMap != null){
      var busStopsList = routeStopsMap[Stores.routeDetailStore.route!.routeUniqueIdentifier];
      if(busStopsList != null){
        for(BusStop busStop in busStopsList) {
          if(busStop.sequence == Stores.routeDetailStore.lastSelectedSequence) {
            CacheUtils.sharedInstance().getETA(
                ETAQuery.fromBusStop(busStop));
            break;
          }
        }
      }
    }
  }
}