
import 'package:cookiej/cookiej/page/widget/comments/comment_listview.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/provider/weibo_provider.dart';
import 'package:flutter/material.dart';
import '../../model/weibo.dart';
import 'dart:async';
class WeiboPage extends StatefulWidget{
  final int weiboId;
  WeiboPage(this.weiboId);
  @override
  _WeiboPageState createState()=>_WeiboPageState();
}

class _WeiboPageState extends State<WeiboPage>{
  
  Future<ProviderResult<Weibo>> weiboTask;
  @override
  void initState() {
    weiboTask =WeiboProvider.getStatusesShow(widget.weiboId);
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
            case ConnectionState.waiting:
              return Center(child:CircularProgressIndicator());
            case ConnectionState.done:
              if(snapshot.hasError){
                return Container(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      SizedBox(height: 16),
                      Text(snapshot.error.toString()),
                      SizedBox(height: 16),
                      RaisedButton(
                        child: Text('刷新试试'),
                        onPressed: (){
                          weiboTask =WeiboProvider.getStatusesShow(widget.weiboId);
                        }
                      ),
                      SizedBox(height: 16),
                    ]
                  )
                );
              }
              Weibo weibo=snapshot.data.data;
              return snapshot.data.success?
                Container(child:ListView(
                  children:<Widget>[
                    WeiboWidget(weibo,clicked: false,),
                    CommentListview(weibo.id)
                  ]
                ))
                :Text('未知状态');
            default:
              return Text('未知状态');
          }
        }
      )
    );
  }
}