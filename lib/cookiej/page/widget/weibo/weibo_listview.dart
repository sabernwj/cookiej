import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/event/notice_audio_event.dart';
import 'package:cookiej/cookiej/event/weibo_listview_refresh_event.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_list_mixin.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './weibo_widget.dart';


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
      eventBus.on<WeiboListViewRefreshEvent>().listen((event) {
        setState(() {
          weiboList=[];
          _refreshController.resetNoData();
          isStartLoadDataComplete=startLoadData();
        });
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
}