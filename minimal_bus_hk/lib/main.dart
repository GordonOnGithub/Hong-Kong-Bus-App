import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:mobx/mobx.dart';
import 'utils/network_util.dart';
import 'route_list_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'utils/stores.dart';
import 'utils/Utils.dart';
import 'utils/cache_utils.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
import 'dart:async';
import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/setting_view.dart';
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

   Future<void> updateETAData(List<RouteStop> routeStops) async{
     if(routeStops == null)return;
     Stores.etaListStore.setIsLoading(true);
     if(_updateTimer != null){
       _updateTimer.cancel();
       _updateTimer = null;
       _callETAApi = false;
     }
    for(RouteStop s in routeStops){
      await CacheUtils.sharedInstance().getBusStopDetail(s.stopId);
    }
    await NetworkUtil.sharedInstance().getETAForRouteStops();
    Stores.etaListStore.setIsLoading(false);

    _updateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      Stores.etaListStore.updateTimeStampForChecking();
      if(_callETAApi) {
        NetworkUtil.sharedInstance().getETAForRouteStops();
      }
      _callETAApi = !_callETAApi;
    });
   }

  @override
  void initState() {
    super.initState();
    Stores.etaListStore.setSelectedETAListIndex(null);

    _bookmarkReaction = autorun( (_) => updateETAData(Stores.dataManager.bookmarkedRouteStops));

    CacheUtils.sharedInstance().getBookmarkedRouteStop();
    CacheUtils.sharedInstance().getRoutes();
    Stores.localizationStore.loadDataFromAsset();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
        builder: (_) =>Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForETAListView, Stores.localizationStore.localizationPref))),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingView()),
          );
        },)],
      ),
      body: Center(

        child: Observer(
      builder: (_) =>(  Stores.dataManager.routes != null &&  Stores.dataManager.bookmarkedRouteStops != null && !Stores.etaListStore.isLoading )?
        Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:   (
                     Stores.dataManager.bookmarkedRouteStops.length > 0 ? ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: Stores.etaListStore.displayedETAs.length ,
                    itemBuilder: (BuildContext context, int index) {
                      ETA eta = Stores.etaListStore.displayedETAs[index];
                      return Observer(
                          builder: (_) =>Container(
                        height: (Stores.etaListStore.selectedETAListIndex == index) ? 220 : 190,
                        color:  (Stores.etaListStore.selectedETAListIndex == index) ? Colors.lightBlue[50] : Colors.grey[50],
                        child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(flex: 14, child: InkWell(child:Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children:[
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child: Text(eta.routeCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                   Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text("${Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${Stores.dataManager.routesMap!= null && Stores.dataManager.routesMap.containsKey(eta.routeCode) ?(  Stores.localizationStore.localizedStringFrom(Stores.dataManager.routesMap[eta.routeCode], eta.isInBound ? BusRoute.localizationKeyForOrigin: BusRoute.localizationKeyForDestination, Stores.localizationStore.localizationPref) ):""}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),)),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text("${Stores.dataManager.busStopDetailMap!= null && Stores.dataManager.busStopDetailMap.containsKey(eta.stopId) ?  Stores.localizationStore.localizedStringFrom(Stores.dataManager.busStopDetailMap[eta.stopId],BusStopDetail.localizationKeyForName,Stores.localizationStore.localizationPref): "-"}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),)),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:
                                    Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Flexible(flex:3, child:Text("${Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForETA, Stores.localizationStore.localizationPref)}: ${ eta.toClockDescription(Stores.etaListStore.timeStampForChecking)}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black ), textAlign: TextAlign.left,), ),
                                      // Flexible(flex:4, child: Container()),
                                      Flexible(flex:3, child:Text("${ eta.getTimeLeftDescription(Stores.etaListStore.timeStampForChecking)}${Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForMinute, Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 15, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalImminentTimeMilliseconds && eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) > Stores.appConfig.arrivalExpiryTimeMilliseconds )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < Stores.appConfig.arrivalExpiryTimeMilliseconds? Colors.grey : Colors.black),  textAlign: TextAlign.right),  )
                                    ],), height: 20,)
                                ),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text(Stores.localizationStore.localizedStringFrom(eta, ETA.localizationKeyForRemark, Stores.localizationStore.localizationPref), style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),))
                              ])
                              ,onTap: (){
                                  Stores.etaListStore.setSelectedETAListIndex(index);
                             }
                      )),
                              (Stores.etaListStore.selectedETAListIndex == index) ?  Flexible(flex: 4, child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                InkWell(child:
                                Container(height: 30,

                                    child: Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForRemove, Stores.localizationStore.localizationPref), style:  TextStyle(fontSize: 15, fontWeight:  FontWeight.w500, decoration: TextDecoration.underline,
                                    ),)), onTap: (){
                                  Stores.dataManager.removeRouteStopFromBookmark(Stores.dataManager.bookmarkedRouteStops[index]);
                                  Stores.etaListStore.setSelectedETAListIndex(null);

                                },)

                              ],)) : Expanded(flex: 0, child:Container()),
                              Container(height: 1, color: Colors.grey,),
                            ]
                        ))
                          ),);
                    }
                ).build(context) : Text("No route stop bookmarked"))


        ):
      Observer(
          builder: (_) =>Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref))),
      )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RouteListView()),
          );
        },
        tooltip: 'Search',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
