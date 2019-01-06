import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage>{

  var _tabs=<Tab>[
    new Tab(text: '全部关注',),
    new Tab(text: '好友圈',),
    new Tab(text: '特别关注',)
  ];

  @override
  Widget build(BuildContext context){
    return new DefaultTabController(
      length:_tabs.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('饼干酱'),
          bottom: new TabBar(
            tabs: _tabs,
          )
        ),
      ),
    );
  }
}