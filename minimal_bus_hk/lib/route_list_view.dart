import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/bus_route_detail_view.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:mobx/mobx.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
class RouteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RouteListViewPage(),
    );
  }
}

class RouteListViewPage extends StatefulWidget {
  RouteListViewPage({Key key}) : super(key: key);

  @override
  _RouteListViewPageState createState() => _RouteListViewPageState();
}

class _RouteListViewPageState extends State<RouteListViewPage> {
  TextEditingController _searchFieldController;

  @override
  void initState() {
    super.initState();
    Stores.routeListStore.setSelectedRoute(null);

    _searchFieldController = TextEditingController(text:"");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Stores.routeListStore.setFilterKeyword("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
        builder: (_) => Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForRouteListView, Stores.localizationStore.localizationPref))),
      ),
      body: Observer(
      builder: (_) => Center(

        child:  Stores.routeListStore.displayedRoutes != null ?(
            (Stores.dataManager.routes.length > 0 ) ?
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child:Column(
          children: [
            Expanded(flex:1,
                child:TextField(
                  controller: _searchFieldController,
                  onChanged: (text){
                  Stores.routeListStore.setFilterKeyword(text);
                },
                  decoration: InputDecoration(
                      hintText: Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                  ),)
            ),
            Expanded(flex: 9,
            child:
            ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount:   Stores.routeListStore.displayedRoutes.length ,
                itemBuilder: (BuildContext context, int index) {
                  BusRoute busRoute = Stores.routeListStore.displayedRoutes[index];
                  return Observer(
                      builder: (_) =>Container(
                        height: (busRoute == Stores.routeListStore.selectedRoute) ? 160 : 120,
                        color:  (busRoute == Stores.routeListStore.selectedRoute) ? Colors.lightBlue[50] : Colors.grey[50],
                        child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 12,
                              child:
                               InkWell(child:

                               Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children:[
                               Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child: Text( busRoute.routeCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),))),
                               Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0), child:Text("${Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyFrom, Stores.localizationStore.localizationPref)}: ${Stores.localizationStore.localizedStringFrom(busRoute, BusRoute.localizationKeyForOrigin,Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),))),
                               Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),child:Text("${Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${Stores.localizationStore.localizedStringFrom(busRoute, BusRoute.localizationKeyForDestination,Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),))),
                             ]), onTap:  (){
                                Stores.routeListStore.setSelectedRoute(Stores.routeListStore.displayedRoutes[index]);


                              },)),
                              (busRoute == Stores.routeListStore.selectedRoute) ?  Expanded(flex: 4,
                                  child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                  InkWell(child:   Container( child: Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForInbound, Stores.localizationStore.localizationPref), style:  TextStyle(fontSize: 15, fontWeight:  FontWeight.w500, decoration: TextDecoration.underline,
                                  ),)), onTap: (){
                                  Stores.routeDetailStore.route = Stores.routeListStore.displayedRoutes[index];
                                  Stores.routeDetailStore.isInbound = true;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BusRouteDetailView()),
                                  );
                                },), InkWell(child:   Container( child: Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForOutbound, Stores.localizationStore.localizationPref), style:  TextStyle(fontSize: 15, fontWeight:  FontWeight.w500, decoration: TextDecoration.underline)), ), onTap: (){
                                  Stores.routeDetailStore.route = Stores.routeListStore.displayedRoutes[index];
                                  Stores.routeDetailStore.isInbound = false;
                                  Stores.routeListStore.setFilterKeyword("");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BusRouteDetailView()),
                                  );
                                },)
                                ],)) :  Expanded(flex: 0,
                                  child:Container()),
                              Container(height: 1, color: Colors.grey,)
                            ])),
                  ),
                  );
                }
            ).build(context)),
          ],
        )) : InkWell(child: Container(width: 100,height: 100, child:Text("Failed to get route list, tap to retry")),
              onTap: (){
                NetworkUtil.sharedInstance().getRoute();
            },))
            : Observer(
            builder: (_) =>Text(Stores.localizationStore.localizedString(LocalizationUtil.localizationKeyForETAListView, Stores.localizationStore.localizationPref)))
      )),



    );
  }
}