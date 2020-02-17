import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../components/weibo_widget.dart';
import '../../components/weiboTimeline.dart';
import '../../utils/httpController.dart';
import '../../components/weibo.dart';
import '../public/weibo_page.dart';
import 'dart:async';

class Timeline extends StatefulWidget {
  final String timelineType;
  Timeline({this.timelineType='status'});
  @override                                                                                                               
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController=RefreshController(initialRefresh:false);
  WeiboTimeline homeTimeline;
  WeiboTimeline earlyHomeTimeline;
  WeiboTimeline laterHomeTimeline;
  var _weiboWidgetlist=<Weibo>[];
  Future<bool> _isStartLoad;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    _isStartLoad=startLoadData();
    // _isStartLoad.then((result){
    //   if(result==true){
    //     _scrollController.addListener((){
    //       ///判断当前滑动位置是不是到达底部，触发加载更多回调
    //       if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent&&_isLoadingMoreData==false) {
    //         loadMoreData();
    //       }
    //     });
    //   }
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new FutureBuilder(
      future:_isStartLoad,
      builder: (BuildContext context,snaphot){
        if(snaphot.data==true){
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: ClassicHeader(
              refreshingText: '刷新中',
              failedText: '刷新失败',
              completeText:'刷新成功' ,
              releaseText: '刷新微博',
              idleText: '下拉刷新',
            ),
            footer: ClassicFooter(
              failedText: '加载失败',
              idleText: '加载更多',
              loadingText: '加载中',
              noDataText: '已无更多数据'
            ),
            controller: _refreshController,
            child: ListView.builder(
              itemBuilder: (BuildContext context,int index){
                
                  return new GestureDetector(
                    child: WeiboWidget(_weiboWidgetlist[index]),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(_weiboWidgetlist[index].id)));
                    },
                  );

              },
              itemCount: _weiboWidgetlist.length,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
            onRefresh: refreshData,
            onLoading: loadMoreData,
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
    //解释一下，这里的意思是第一次获取更早的微博，最早微博时间线取当前主页时间线
    if(earlyHomeTimeline==null){
      earlyHomeTimeline=homeTimeline;
    }
    if(earlyHomeTimeline.maxId==0){
      _refreshController.loadNoData();
      return;
    }
    HttpController.getTimeLine(maxId: earlyHomeTimeline.maxId??0,timelineType: widget.timelineType).then((timeline){
      earlyHomeTimeline=timeline;
      if(earlyHomeTimeline!=null){
        setState(() {
          for(var weibo in earlyHomeTimeline.statuses){
            _weiboWidgetlist.add(weibo);
          }
        });
      }

      _refreshController.loadComplete();
    }).catchError((err){
      _refreshController.loadFailed();
    });
  }

  ///刷新微博
  void refreshData() async{
    var weiboWidgetlist=<Weibo>[];
    HttpController.getTimeLine(sinceId: laterHomeTimeline.sinceId??0,timelineType: widget.timelineType).then((timeline){
      laterHomeTimeline=timeline;
      if(laterHomeTimeline!=null){
        for(var weibo in laterHomeTimeline.statuses){
          weiboWidgetlist.add(weibo);
        }
        setState(() {
          _weiboWidgetlist.setAll(0, weiboWidgetlist);
        });
      }
      _refreshController.refreshCompleted();
    }).catchError((err){
      _refreshController.refreshFailed();
      print(err);
    });
  }
}