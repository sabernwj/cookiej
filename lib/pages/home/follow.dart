import 'package:flutter/material.dart';
import '../../components/weibo_widget.dart';
import '../../components/weiboTimeline.dart';
import '../../utils/httpController.dart';
import '../../components/weibo.dart';
import '../public/weibo_page.dart';
import 'dart:async';

class Follow extends StatefulWidget {
  final String timelineType;
  Follow({this.timelineType='status'});
  @override                                                                                                               
  _FollowState createState() => _FollowState();
}

class _FollowState extends State<Follow> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();
  WeiboTimeline homeTimeline;
  WeiboTimeline earlyHomeTimeline;
  WeiboTimeline laterHomeTimeline;
  var _weiboWidgetlist=<Weibo>[];
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
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent&&_isLoadingMoreData==false) {
            loadMoreData();
          }
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new FutureBuilder(
      future:_isStartLoad,
      builder: (BuildContext context,snaphot){
        if(snaphot.data==true){
          return RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (BuildContext context,int index){
                if(index<_weiboWidgetlist.length){
                  return new GestureDetector(
                    child: WeiboWidget(_weiboWidgetlist[index]),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(_weiboWidgetlist[index].id)));
                    },
                  );
                }
                return Container(
                  child: (){
                    if(_isLoadingMoreData){return Center(child:CircularProgressIndicator());}
                    else{return Container();}
                  }(),
                  padding: EdgeInsets.only(bottom: 15),
                );
              },
              itemCount: _weiboWidgetlist.length+1,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
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
  ///开始获取微博
  ///(目前从网络获取，可添加从本地缓存中读取)
  Future<bool> startLoadData() async{
    var result=HttpController.getTimeLine(timelineType: widget.timelineType).then((timeline){
      homeTimeline=timeline;
      laterHomeTimeline=homeTimeline;
      for(var weibo in homeTimeline.statuses){
        _weiboWidgetlist.add(weibo);
      }
      return true;
    }).catchError((err){
      print(err);
      return false;
    });
    return result;
  }
  ///加载更多
  void loadMoreData()async{
    var weiboWidgetlist=<Weibo>[];
    if(earlyHomeTimeline==null){
      earlyHomeTimeline=homeTimeline;
    }
    if(earlyHomeTimeline.maxId==0){
      return;
    }
    setState(() {
          _isLoadingMoreData=true;
    });
    HttpController.getTimeLine(maxId: earlyHomeTimeline.maxId??0,timelineType: widget.timelineType).then((timeline){
      earlyHomeTimeline=timeline;
      for(var weibo in earlyHomeTimeline.statuses){
        weiboWidgetlist.add(weibo);
      }
      setState(() {
        _isLoadingMoreData=false;
        _weiboWidgetlist.addAll(weiboWidgetlist);
      });
    }).catchError((err){
    });
  }

  ///刷新微博
  Future<Null> refreshData() async{
    var weiboWidgetlist=<Weibo>[];
    HttpController.getTimeLine(sinceId: laterHomeTimeline.sinceId??0,timelineType: widget.timelineType).then((timeline){
      laterHomeTimeline=timeline;
      for(var weibo in laterHomeTimeline.statuses){
        weiboWidgetlist.add(weibo);
      }
      setState(() {
        _weiboWidgetlist.setAll(0, weiboWidgetlist);
      });
    }).catchError((err){
      print(err);
    });
  }
}