import 'api.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

//搜索 containerid 100103


class SearchApi{
  static const String urlBase='https://m.weibo.cn/api/container/getIndex';


  static Future<Map> getSearchRecommend() async{
    var url=urlBase;
    var params={
      'containerid':'231583',
      'page_type':'searchall',
    };
    var res=(await API.get(Utils.formatUrlParams(url, params)));
    return res.data;
  }

  static Future<Map> getSearchResult(String typeId,String str,String pageIndex) async {
    var url=urlBase;
    var firstParam='100103type=$typeId&q=$str&t=0';
    firstParam=Uri.encodeComponent(firstParam);
    var params={
      'containerid':firstParam,
      'page_type':'searchall',
      'page':pageIndex
    };
    url=Utils.formatUrlParams(url, params);
    var res=await API.get(url);
    return res.data;
  }
  

}

class SearchApiType{
  String text;
  String id;
  SearchApiType(this.id,this.text);

  static var user=SearchApiType('3','用户');
  static var all=SearchApiType('1','综合');
  static var follow=SearchApiType('62','关注');
  static var now=SearchApiType('61','实时');
  static var video=SearchApiType('64','视频');
  static var question=SearchApiType('58','问答');
  static var article=SearchApiType('21','文章');
  static var picture=SearchApiType('63','图片');
  static var sameCity=SearchApiType('97','同城');
  static var hot=SearchApiType('60','热门');
  static var topic=SearchApiType('38','话题');
  static var superTopic=SearchApiType('98','超话');
  static var index=SearchApiType('32','主页');

  static List<SearchApiType> allType=[
    all,
    user,
    follow,
    now,
    video,
    picture,
    hot,
  ];
}