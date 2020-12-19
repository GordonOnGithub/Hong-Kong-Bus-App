import 'package:flutter/material.dart';
import 'utils/network_util.dart';
import 'utils/stores.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingViewPage(title: ''),
    );
  }
}

class SettingViewPage extends StatefulWidget {
  SettingViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingViewPageState createState() => _SettingViewPageState();
}

class _SettingViewPageState extends State<SettingViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center( child: Observer(
    builder: (_) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(child: Container(child: Text("Language"),), onTap: (){

        },),
        InkWell(child: Container(child: Text("Invalidate Cached Data"),), onTap: (){

        },),
        InkWell(child: Container(child: Text("About"),), onTap: (){

        },),
      ],)
        ),)
    );
  }
}