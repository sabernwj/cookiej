
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final String userId;
  final String screenName;
  UserPage({this.userId,this.screenName});


  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    Map<String,String> exraParams=new Map();
    if(widget.screenName!=null){
      exraParams['screen_name']=widget.screenName;
    }
    if(widget.userId!=null){
      exraParams['uid']=widget.userId;
    }
    return Scaffold(
      body: WeiboListview(timelineType: WeiboTimelineType.User,extraParams: exraParams),
    );
  }
}