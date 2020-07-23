import 'api.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

//搜索 containerid 100103


class SearchApi{
  static const String searchRecommend='https://m.weibo.cn/api/container/getIndex?containerid=231583&page_type=searchall';
  static const String urlBase='https://m.weibo.cn/api/container/getIndex?containerid=100103';

  static Future<Map> getSearchResult(String typeId,String str,{String pageIndex='1'}){
    var firstParam='100103type=$typeId&q=$str&t=0';
    firstParam=Uri.encodeComponent(firstParam);
    var params={
      'containerid':firstParam,
      'page_type':'searcg_all',
      'page':pageIndex
    };
  }
  

}

class SearchApiType{
  static String user='3';
  static String all='1';
  static String follow='62';
  static String now='61';
  static String video='64';
  static String question='58';
  static String article='21';
  static String picture='63';
  static String sameCity='97';
  static String hot='60';
  static String topic='38';
  static String superTopic='98';
  static String index='32';
}