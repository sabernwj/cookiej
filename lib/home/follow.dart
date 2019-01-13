import 'package:flutter/material.dart';
import '../components/weibo_widget.dart';
import '../components/weiboTimeline.dart';
import '../utils/httpController.dart';
import '../global_config.dart';

class Follow extends StatefulWidget {
  @override
  _FollowState createState() => _FollowState();
}

class _FollowState extends State<Follow> {

  WeiboTimeline homeTimeline;
  Future<WeiboTimeline> homeTimelineFuture;
  var weiboWidgetlist=<WeiboWidget>[];

  @override
  void initState(){
    super.initState();
    homeTimelineFuture=HttpController.getStatusesHomeTimeline().then((jsonMap){
      homeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in homeTimeline.statuses){
        weiboWidgetlist.add( new WeiboWidget(weibo));
      }
      return homeTimeline;
    }).catchError((err){
      print(err);
    });
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future:homeTimelineFuture,
      builder: (BuildContext context,snaphot){
        if(snaphot.data==null){
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }else{
          return new RefreshIndicator(
            child: SingleChildScrollView(
              child: new Container(
                child: new Column(
                  children: weiboWidgetlist,
                ),
                color: GlobalConfig.backGroundColor,
              ),
            ),
            onRefresh: refreshData,
          );
        }
      },
    );
  }
  
  Future<Null> loadMoreData ()async{

  }

  Future<Null> refreshData() async{
    var _homeTimeLine=await HttpController.getStatusesHomeTimeline().then((jsonMap){
      homeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in homeTimeline.statuses){
        weiboWidgetlist.add( new WeiboWidget(weibo));
      }
      return homeTimeline;
    }).catchError((err){
      print(err);
    });
  }
}