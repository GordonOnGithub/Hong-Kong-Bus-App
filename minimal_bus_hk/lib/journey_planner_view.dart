import 'package:flutter/material.dart';
import 'package:minimal_bus_hk/utils/cache_utils.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class JourneyPlannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JourneyPlannerViewPage();
  }
}

class JourneyPlannerViewPage extends StatefulWidget {
  JourneyPlannerViewPage({Key key}) : super(key: key);

  @override
  _JourneyPlannerViewPageState createState() => _JourneyPlannerViewPageState();
}

class _JourneyPlannerViewPageState extends State<JourneyPlannerViewPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Observer(
        builder: (_) =>Center(child: Text("${Stores.dataManager.allDataFetchCount}/${(Stores.dataManager.routesMap.keys.length * 4)}"),))
    );
  }
}