import 'package:cookiej/controller/apiController.dart';
import 'package:cookiej/model/reposts.dart';
import 'package:cookiej/model/weibo.dart';
import 'package:cookiej/view/components/comments/repost_widget.dart';
import 'package:cookiej/view/public/weibo_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RepostListview extends StatefulWidget {
  final int sourceWeiboId;
  RepostListview(this.sourceWeiboId);
  @override
  _RepostListviewState createState() => _RepostListviewState();
}

class _RepostListviewState extends State<RepostListview> {
  var _weiboList=<Weibo>[];
  Future<Reposts> repostsTask;

  @override
  void initState(){
    repostsTask=ApiController.getReposts(widget.sourceWeiboId).then((reposts){
      _weiboList=reposts.reposts;
      return reposts;
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
            return Center(child:CircularProgressIndicator());
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