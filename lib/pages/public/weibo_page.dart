import 'package:flutter/material.dart';
import '../../components/weibo_widget.dart';
import '../../components/weibo.dart';

class WeiboPage extends StatefulWidget{
  final WeiboWidget webioWidget;
  WeiboPage(this.webioWidget);
  @override
  _WeiboPageState createState()=>_WeiboPageState();
}

class _WeiboPageState extends State<WeiboPage>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text('微博详情'),
      ),
      body: new Container(
        child: widget.webioWidget,
      ),
    );
  }
}