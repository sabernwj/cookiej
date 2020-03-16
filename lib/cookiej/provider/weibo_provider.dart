
import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/reposts.dart';
import 'package:cookiej/cookiej/model/weibo.dart';
import 'package:cookiej/cookiej/model/weibos.dart';
import 'package:cookiej/cookiej/net/weibo_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/provider/url_provider.dart';

class WeiboProvider{
  static Future<ProviderResult<Weibos>> getTimeLine(
    { 
      int sinceId=0,
      int maxId=0,
      WeiboTimelineType timelineType=WeiboTimelineType.Statuses,
      Map<String,String> extraParams
    }
  ) async {
    var result;
    result= WeiboApi.getTimeLine(sinceId,maxId,timelineType,extraParams)
      .then((json)=>Weibos.fromJson(json))
      .then((weibos) async {
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