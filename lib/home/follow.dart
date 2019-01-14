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
  final ScrollController _scrollController = ScrollController();
  WeiboTimeline homeTimeline;
  WeiboTimeline earlyHomeTimeline;
  WeiboTimeline laterHomeTimeline;
  var weiboWidgetlist=<WeiboWidget>[];

  @override
  void initState(){
    startLoadData().then((result){
      if(result==true){
        _scrollController.addListener((){
          ///判断当前滑动位置是不是到达底部，触发加载更多回调
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
            loadMoreData();
          }
        });
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future:startLoadData(),
      builder: (BuildContext context,snaphot){
        if(snaphot.data==false){
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }else{
          return new RefreshIndicator(
            child: SingleChildScrollView(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    Column(children: weiboWidgetlist,),
                    //配套拉到底部刷新用的加载小圈
                    FutureBuilder(
                      future: loadMoreData(),
                      builder: (BuildContext context,snaphot){
                        if(snaphot.data==false){
                          return CircularProgressIndicator();
                        }else{
                          return Container();
                        }
                      },
                    )
                  ],
                ),
                color: GlobalConfig.backGroundColor,
              ),
              controller: _scrollController,
            ),
            onRefresh: refreshData,
          );
        }
      },
    );
  }
  
  Future<bool> startLoadData() async{
    var result=HttpController.getStatusesHomeTimeline().then((jsonMap){
      homeTimeline=WeiboTimeline.fromJson(jsonMap);
      laterHomeTimeline=homeTimeline;
      earlyHomeTimeline=homeTimeline;
      for(var weibo in homeTimeline.statuses){
        weiboWidgetlist.add( new WeiboWidget(weibo));
      }
      return true;
    }).catchError((err){
      print(err);
      return false;
    });
    return result;
  }

  Future<bool> loadMoreData ()async{
    var _weiboWidgetlist=<WeiboWidget>[];
    var reusult=HttpController.getStatusesHomeTimeline(maxId: earlyHomeTimeline.maxId).then((jsonMap){
      earlyHomeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in earlyHomeTimeline.statuses){
        _weiboWidgetlist.add(WeiboWidget(weibo));
      }
      setState(() {
        weiboWidgetlist.addAll(_weiboWidgetlist);
      });
      return true;
    }).catchError((err){
      print(err);
      return false;
    });
    return reusult;
  }

  Future<Null> refreshData() async{
    var _weiboWidgetlist=<WeiboWidget>[];
    HttpController.getStatusesHomeTimeline(sinceId: laterHomeTimeline.sinceId).then((jsonMap){
      laterHomeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in laterHomeTimeline.statuses){
        _weiboWidgetlist.add(WeiboWidget(weibo));
      }
      setState(() {
        weiboWidgetlist.setAll(0, _weiboWidgetlist);
      });
    }).catchError((err){
      print(err);
    });
  }
}