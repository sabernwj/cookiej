import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/event/string_msg_event.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/model/weibos.dart';
import 'package:cookiej/cookiej/provider/weibo_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

mixin WeiboListMixin{
  Weibos homeTimeline;
  Weibos oldHomeTimeline;
  Weibos newHomeTimeline;
  ///即当前显示在页面上的weiboList
  var weiboList=<WeiboLite>[];
  Future<WeiboListStatus> isStartLoadDataComplete;
  WeiboTimelineType timelineType;
  Map<String,String> extraParams;
  String groupId;
  ///本地uid，仅用于需要通过该uid缓存微博时使用
  String localUid;
  
  ///必须在mix此类的widget中首先执行
  void weiboListInit(WeiboTimelineType timelineType,{Map<String,String> extraParams,String groupId,String uid}){
    this.timelineType=timelineType;
    this.extraParams=extraParams;
    this.groupId=groupId;
  }

  ///开始获取微博
  ///(目前从网络获取，可添加从本地缓存中读取)
  Future<WeiboListStatus> startLoadData() async{
    var result=WeiboProvider.getTimeLine(localUid: localUid,timelineType: timelineType,extraParams: extraParams).then((timeline){
      homeTimeline=timeline.data;
      newHomeTimeline=homeTimeline;
      oldHomeTimeline=homeTimeline;
      for(var weibo in homeTimeline.statuses){
        weiboList.add(weibo);
      }
      return WeiboListStatus.complete;
    }).catchError((err){
      print(err);
      return WeiboListStatus.failed;
    });
    return result;
  }
  ///加载更多
  Future<WeiboListStatus> loadMoreData()async{
    //解释一下，这里的意思是第一次获取更早的微博，最早微博时间线取当前主页时间线
    if(oldHomeTimeline.maxId==0||oldHomeTimeline.maxId==null){
      return WeiboListStatus.nodata;
    }
    return WeiboProvider.getTimeLine(maxId: oldHomeTimeline.maxId??0,timelineType: timelineType,extraParams: extraParams).then((timeline){
      oldHomeTimeline=timeline.data;
      if(oldHomeTimeline!=null){
        var ids= weiboList.map((weiboLite) => weiboLite.id);
        for(var weibo in oldHomeTimeline.statuses){
          if(!ids.contains(weibo.id)) weiboList.add(weibo);
        }
        //刷新成功，更新本地缓存
        //这里考虑把homeTimeline维护成本地缓存的
        if(localUid!=null) WeiboProvider.putIntoWeibosBox(Utils.generateHiveWeibosKey(timelineType, localUid), weiboList);
      }
      return WeiboListStatus.complete;
    }).catchError((err){
      return WeiboListStatus.failed;
    });
  }

  ///刷新微博
  Future<WeiboListStatus> refreshData() async{
    var tempList=<WeiboLite>[];
    //之前使用的是weibos的sinceId，发现用过一次后返回的timeLine即weibos的sinceId为0，造成重复叠加，遂使用当前_weibolist的0位weibo的id
    //loadMoreData暂时没改，需要测试观察一下
    return WeiboProvider.getTimeLine(sinceId: weiboList[0].id??0,timelineType: timelineType,extraParams: extraParams).then((timeline){
      newHomeTimeline=timeline.data;
      if(newHomeTimeline!=null){
        var ids= weiboList.map((weiboLite) => weiboLite.id);
        for(var weibo in newHomeTimeline.statuses){
          if(!ids.contains(weibo.id)) tempList.add(weibo);
        }
        weiboList.insertAll(0, tempList);
        //刷新成功，更新本地缓存
        //这里考虑把homeTimeline维护成本地缓存的
        if(localUid!=null){
          eventBus.fire(StringMsgEvent('${newHomeTimeline.statuses.length}条新的微博'));
          WeiboProvider.putIntoWeibosBox(Utils.generateHiveWeibosKey(timelineType, localUid), weiboList);
        }
      }
      return WeiboListStatus.complete;
    }).catchError((err){
      print(err);
      return WeiboListStatus.failed;
    });
  }
}

enum WeiboListStatus{
  complete,
  failed,
  nodata
}