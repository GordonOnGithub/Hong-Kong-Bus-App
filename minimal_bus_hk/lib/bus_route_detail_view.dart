import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/model/route_stop.dart';
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
    CacheUtils.sharedInstance().getRouteAndStopsDetail(Stores.routeDetailStore.route, Stores.routeDetailStore.isInbound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Observer(
        builder: (_) =>Text("${Stores.routeDetailStore.route.routeCode} (${Stores.routeDetailStore.isInbound ? "Inbound":"Outbound"})")),
        ),
        body: Observer(
            builder: (_) =>Center(child: (Stores.routeDetailStore.selectedRouteBusStops != null)?
            ((Stores.routeDetailStore.selectedRouteBusStops.length > 0?
                ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                itemCount:  Stores.routeDetailStore.selectedRouteBusStops.length ,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(child:Container(
                    height: 80,
                    child:Observer(
                      builder: (_) =>Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text( "${index + 1}. ${Stores.routeDetailStore.selectedRouteBusStops[index].localizedName()}" , style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                          (Stores.dataManager.bookmarkedRouteStops != null && Stores.dataManager.bookmarkedRouteStops.contains(RouteStop(  Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.selectedRouteBusStops[index].identifier,  Stores.routeDetailStore.route.companyCode, Stores.routeDetailStore.isInbound)))?
                          Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text("bookmarked", style: TextStyle(fontSize: 15))) : Text("")

                        ])),
                  ),
                    onTap: (){
                    var routeStop = RouteStop( Stores.routeDetailStore.route.routeCode,  Stores.routeDetailStore.selectedRouteBusStops[index].identifier, Stores.routeDetailStore.route.companyCode ,  Stores.routeDetailStore.isInbound);

                      if (Stores.dataManager.bookmarkedRouteStops == null || !Stores.dataManager.bookmarkedRouteStops.contains(
                          routeStop)) {
                        Stores.dataManager.addRouteStopToBookmark(routeStop);
                      } else {
                        Stores.dataManager.removeRouteStopFromBookmark(
                            routeStop);
                      }

                    },);
                }
            ).build(context) : Text("No route is found."))):
              Text("loading...")
          ,)),

    );
  }

}