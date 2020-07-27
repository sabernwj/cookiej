import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/net/search_api.dart';
import 'dart:async';

class SearchProvider{
  static Future<List<String>> getSearchRecommend() async{
    try{
      var res=await SearchApi.getSearchRecommend();
      if(res['ok']!=1) return null;
      List<String> returnList=[];
      List rawList=res['data']['cards'][0]['group'];
      rawList.forEach((element) {
        returnList.add(element['title_sub'].toString());
      });
      return returnList;
    }catch(e){
      return null;
    }
  }

  static Future<List<WeiboLite>> getSearchResult(String keyword,{SearchApiType sType,int pageIndex=0})async{
    sType??=SearchApiType.all;
    var res= await SearchApi.getSearchResult(sType.id, keyword,pageIndex.toString());
    if(res['ok']!=1) return null;
    List rawList=res['data']['cards'];
    List<WeiboLite> weiboList=[];
    rawList.forEach((element) {
      if(element['card_type']==9){
        var weiboLite=WeiboLite.fromJson(element['mblog']);
        weiboList.add(weiboLite);
      }
    });
    return weiboList;
  }
}