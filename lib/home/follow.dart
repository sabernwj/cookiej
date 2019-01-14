import 'package:flutter/material.dart';
import '../components/weibo_widget.dart';
import '../components/weiboTimeline.dart';
import '../utils/httpController.dart';
import '../global_config.dart';

class Follow extends StatefulWidget {
  @override
  _FollowState createState() => _FollowState();
}

class _FollowState extends State<Follow> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();
  WeiboTimeline homeTimeline;
  WeiboTimeline earlyHomeTimeline;
  WeiboTimeline laterHomeTimeline;
  var weiboWidgetlist=<WeiboWidget>[];
  Future<bool> _isLoadingMoreData;
  Future<bool> _isStartLoad;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    _isStartLoad=startLoadData();
    _isStartLoad.then((result){
      if(result==true){
        _scrollController.addListener((){
          ///判断当前滑动位置是不是到达底部，触发加载更多回调
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
            _isLoadingMoreData=loadMoreData();
          }
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future:_isStartLoad,
      builder: (BuildContext context,snaphot){
        if(snaphot.data==true){
          return new RefreshIndicator(
            child: SingleChildScrollView(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    Column(children: weiboWidgetlist,),
                    //配套拉到底部刷新用的加载小圈
                    FutureBuilder(
                      future: _isLoadingMoreData,
                      builder: (BuildContext context,snaphot){
                        if(snaphot.data==true){
                          return Container(
                            child: CircularProgressIndicator(),
                            padding: EdgeInsets.all(10),
                          );
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
        }else{
          return new Center(
            child: new CircularProgressIndicator(),
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
    var result=(()async {
      HttpController.getStatusesHomeTimeline(maxId: earlyHomeTimeline.maxId??0).then((jsonMap){
        earlyHomeTimeline=WeiboTimeline.fromJson(jsonMap);
        for(var weibo in earlyHomeTimeline.statuses){
          _weiboWidgetlist.add(WeiboWidget(weibo));
        }
        setState(() {
          weiboWidgetlist.addAll(_weiboWidgetlist);
        });
        return false;
      }).catchError((err){
        return false;
      });
      return true;
    })();

    return result;
  }

  Future<Null> refreshData() async{
    var _weiboWidgetlist=<WeiboWidget>[];
    HttpController.getStatusesHomeTimeline(sinceId: laterHomeTimeline.sinceId??0).then((jsonMap){
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