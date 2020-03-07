import '../components/comments/comment_listview.dart';
import '../../controller/apiController.dart';
import 'package:flutter/material.dart';
import '../components/weibo/weibo_widget.dart';
import '../../model/weibo.dart';
import 'dart:async';
class WeiboPage extends StatefulWidget{
  final int weiboId;
  WeiboPage(this.weiboId);
  @override
  _WeiboPageState createState()=>_WeiboPageState();
}

class _WeiboPageState extends State<WeiboPage>{
  
  Future<Weibo> weiboTask;
  @override
  void initState() {
    weiboTask =ApiController.getStatusesShow(widget.weiboId);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text('微博正文'),
      ),
      body: FutureBuilder(
        future: weiboTask,
        builder: (BuildContext context,snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child:CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              return snapshot.data==null?Text('未知状态'):Container(child:ListView(
                children:<Widget>[
                  WeiboWidget(snapshot.data),
                  CommentListview((snapshot.data as Weibo).id)
                ]
              ));
            default:
              return Text('未知状态');
          }
        }
      )
    );
  }
}