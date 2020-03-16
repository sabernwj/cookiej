import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/provider/weibo_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './weibo_widget.dart';
import 'package:cookiej/cookiej/model/weibos.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import '../../public/weibo_page.dart';
import 'dart:async';

class WeiboListview extends StatefulWidget {
  final WeiboTimelineType timelineType;
  final Map<String,String> extraParams;
  WeiboListview({this.timelineType=WeiboTimelineType.Statuses,this.extraParams});
  @override                                                                                                               
  _WeiboListviewState createState() => _WeiboListviewState();
}

//微博列表，目前叫timeline是以时间倒序来显示微博
//后面会有热门微博，推荐微博之类的非时间线微博，可在此组件上复用也可考虑再开一个组件
class _WeiboListviewState extends State<WeiboListview> with AutomaticKeepAliveClientMixin{
  final RefreshController _refreshController=RefreshController(initialRefresh:false);
  Weibos homeTimeline;
  Weibos earlyHomeTimeline;
  Weibos laterHomeTimeline;
  var _weiboList=<WeiboLite>[];
  Future<bool> _isStartLoad;
  String uid;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    _isStartLoad=startLoadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreBuilder<AppState>(
      builder: (context,store){
        return FutureBuilder(
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
                  canLoadingText: '加载更多',
                  idleText: '加载更多',
                  loadingText: '加载中',
                  noDataText: '已无更多数据'
                ),
                controller: _refreshController,
                child: ListView.builder(
                  itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        child: WeiboWidget(_weiboList[index]),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(_weiboList[index].id)));
                        },
                      );
                  },
                  itemCount: _weiboList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
                onRefresh: refreshData,
                onLoading: loadMoreData,
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
      onDidChange: (store){
        if(uid!=store.state.accessState.currentAccess.uid){
          uid=store.state.accessState.currentAccess.uid;
          setState(() {
            _weiboList=[];
            startLoadData();
          });
        }
      },
    );
  }
  ///开始获取微博
  ///(目前从网络获取，可添加从本地缓存中读取)
  Future<bool> startLoadData() async{
    var result=WeiboProvider.getTimeLine(timelineType: widget.timelineType,extraParams: widget.extraParams).then((timeline){
      homeTimeline=timeline.data;
      laterHomeTimeline=homeTimeline;
      for(var weibo in homeTimeline.statuses){
        _weiboList.add(weibo);
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
    WeiboProvider.getTimeLine(maxId: earlyHomeTimeline.maxId??0,timelineType: widget.timelineType,extraParams: widget.extraParams).then((timeline){
      earlyHomeTimeline=timeline.data;
      if(earlyHomeTimeline!=null){
        setState(() {
          for(var weibo in earlyHomeTimeline.statuses){
            _weiboList.add(weibo);
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
    var weiboList=<WeiboLite>[];
    WeiboProvider.getTimeLine(sinceId: laterHomeTimeline.sinceId??0,timelineType: widget.timelineType,extraParams: widget.extraParams).then((timeline){
      laterHomeTimeline=timeline.data;
      if(laterHomeTimeline!=null){
        for(var weibo in laterHomeTimeline.statuses){
          weiboList.add(weibo);
        }
        setState(() {
          _weiboList.insertAll(0, weiboList);
        });
      }
      _refreshController.refreshCompleted();
    }).catchError((err){
      _refreshController.refreshFailed();
      print(err);
    });
  }
}