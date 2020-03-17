
import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/reposts.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/model/weibo.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/model/weibos.dart';
import 'package:cookiej/cookiej/net/weibo_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/provider/url_provider.dart';
import 'package:hive/hive.dart';

class WeiboProvider{

  static LazyBox<Weibos> _weibosBox;
  static Future<void> init() async {
    _weibosBox=await Hive.openLazyBox('weibos_box');
    Hive.registerAdapter(WeibosAdapter());
    Hive.registerAdapter(WeiboLiteAdapter());
    Hive.registerAdapter(UserLiteAdapter());
  }

  static Future<void> putIntoWeibosBox(String uid, Weibos weibos) async{
    _weibosBox.put(uid, weibos);
    print('存储后_weibosBox容量为${weibos.statuses.length}');
    print('$uid 缓存微博成功,sinceId:${weibos.sinceId},maxId:${weibos.maxId}');
    print('从微博列表读取的sinceId:${weibos.statuses[0].id},时间:${weibos.statuses[0].createdAt}');
    print('从微博列表读取的maxId:${weibos.statuses[weibos.statuses.length-1].id},时间:${weibos.statuses[weibos.statuses.length-1].createdAt}');
  
  }

  static Future<ProviderResult<Weibos>> getTimeLine(
    { 
      String uid,
      int sinceId=0,
      int maxId=0,
      WeiboTimelineType timelineType=WeiboTimelineType.Statuses,
      Map<String,String> extraParams
    }
  ) async {
    var result;
    //读取本地缓存的微博
    if(uid!=null){
      var _weibos=await _weibosBox.get(uid);
      if(_weibos!=null){
        print('此时读取_weibosBox容量为${_weibos.statuses.length}');
        return ProviderResult(_weibos,true);
      }
    }
    result= WeiboApi.getTimeLine(sinceId,maxId,timelineType,extraParams)
      .then((json)=>Weibos.fromJson(json))
      .then((weibos) async {
        //如果uid不为空，说明此次调用是由StartloadData发起的，刷新缓存
        if(uid!=null){
          putIntoWeibosBox(uid, weibos);
        }
        await UrlProvider.saveUrlInfoToHive(weibos.statuses);
        return ProviderResult(weibos,true);
      })
      .catchError((e)=>ProviderResult(null,false));
    return result;
  }

  //获取转发的微博
  static Future<ProviderResult<Reposts>> getReposts(int id,{int sinceId=0,int maxId=0}){
    var result;
    result=WeiboApi.getReposts(id,sinceId,maxId)
      .then((json)=>Reposts.fromJson(json))
      .then((repost) async {
        await UrlProvider.saveUrlInfoToHive(repost.reposts);
        return ProviderResult(repost, true);
      })
      .catchError((e)=> ProviderResult(null, false));
    return result;
  }

  ///根据微博ID获取单条微博内容
  static Future<ProviderResult<Weibo>> getStatusesShow(int id){
    var result;
    result=WeiboApi.getStatusesShow(id)
      .then((json)=>Weibo.fromJson(json))
      .then((weibo) async {
        await UrlProvider.saveUrlInfoToHive([weibo]);
        return ProviderResult(weibo,true);
      })
      .catchError((e)=>ProviderResult(null,false));
    return result;
  }

}