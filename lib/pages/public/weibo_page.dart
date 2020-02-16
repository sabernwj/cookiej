import 'package:cookiej/utils/httpController.dart';
import 'package:flutter/material.dart';
import '../../components/weibo_widget.dart';
import '../../components/weibo.dart';
import 'dart:async';
class WeiboPage extends StatefulWidget{
  final int weiboId;
  WeiboPage(this.weiboId);
  @override
  _WeiboPageState createState()=>_WeiboPageState();
}

class _WeiboPageState extends State<WeiboPage>{

  Widget _acitvePage ;
  Future<Weibo> weiboTask;
  @override
  void initState() {
    _acitvePage=new Container();
    weiboTask =HttpController.getStatusesShow(widget.weiboId);
    // weiboTask.then((returnWeibo){
    //   setState(() {
    //     _acitvePage=WeiboWidget(returnWeibo);
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text('微博详情'),
      ),
      body: FutureBuilder(
        future: weiboTask,
        builder: (BuildContext context,snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child:CircularProgressIndicator());
            case ConnectionState.done:
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              return snapshot.data==null?Text('未知状态'):ListView(
                children:<Widget>[
                  WeiboWidget(snapshot.data)
                ]
              );
            default:
              return Text('未知状态');
          }
        }
      ),
      backgroundColor: Colors.white,
    );
  }
}