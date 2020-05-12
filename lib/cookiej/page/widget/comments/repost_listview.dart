
import 'package:cookiej/cookiej/model/reposts.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
import 'package:cookiej/cookiej/page/widget/comments/repost_widget.dart';
import 'package:cookiej/cookiej/provider/weibo_provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

class RepostListview extends StatefulWidget {
  final int sourceWeiboId;
  RepostListview(this.sourceWeiboId);
  @override
  _RepostListviewState createState() => _RepostListviewState();
}

class _RepostListviewState extends State<RepostListview> {
  var _weiboList=<WeiboLite>[];
  Future<Reposts> repostsTask;

  @override
  void initState(){
    repostsTask=WeiboProvider.getReposts(widget.sourceWeiboId).then((result){
      _weiboList=result.data.reposts;
      return result.data;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: repostsTask, 
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(margin: EdgeInsets.all(32), child:Center(child:CircularProgressIndicator()));
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return snapshot.data==null?Text('未知状态'):Container(
              child: ListView.builder(
                itemBuilder: (BuildContext context,int index){
                    return GestureDetector(
                      child: RepostWidget(_weiboList[index]),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(_weiboList[index].id)));
                      },
                    );
                },
                itemCount: _weiboList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            );
          default:
            return Text('未知状态');
        }
      },
    );
  }
}