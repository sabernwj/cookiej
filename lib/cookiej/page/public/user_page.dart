
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'dart:async';

class UserPage extends StatefulWidget {
  final String userId;
  final String screenName;
  final UserLite inputUser;
  UserPage({this.userId,this.screenName,this.inputUser});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User activeUser;

  @override
  void initState(){
    activeUser=widget.inputUser??UserLite.init();
    activeUser.screenName=widget.screenName??null;
    activeUser.idstr=widget.userId;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    Future<bool> isFindUserComplete=UserProvider.getUserInfoFromNet(screenName: widget.screenName).then((result){
      if(result.success) activeUser=result.data;
      return true;
    }).catchError((e)=>false);
    //这部分用于拉取微博列表
    Map<String,String> exraParams=new Map();
    if(activeUser.screenName!='.用户名.'){
      exraParams['screen_name']=activeUser.screenName;
    }
    if(activeUser.idstr!=null){
      exraParams['uid']=activeUser.idstr;
    }

    return Scaffold(
      // body: WeiboListview(timelineType: WeiboTimelineType.User,extraParams: exraParams),
      body: CustomScrollView(
        slivers:<Widget>[
          SliverAppBar(
            expandedHeight: 200,
          ),
          SliverFillRemaining(
            child:FutureBuilder(
              future: isFindUserComplete,
              builder: (context,snaphot){
                if(snaphot.hasData){
                  if(snaphot.data) return WeiboListview(timelineType: WeiboTimelineType.User,extraParams: exraParams);
                }
                return Container();
              }
            )

          )
        ]
      )
    );
  }
}