import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/utils/utils.dart';

class WeiboApi{
  ///公共微博
  static const String _public='/2/statuses/public_timeline.json';
  ///关注用户的微博
  static const String _home='/2/statuses/home_timeline.json';
  ///好友圈(双向关注)微博
  static const String _bilateral='/2/statuses/bilateral_timeline.json';
  ///某个用户的全部微博
  static const String _user='/2/statuses/user_timeline.json';
  ///转发的微博
  static const String _repost='/2/statuses/repost_timeline.json';
  ///单挑微博内容
  static const String _weibo='/2/statuses/show.json';


  ///获取微博列表
  static Future<Map> getTimeLine(int sinceId,int maxId,WeiboTimelineType timelineType,Map<String,String> extraParams) async {
    // Future<Weibos> returnTimeline;
    var url=API.baseUrl;
    switch (timelineType){
      case WeiboTimelineType.Public:
        url+=_public;
        break;
      case WeiboTimelineType.Statuses:
        url+=_home;
        break;
      case WeiboTimelineType.Bilateral:
        url+=_bilateral;
        break;
      case WeiboTimelineType.User:
        url+=_user;
        break;
      default:
        return null;
    }
    var params={
      "since_id":sinceId.toString(),
      "max_id":maxId.toString()
    };
    if(extraParams!=null){
      params.addAll(extraParams);
    }
    final result=await API.httpClient.get(Utils.formatUrlParams(url, params));
    return result.data;
    // return result.then((result) async {
    //   final weibos=Weibos.fromJson(result.data);
    //   //await CacheController.cacheUrlInfoToRAM(weibos.statuses);
    //   return weibos;
    // }).catchError((e){
    //   print(e.response.data);
    //   return null;
    // });
  }
  
  ///获取转发的微博
  static Future<Map> getReposts(int id,int sinceId,int maxId) async {
    var url=API.baseUrl+ _repost;
    var params={
      "since_id":sinceId.toString(),
      "max_id":maxId.toString(),
      'id':id.toString()
    };
    final result=await API.httpClient.get(Utils.formatUrlParams(url, params));
    return result.data;
    // return result.then((result) async {
    //   final repost=Reposts.fromJson(result.data);
    //   await CacheController.cacheUrlInfoToRAM(repost.reposts);
    //   return repost;
    // }).catchError((e){
    //   print(e.response.data);
    //   return null;
    // });
  }

  ///根据微博ID获取单条微博内容
  static Future<Map> getStatusesShow(int id) async{
    var url=API.baseUrl+_weibo;
    var params={
      'id':id.toString(),
      'isGetLongText':'1'
    };

    return (await API.httpClient.get(Utils.formatUrlParams(url, params))).data;

  }
}