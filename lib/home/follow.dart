import 'package:flutter/material.dart';
import '../components/weibo_widget.dart';
import '../components/weiboTimeline.dart';
import '../utils/httpController.dart';

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
  bool _isLoadingMoreData=false;
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
      future:_isStartLoad,
      builder: (BuildContext context,snaphot){
        if(snaphot.data==true){
          return RefreshIndicator(
            child: ListView(
              children: (){
                var list=<Widget>[];
                list.addAll(weiboWidgetlist);
                if(_isLoadingMoreData==true){
                  list.add(
                    Container(
                      child: CircularProgressIndicator(),
                      padding: EdgeInsets.all(10),
                    )
                  );
                }
                return list;
              }(),
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

  void loadMoreData()async{
    var _weiboWidgetlist=<WeiboWidget>[];
    if(earlyHomeTimeline==null){
      earlyHomeTimeline=homeTimeline;
    }
    if(earlyHomeTimeline.maxId==0||earlyHomeTimeline.sinceId>=laterHomeTimeline.sinceId){
      return;
    }
    setState(() {
          _isLoadingMoreData=true;
    });
    HttpController.getStatusesHomeTimeline(maxId: earlyHomeTimeline.maxId??0).then((jsonMap){
      earlyHomeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in earlyHomeTimeline.statuses){
        _weiboWidgetlist.add(WeiboWidget(weibo));
      }
      setState(() {
        _isLoadingMoreData=false;
        weiboWidgetlist.addAll(_weiboWidgetlist);
      });
    }).catchError((err){
    });
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