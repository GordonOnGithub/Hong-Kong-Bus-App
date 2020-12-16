import 'package:flutter/material.dart';
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
        title: Text("Estimated Time of Arrival (ETA)"),
      ),
      body: Center(

        child: Observer(
      builder: (_) =>(  Stores.dataManager.routes != null &&  Stores.dataManager.bookmarkedRouteStops != null && !Stores.etaListStore.isLoading )?
        Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Expanded(flex: 9,
                 child:  (
                     Stores.dataManager.bookmarkedRouteStops.length > 0 ? ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: Stores.etaListStore.displayedETAs.length ,
                    itemBuilder: (BuildContext context, int index) {
                      ETA eta = Stores.etaListStore.displayedETAs[index];
                      bool isSelected = (Stores.etaListStore.selectedETAListIndex != null && Stores.etaListStore.selectedETAListIndex == index);
                      return Observer(
                          builder: (_) =>Container(
                        height: (Stores.etaListStore.selectedETAListIndex != null && Stores.etaListStore.selectedETAListIndex == index) ? 180 : 140,
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Flexible(flex: 14, child: InkWell(child:Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children:[

                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child: Text(eta.routeCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text("${Stores.dataManager.busStopDetailMap!= null && Stores.dataManager.busStopDetailMap.containsKey(eta.stopId) ?Stores.dataManager.busStopDetailMap[eta.stopId].localizedName() : "-"}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),)),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text("ETA: ${ eta.toTimeDescription(Stores.etaListStore.timeStampForChecking)}", style: TextStyle(fontSize: 14, fontWeight:(eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < 60000 && eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) > -30000 )? FontWeight.bold : FontWeight.normal, color: eta.getRemainTimeInMilliseconds(Stores.etaListStore.timeStampForChecking) < -30000? Colors.grey : Colors.black ),  )),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text( eta.localizedRemark().length > 0? eta.localizedRemark():"", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),))
                              ])
                              ,onTap: (){
                                  Stores.etaListStore.setSelectedETAListIndex(index);
                             }
                      )),
                              (Stores.etaListStore.selectedETAListIndex != null && Stores.etaListStore.selectedETAListIndex == index) ?  Flexible(flex: 4, child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                InkWell(child:   Container( child: Text("Remove bookmark", style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold ),)), onTap: (){
                                  Stores.dataManager.removeRouteStopFromBookmark(Stores.dataManager.bookmarkedRouteStops[index]);
                                  Stores.etaListStore.setSelectedETAListIndex(null);

                                },)

                              ],)) : Expanded(flex: 0, child:Container())
                            ]
                        )
                          ),);
                    }
                ).build(context) : Text("No route stop bookmarked")) )
          ],
        )
        ):
        Text("Loading..."),
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
