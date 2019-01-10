import 'package:flutter/material.dart';
import '../components/weibo.dart';
import '../components/weibo_widget.dart';
import '../components/weiboTimeline.dart';
import '../utils/httpController.dart';

class Follow extends StatefulWidget {
  @override
  _FollowState createState() => _FollowState();
}

class _FollowState extends State<Follow> {


  @override
  Widget build(BuildContext context) {
    var homeTimeline=HttpController.getStatusesHomeTimeline().then((jsonMap){
      return WeiboTimeline.fromJson(jsonMap);
      }).catchError((err){
        print(err);
      });

    return new SingleChildScrollView(
      child: FutureBuilder(
        future:homeTimeline,
        builder: (BuildContext context,snaphot){
          if(snaphot.data==null){
            return new Container();
          }else{
            return new Container(
              margin: EdgeInsets.only(top: 0.5),
              child: new Column(
                children: <Widget>[

                ],
              ),
            );
          }
        },
      )
    );
  }
}