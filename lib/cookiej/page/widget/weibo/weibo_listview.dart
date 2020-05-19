import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/event/notice_audio_event.dart';
import 'package:cookiej/cookiej/event/string_msg_event.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_list_mixin.dart';
import 'package:cookiej/cookiej/provider/weibo_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './weibo_widget.dart';
import 'package:cookiej/cookiej/model/weibos.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import '../../public/weibo_page.dart';
import 'dart:async';

///自带刷新加载更多的微博列表
class WeiboListview extends StatefulWidget {
  final WeiboTimelineType timelineType;
  final Map<String,String> extraParams;
  final String groupId;
  WeiboListview({this.timelineType=WeiboTimelineType.Statuses,this.extraParams,this.groupId});
  @override                                                                                                               
  _WeiboListviewState createState() => _WeiboListviewState();
}

//微博列表，目前叫timeline是以时间倒序来显示微博
//后面会有热门微博，推荐微博之类的非时间线微博，可在此组件上复用也可考虑再开一个组件
class _WeiboListviewState extends State<WeiboListview> with WeiboListMixin,AutomaticKeepAliveClientMixin{
  RefreshController _refreshController=RefreshController(initialRefresh:false);
  


  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    weiboListInit(widget.timelineType,extraParams:widget.extraParams);
    //isStartLoadDataComplete=startLoadData();
    assert((){
      eventBus.on<StringMsgEvent>().listen((event) {
        if(event.msg=='重新加载微博'){
          setState(() {
            weiboList=[];
            _refreshController.resetNoData();
            isStartLoadDataComplete=startLoadData();
          });
        }
      });
      return true;
    }());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreBuilder<AppState>(
      builder: (context,store){
        return FutureBuilder(
          future:isStartLoadDataComplete,
          builder: (BuildContext context,snaphot){
            if(snaphot.data==WeiboListStatus.complete){
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
                    if(index==readCursor){
                      if(readCursor==0) return Container();
                      return Container(
                        margin: EdgeInsets.only(bottom:12),
                        padding: EdgeInsets.symmetric(vertical:4,horizontal: 12),
                        alignment: Alignment.center,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                            Expanded(child: Divider(color: Theme.of(context).primaryColor,thickness: 1.5,)),
                            Text('上次阅读到这里',style: Theme.of(context).primaryTextTheme.bodyText2),
                             Expanded(child: Divider(color: Theme.of(context).primaryColor,thickness: 1.5,)),
                          ]
                        )
                      );
                    }
                    if(index>readCursor) index=index-1;
                    return Container(
                      child:WeiboWidget(weiboList[index]),
                      margin: EdgeInsets.only(bottom:12),
                    );
                  },
                  itemCount: weiboList.length+1,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
                onRefresh: (){
                  refreshData()
                    .then((isComplete){
                      if(isComplete==WeiboListStatus.complete) {
                        eventBus.fire(NoticeAudioEvent('refresh.mp3'));
                        setState(() {
                          _refreshController.refreshCompleted();
                        });
                      }
                      else if(isComplete==WeiboListStatus.nodata) setState(() {
                        _refreshController.refreshCompleted();
                      });
                      else _refreshController.refreshFailed();
                    }).catchError((e)=>_refreshController.refreshFailed());
                },
                onLoading: (){
                  loadMoreData()
                    .then((isComplete){
                      setState(() {
                        if(isComplete==WeiboListStatus.nodata) _refreshController.loadNoData();
                        if(isComplete==WeiboListStatus.complete) _refreshController.loadComplete();
                        if(isComplete==WeiboListStatus.failed) _refreshController.loadFailed();
                      });
                    }).catchError((e)=>_refreshController.loadFailed());
                },
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
      onInit: (store){
        localUid=store.state.accessState.currentAccess.uid;
        isStartLoadDataComplete=startLoadData();
      },
      onWillChange: (oldStore,store){
        if(localUid!=store.state.accessState.currentAccess.uid){
          localUid=store.state.accessState.currentAccess.uid;
          setState((){
            weiboList=[];
            _refreshController.resetNoData();
            isStartLoadDataComplete=startLoadData();
          });
        }
      },
    );
  }
  ///开始获取微博
  ///(目前从网络获取，可添加从本地缓存中读取)
  // Future<bool> startLoadData() async{
  //   var result=WeiboProvider.getTimeLine(localUid: uid,timelineType: widget.timelineType,extraParams: widget.extraParams).then((timeline){
  //     homeTimeline=timeline.data;
  //     newHomeTimeline=homeTimeline;
  //     oldHomeTimeline=homeTimeline;
  //     for(var weibo in homeTimeline.statuses){
  //       _weiboList.add(weibo);
  //     }
  //     return true;
  //   }).catchError((err){
  //     print(err);
  //     return false;
  //   });
  //   return result;
  // }
  // ///加载更多
  // void loadMoreData()async{
  //   //解释一下，这里的意思是第一次获取更早的微博，最早微博时间线取当前主页时间线
  //   if(oldHomeTimeline.maxId==0){
  //     _refreshController.loadNoData();
  //     return;
  //   }
  //   WeiboProvider.getTimeLine(maxId: oldHomeTimeline.maxId??0,timelineType: widget.timelineType,extraParams: widget.extraParams).then((timeline){
  //     oldHomeTimeline=timeline.data;
  //     if(oldHomeTimeline!=null){
  //       setState(() {
  //         for(var weibo in oldHomeTimeline.statuses){
  //           _weiboList.add(weibo);
  //         }
  //       });
  //       //刷新成功，更新本地缓存
  //       //这里考虑把homeTimeline维护成本地缓存的
  //       WeiboProvider.putIntoWeibosBox(Utils.generateHiveWeibosKey(widget.timelineType, uid), _weiboList);
  //     }
  //     _refreshController.loadComplete();
  //   }).catchError((err){
  //     _refreshController.loadFailed();
  //   });
  // }

  // ///刷新微博
  // void refreshData() async{
  //   var weiboList=<WeiboLite>[];
  //   //之前使用的是weibos的sinceId，发现用过一次后返回的timeLine即weibos的sinceId为0，造成重复叠加，遂使用当前_weibolist的0位weibo的id
  //   //loadMoreData暂时没改，需要测试观察一下
  //   WeiboProvider.getTimeLine(sinceId: _weiboList[0].id??0,timelineType: widget.timelineType,extraParams: widget.extraParams).then((timeline){
  //     newHomeTimeline=timeline.data;
  //     if(newHomeTimeline!=null){
  //       for(var weibo in newHomeTimeline.statuses){
  //         weiboList.add(weibo);
  //       }
  //       setState(() {
  //         _weiboList.insertAll(0, weiboList);
  //       });
  //       //刷新成功，更新本地缓存
  //       //这里考虑把homeTimeline维护成本地缓存的
  //       WeiboProvider.putIntoWeibosBox(Utils.generateHiveWeibosKey(widget.timelineType, uid), _weiboList);
  //     }
  //     _refreshController.refreshCompleted();
  //   }).catchError((err){
  //     _refreshController.refreshFailed();
  //     print(err);
  //   });
  // }
}