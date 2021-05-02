import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/bus_route_detail_view.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:mobx/mobx.dart';
import 'google_map_view.dart';
import 'route_list_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'utils/stores.dart';
import 'package:connectivity/connectivity.dart';
import 'utils/cache_utils.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'dart:async';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/setting_view.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ETAListView());
}

class ETAListView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal HK Bus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _updateTimer;
  bool _callETAApi = false;
  ReactionDisposer _bookmarkReaction;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

   Future<void> updateETAData(List<RouteStop> routeStops) async{
     if(routeStops == null)return;
     if(_updateTimer != null){
       _updateTimer.cancel();
       _updateTimer = null;
       _callETAApi = false;
     }
    for(RouteStop s in routeStops){
      await CacheUtils.sharedInstance().getBusStopDetail(s.stopId);
    }
    await CacheUtils.sharedInstance().getETAForBookmarkedRouteStops();

    _updateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      Stores.etaListStore.updateTimeStampForChecking();
      if(_callETAApi) {
        CacheUtils.sharedInstance().getETAForBookmarkedRouteStops().then((value){
          if (!value){
            _callETAApi = true;
          }
        });
      }
      _callETAApi = !_callETAApi;
    });
   }

  @override
  void initState() {
    super.initState();
    Stores.localizationStore.checkLocalizationPref();
    Stores.etaListStore.setSelectedETAListIndex(null);

    _bookmarkReaction = autorun( (_) {
      if(Stores.connectivityStore.connected){
        updateETAData(Stores.dataManager.bookmarkedRouteStops);
      }
    });


    CacheUtils.sharedInstance().getBookmarkedRouteStop();
    Stores.localizationStore.loadDataFromAsset();

    _connectivity.checkConnectivity().then((result) {
       Stores.connectivityStore.setConnected(result != ConnectivityResult.none);
     });

    _connectivitySubscription =
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        Stores.connectivityStore.setConnected(result != ConnectivityResult.none);
    });

    Stores.appConfig.shouldDownloadAllData().then((value){
        if(value == null){
          CacheUtils.sharedInstance().getRoutes();
          showDialog(context: context, builder: (context) => _buildDownloadAllDataDialog(context));
        }else if(value){
          CacheUtils.sharedInstance().fetchAllData();
        } else{
          CacheUtils.sharedInstance().getRoutes();
        }
    });

    Stores.appConfig.checkShowSearchButtonReminder();
    Stores.appConfig.checkAppLaunchCount().then((_){
      Stores.appConfig.increaseAppLaunchCount().then((_){
        Stores.appConfig.setHideRatingDialogue(false);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_bookmarkReaction != null) {
      _bookmarkReaction();
    }
    if(_updateTimer != null) {
      _updateTimer.cancel();
      _updateTimer = null;
    }

    if(_connectivitySubscription != null){
      _connectivitySubscription.cancel();
      _connectivitySubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
        builder: (_) =>Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForETAListView, Stores.localizationStore.localizationPref))),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingView()),
          );
        },)],
      ),
      body: Center(

        child: Observer(
      builder: (_) => Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch , children:[
        (Stores.connectivityStore.connected?  ( Stores.appConfig.appLaunchCount == Stores.appConfig.launchCountToShowRatingMessage && !Stores.appConfig.hideRatingDialogue ?
        Container(height: 50,color: Colors.green,alignment: Alignment.centerLeft, child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded( child:
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0), child: InkWell(child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRateThisApp, Stores.localizationStore.localizationPref), textAlign: TextAlign.left, style: TextStyle(color: Colors.white),), onTap: (){
          String appStoreUrl = Stores.appConfig.appStoreUrl;
          canLaunch(appStoreUrl).then((result) {
            if (result) {
              launch(appStoreUrl);
            }
            Stores.appConfig.setHideRatingDialogue(true);
          });
        },))),  IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: (){
          Stores.appConfig.setHideRatingDialogue(true);
        }) ],),) :
        Container()) :
        Container(height: 50,color: Colors.yellow,alignment: Alignment.center, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForConnectivityWarning, Stores.localizationStore.localizationPref), style: TextStyle(fontWeight: FontWeight.w600),),)),
      Expanded( child: ((Stores.dataManager.bookmarkedRouteStops != null && ( Stores.dataManager.bookmarkedRouteStops.length == 0 || Stores.dataManager.routes != null)  )?
        Padding(padding: const EdgeInsets.all(0), child: (
                     Stores.dataManager.bookmarkedRouteStops.length > 0 ? Scrollbar( child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    itemCount: Stores.etaListStore.displayedETAs.length ,
                    itemBuilder: (BuildContext context, int index) {
                      ETA eta = Stores.etaListStore.displayedETAs[index];
                      return Observer(
                          builder: (_) =>Container(
                        height: (Stores.etaListStore.selectedETAListIndex == index) ? 230 : 190,
                        color:  (Stores.etaListStore.selectedETAListIndex == index) ? Colors.lightBlue[50] : ( index % 2 == 0? Colors.white : Colors.grey[100]),
                        child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Expanded(child: InkWell(child:Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children:[
                                   Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:
                                   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[
                                   Text(eta.routeCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                     Icon((Stores.etaListStore.selectedETAListIndex == index) ?Icons.keyboard_arrow_up_sharp :Icons.keyboard_arrow_down_sharp)
                                   ])
                                   ),

                                   Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child:Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${Stores.dataManager.routesMap!= null && Stores.dataManager.routesMap.containsKey(eta.routeCode) ?(  LocalizationUtil.localizedStringFrom(Stores.dataManager.routesMap[eta.routeCode], eta.isInbound ? BusRoute.localizationKeyForOrigin: BusRoute.localizationKeyForDestination, Stores.localizationStore.localizationPref) ):" - "}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),)),

                                   Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child:
                                   Row( mainAxisAlignment: MainAxisAlignment.start, children:[
                                     Icon(Icons.location_on_outlined),
                                   Expanded(child: Text("${Stores.dataManager.busStopDetailMap!= null && Stores.dataManager.busStopDetailMap.containsKey(eta.stopId) ?  LocalizationUtil.localizedStringFrom(Stores.dataManager.busStopDetailMap[eta.stopId],BusStopDetail.localizationKeyForName,Stores.localizationStore.localizationPref): " - "}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal), maxLines: 2,)),
                                    ]),),
                              Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child:
                                    Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                      Icon(Icons.access_time_outlined, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),
                                     Expanded(child:Text(" ${ eta.toClockDescription()}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black ), textAlign: TextAlign.left,)),
                                      Icon(Icons.timer, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),
                                      Text(" ${ eta.getTimeLeftDescription(Stores.etaListStore.timeStampForChecking)}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),  textAlign: TextAlign.right),
                                    ],), height: 20,)
                                ),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child:Text("${LocalizationUtil.localizedStringFrom(eta, ETA.localizationKeyForRemark, Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),))
                              ])
                              ,onTap: (){
                                  Stores.etaListStore.setSelectedETAListIndex(index);
                             }
                      )),
                              (Stores.etaListStore.selectedETAListIndex == index) ? Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 15) , child:
                              Container(height: 25, child:
                              Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment:  CrossAxisAlignment.end, children: [
                                InkWell(child:
                                Container(
                                    alignment: Alignment.center,
                                    child:   Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end ,children:[
                                      Icon(Icons.remove_circle_outline),
                                    Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRemove, Stores.localizationStore.localizationPref), style:  TextStyle(fontSize: 17, fontWeight:  FontWeight.w500, decoration: TextDecoration.underline,
                                    ),)])
                              ), onTap: (){
                                  _onRemoveBookmark(index);
                                },),
                                InkWell(child:
                                Container(
                                    alignment: Alignment.center,
                                    child:
                                    Row(mainAxisAlignment: MainAxisAlignment.start , crossAxisAlignment: CrossAxisAlignment.end,children:[
                                      Icon(Icons.info_outline),
                                      Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteDetail, Stores.localizationStore.localizationPref), style:  TextStyle(fontSize: 17, fontWeight:  FontWeight.w500, decoration: TextDecoration.underline,
                                      ),)])
                                ), onTap: (){
                                  _onRouteInfoButtonClicked(eta);
                                },),

                                InkWell(child:
                                Container(
                                    alignment: Alignment.center,
                                    child:
                                    Row(mainAxisAlignment: MainAxisAlignment.start , crossAxisAlignment: CrossAxisAlignment.end,children:[
                                      Icon(Icons.location_on_outlined),
                                    Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLocation, Stores.localizationStore.localizationPref), style:  TextStyle(fontSize: 17, fontWeight:  FontWeight.w500, decoration: TextDecoration.underline,
                                    ),)])
                                ), onTap: (){
                                    _onOpenMapView(eta);
                                },)

                              ],))) :Container(),
                              // Container(height: 1, color: Colors.grey,),
                            ]
                        ))
                          ),);
                    }
                ).build(context)) : Observer(
                         builder: (_) => Padding(padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child: Container(alignment: Alignment.center, child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForEmptyETAList, Stores.localizationStore.localizationPref), textAlign: TextAlign.center,)))))


        ):
        Observer(
            builder: (_) =>Container(alignment: Alignment.center,child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref), textAlign: TextAlign.center)))),
      ),
          Stores.appConfig.showSearchButtonReminder ? Container(height: 80,color: Colors.yellow,alignment: Alignment.center, child:
          Row(children:[
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20) ,child:Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForSearchButtonReminder, Stores.localizationStore.localizationPref),textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600)))),
            Container(width: 180)
          ])
          )
          :Container()
      ]),
      )),
      floatingActionButton: Observer(
    builder: (_) =>FloatingActionButton.extended(
        onPressed: (){
          Stores.appConfig.setShowSearchButtonReminder(false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RouteListView()),
          );
        },
        tooltip: 'Search',
        icon: Icon(Icons.search),
        label: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearch, Stores.localizationStore.localizationPref)),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onRemoveBookmark(int index){
    Stores.dataManager.removeRouteStopFromBookmark(Stores.dataManager.bookmarkedRouteStops[index]);
    Stores.etaListStore.setSelectedETAListIndex(null);
  }

  void _onOpenMapView(ETA eta){
    if(Stores.dataManager.routesMap.containsKey(eta.routeCode) && Stores.dataManager.busStopDetailMap.containsKey(eta.stopId)) {
      Stores.googleMapStore.setSelectedBusStop(
          Stores.dataManager.busStopDetailMap[eta.stopId]);
      Stores.googleMapStore.setIsInbound(
          eta.isInbound);
      Stores.googleMapStore.setSelectedRoute(
          Stores.dataManager.routesMap[eta
              .routeCode]);
      CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.dataManager.routesMap[eta
          .routeCode], eta.isInbound);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            GoogleMapView()),
      );
    }
  }

  void _onRouteInfoButtonClicked(ETA eta){

     if(Stores.dataManager.routesMap.containsKey(eta.routeCode)) {
       Stores.routeDetailStore.route = Stores.dataManager.routesMap[eta.routeCode];
       Stores.routeDetailStore.isInbound = eta.isInbound;
       Stores.routeDetailStore.setSelectedStopId(eta.stopId);
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => BusRouteDetailView()),
       );
     }
  }

  Widget _buildDownloadAllDataDialog(BuildContext context) {
     return WillPopScope(child: AlertDialog(title: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDownloadAllDataPopupTitle, Stores.localizationStore.localizationPref)),
       content: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDownloadAllDataPopupContent, Stores.localizationStore.localizationPref)),
     actions: [
       FlatButton(onPressed: (){
         CacheUtils.sharedInstance().fetchAllData();
         Stores.appConfig.setShouldDownloadAllData(true);
         Navigator.of(context).pop();
       }, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDownloadAllDataPopupYes, Stores.localizationStore.localizationPref))),
       FlatButton(onPressed: (){
         Stores.appConfig.setShouldDownloadAllData(false);
         Navigator.of(context).pop();
       }, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForDownloadAllDataPopupNo, Stores.localizationStore.localizationPref))),
     ],), onWillPop: () async => false ,);
  }

}
