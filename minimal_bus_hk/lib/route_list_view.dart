import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/bus_route_detail_view.dart';
import 'package:minimal_bus_hk/google_map_view.dart';
import 'package:minimal_bus_hk/journey_planner_view.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/directional_route.dart';
import 'package:minimal_bus_hk/stop_list_view.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'package:minimal_bus_hk/utils/localization_util.dart';
import 'package:mobx/mobx.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:minimal_bus_hk/model/bus_route.dart';
import 'package:mobx/mobx.dart' as mobx;

class RouteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteListViewPage();
  }
}

class RouteListViewPage extends StatefulWidget {
  RouteListViewPage({Key? key }) : super(key: key);

  @override
  _RouteListViewPageState createState() => _RouteListViewPageState();
}

class _RouteListViewPageState extends State<RouteListViewPage> with TickerProviderStateMixin{
  TextEditingController? _searchFieldController;
  TabController? _tabController;
  ReactionDisposer? _tabControllerReaction;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabControllerReaction = mobx.reaction((_) => Stores.routeListStore.filterStopIdentifier, (identifier) {
      _tabController?.index = Stores.dataManager.busStopDetailMap?[Stores.routeListStore.filterStopIdentifier]?.companyCode ==  NetworkUtil.companyCodeKMB ? 1 : 0;
    });

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
    Stores.routeListStore.clearFilters();
    if (_tabControllerReaction != null) {
      _tabControllerReaction!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
        builder: (_) => Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteListView, Stores.localizationStore.localizationPref))),
        bottom: TabBar(
          controller: _tabController,
          tabs:  <Widget>[
        Observer(
        builder: (_) =>
            Tab(
             text: Stores.routeListStore.nwfbTabTitle,
            )),
    Observer(
    builder: (_) =>
            Tab(
              text: Stores.routeListStore.kmbTabTitle,
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:  <Widget>[
          Center(
            child:Observer(
      builder: (_) => getDirectionalRouteListView(Stores.routeListStore.displayedDirectionalRoutesForNWFBAndCTB)),
          ),
          Center(
            child: Observer(
          builder: (_) => getDirectionalRouteListView(Stores.routeListStore.displayedDirectionalRoutesForKMB)),
          )
        ],
      ),
        floatingActionButton:
            // TODO: re-enable it if full data download is optimized later
        // (Stores.appConfig.downloadAllData ?? false) ?
        // FloatingActionButton.extended(icon: Icon(Icons.flag), label: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForBusStopList, Stores.localizationStore.localizationPref)),
        // onPressed: (){
        //    _onBusStopListClicked();
        // },) :
        Container(),
    );
  }

  Widget getDirectionalRouteListView(ObservableList<DirectionalRoute> directionalRouteList){
    return Center(

            child:  directionalRouteList != null &&  Stores.dataManager.routes != null && Stores.dataManager.routes!.length > 0?(
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child:Observer(
                        builder: (_) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                            Expanded(flex:1,
                                child:
                                Container(color: Colors.grey[50], child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20), child:
                                Row( crossAxisAlignment: CrossAxisAlignment.center, children:[
                                  Icon(Icons.search),
                                  Expanded(child:
                                  Stores.routeListStore.filterStopIdentifier != null && Stores.routeListStore.filterStopIdentifier.length > 0?
                                  Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForBusStop, Stores.localizationStore.localizationPref)}: ${LocalizationUtil.localizedStringFrom( Stores.dataManager.busStopDetailMap![Stores.routeListStore.filterStopIdentifier], BusStopDetail.localizationKeyForName, Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),)
                                      : TextField(
                                    controller: _searchFieldController,
                                    onChanged: (text){
                                      Stores.routeListStore.setFilterKeyword(text);
                                    },
                                    decoration: InputDecoration(
                                        hintText: LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearchTextFieldPlaceholder, Stores.localizationStore.localizationPref)
                                    ),
                                  ),
                                  ),
                                  Stores.routeListStore.filterStopIdentifier != null && Stores.routeListStore.filterStopIdentifier.length > 0?
                                  IconButton(icon: Icon(Icons.location_on_outlined), onPressed: (){
                                    Stores.googleMapStore.setSelectedBusStop(Stores.dataManager.busStopDetailMap![Stores.routeListStore.filterStopIdentifier]);
                                    Stores.googleMapStore.setSelectedRoute(null);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GoogleMapView()),
                                    );
                                  },) : Container()
                                  ,
                                  Stores.routeListStore.filterKeyword.length > 0 || Stores.routeListStore.filterStopIdentifier.length > 0?
                                  IconButton(icon: Icon(Icons.cancel_outlined), onPressed: (){
                                    _searchFieldController?.text = "";
                                    Stores.routeListStore.clearFilters();
                                  },):Container()
                                ])))
                            ),
                            // Container(height: 1, color: Colors.grey,),
                            Expanded(flex: 9,
                                child:Scrollbar(child:
                                ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                                    itemCount:  directionalRouteList.length + 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index >= directionalRouteList.length){
                                        return Container(height: 60);
                                      }

                                      DirectionalRoute directionalBusRoute = directionalRouteList[index];
                                      return Observer(
                                        builder: (_) =>Container(
                                          margin:  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black!),
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color:  Colors.white ,
                                          ),
                                          height:  100,
                                          child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), child:
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children:[
                                                Expanded(child: Row(children: [
                                                  Expanded(child:
                                                  Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        InkWell(child:
                                                        Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:[
                                                              Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child: Text( "${LocalizationUtil.localizedString(directionalBusRoute.route.companyCode, Stores.localizationStore.localizationPref)} ${directionalBusRoute.route.routeCode}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),))),
                                                              Container(child:Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),child:Text("${LocalizationUtil.localizedString(LocalizationUtil.localizationKeyTo, Stores.localizationStore.localizationPref)}: ${LocalizationUtil.localizedStringFrom(directionalBusRoute.route, directionalBusRoute.isInbound? BusRoute.localizationKeyForOrigin: BusRoute.localizationKeyForDestination,Stores.localizationStore.localizationPref)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),))),
                                                            ]), onTap:  (){
                                                          _onRouteSelected(index, directionalRouteList);
                                                        },),
                                                      ])),

                                                ],)),
                                                // Container(height: 1, color: Colors.grey,)
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
        );

  }

  void _onRouteSelected(int index, ObservableList<DirectionalRoute> directionalRouteList){
    var directionalRoute = directionalRouteList[index];
    if(Stores.routeListStore.filterStopIdentifier != null && Stores.routeListStore.filterStopIdentifier.length > 0){
      Stores.routeDetailStore.setSelectedStopId(Stores.routeListStore.filterStopIdentifier);
    }

    Stores.routeListStore.setSelectedDirectionalRoute(directionalRoute);
    FocusScope.of(context).requestFocus(FocusNode());
    Stores.routeDetailStore.route = directionalRoute.route;
    Stores.routeDetailStore.isInbound = directionalRoute.isInbound;
    Stores.routeListStore.clearFilters();
    _searchFieldController?.text = "";

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusRouteDetailView()),
    );
  }

  void _onJourneyPlannerClicked(){
    Stores.routeListStore.clearFilters();
    _searchFieldController?.text = "";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JourneyPlannerView()),
    );
  }

  void _onBusStopListClicked(){
    Stores.routeListStore.clearFilters();
    Stores.stopListViewStore.filterKeywords = "";
    _searchFieldController?.text = "";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StopListView()),
    );
  }

  Widget _buildReminderDialog(BuildContext context) {
    return WillPopScope(child: AlertDialog(title: Text(""),
      content: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForRouteSearchReminder, Stores.localizationStore.localizationPref)),
      actions: [
        TextButton(onPressed: (){
          Stores.appConfig.setShouldShowRouteSearchReminder(false);
          Navigator.of(context).pop();
        }, child: Text(LocalizationUtil.localizedString(LocalizationUtil.localizationKeyForUnderstand, Stores.localizationStore.localizationPref))),
            ],), onWillPop: () async => false ,);

  }
}