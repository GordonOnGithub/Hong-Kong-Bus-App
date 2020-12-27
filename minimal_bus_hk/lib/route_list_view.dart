import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/bus_route_detail_view.dart';
import 'package:minimal_bus_hk/model/directional_route.dart';
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
    return RouteListViewPage();
  }
}

class RouteListViewPage extends StatefulWidget {
  RouteListViewPage({Key key }) : super(key: key);

  @override
  _RouteListViewPageState createState() => _RouteListViewPageState();
}

class _RouteListViewPageState extends State<RouteListViewPage> {
  TextEditingController _searchFieldController;

  @override
  void initState() {
    super.initState();
    Stores.routeListStore.setSelectedDirectionalRoute(null);
    CacheUtils.sharedInstance().getRoutes().then((value) => Stores.routeListStore.setDataFetchingError(!value));
    Stores.routeListStore.setFilterKeyword("");
    _searchFieldController = TextEditingController(text:Stores.routeListStore.filterKeyword);

    Stores.appConfig.shouldShowRouteSearchReminder().then((value){
      if(value){
        showDialog(context: context, builder: (context) => _buildReminderDialog(context));
      }
    });
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
        builder: (_) => Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteListView, Stores.localizationStore.localizationPref))),
      ),
      body: Observer(
      builder: (_) => Center(

        child:  Stores.routeListStore.displayedDirectionalRoutes != null ?(
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child:Observer(
                builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex:1,
                child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:
                Row( crossAxisAlignment: CrossAxisAlignment.center, children:[
                  Icon(Icons.search),
                Expanded(child: TextField(
                  controller: _searchFieldController,
                  onChanged: (text){
                  Stores.routeListStore.setFilterKeyword(text);
                },
                  decoration: InputDecoration(
                      hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                  ),
                ),
                ),
                Stores.routeListStore.filterKeyword.length > 0?
                IconButton(icon: Icon(Icons.cancel_outlined), onPressed: (){
                  _searchFieldController.text = "";
                 Stores.routeListStore.setFilterKeyword("");
                },):Container()
                ]))
            ),
            Expanded(flex: 9,
            child:Scrollbar(child:
            ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                itemCount:   Stores.routeListStore.displayedDirectionalRoutes.length ,
                itemBuilder: (BuildContext context, int index) {
                  DirectionalRoute directionalBusRoute = Stores.routeListStore.displayedDirectionalRoutes[index];
                  return Observer(
                      builder: (_) =>Container(
                        height:  80,
                        color:  Stores.routeListStore.selectedDirectionalRoute ==  Stores.routeListStore.displayedDirectionalRoutes[index]? Colors.blue[50] : Colors.grey[50],
                        child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:[
                        Expanded(child: Row(children: [
                          Flexible(flex:10, child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                               InkWell(child:
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children:[
                               Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child: Text( directionalBusRoute.route.routeCode, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),))),
                               Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child:Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${LocalizationUtil.localizedStringFrom(directionalBusRoute.route, directionalBusRoute.isInbound? BusRoute.localizationKeyForOrigin: BusRoute.localizationKeyForDestination,Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),))),
                             ]), onTap:  (){
                                 _onRouteSelected(index);
                               },),
                            ])),
                          Flexible(flex: 1, child: Icon(Icons.arrow_forward))

                        ],)),
                              Container(height: 1, color: Colors.grey,)
                            ])),
                  ),
                  );
                }
            ).build(context))),
            (Stores.routeListStore.dataFetchingError ) ?

            InkWell(child:
            Container( color: Colors.yellow, height: 50, alignment: Alignment.center, child:
            Observer(
                builder: (_) =>Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForFailedToLoadData, Stores.localizationStore.localizationPref), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),))),
              onTap: (){
                Stores.routeListStore.setDataFetchingError(false);
                NetworkUtil.sharedInstance().getRoute().then((value) => Stores.routeListStore.setDataFetchingError(!value));
              },)
             : Container()
          ],
        )))
        ) : Observer(
            builder: (_) =>Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForLoading, Stores.localizationStore.localizationPref), textAlign: TextAlign.justify,))
      )),

    );
  }
  
  void _onRouteSelected(int index){
    var directionalRoute = Stores.routeListStore.displayedDirectionalRoutes[index];
    Stores.routeListStore.setSelectedDirectionalRoute(directionalRoute);
    FocusScope.of(context).requestFocus(FocusNode());
    Stores.routeDetailStore.route = directionalRoute.route;
    Stores.routeDetailStore.isInbound = directionalRoute.isInbound;
    Stores.routeListStore.setFilterKeyword("");
    _searchFieldController.text = "";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusRouteDetailView()),
    );
  }

  Widget _buildReminderDialog(BuildContext context) {
    return WillPopScope(child: AlertDialog(title: Text(""),
      content: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearchReminder, Stores.localizationStore.localizationPref)),
      actions: [
        FlatButton(onPressed: (){
          Stores.appConfig.setShouldShowRouteSearchReminder(false);
          Navigator.of(context).pop();
        }, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForUnderstand, Stores.localizationStore.localizationPref))),
            ],), onWillPop: () async => false ,);

  }
}