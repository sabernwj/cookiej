import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/net/search_api.dart';
import 'dart:async';

import 'package:cookiej/cookiej/provider/url_provider.dart';

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
    dfsMap(rawList,weiboList);
    await UrlProvider.saveUrlInfoToHive(weiboList);
    return weiboList;
  }

  static Future<List<UserLite>> getSearchUserResult(String keyword,{SearchApiType sType,int pageIndex=0}) async{
    if(sType!=SearchApiType.user) return null;
    var res= await SearchApi.getSearchResult(sType.id, keyword,pageIndex.toString());
    if(res['ok']!=1) return null;
    List rawList=[];
    res['data']['cards'].forEach((e){
      if(e['card_type']==11){
        rawList.addAll(e['card_group']);
      }
    });
    List<UserLite> userList=[];
    rawList.forEach((element) {
      if(element['card_type']==10){
        if(element['desc1'].toString().contains('粉丝：')) element['desc1']='';
        element['user']['description']=element['desc1'];
        var userLite=UserLite.fromJson(element['user']);
        userList.add(userLite);
      }
    });
    return userList;
  }

  static void dfsMap(dynamic jsonMap,List list){
    if(jsonMap==null) return;
    if(jsonMap is List){
      jsonMap.forEach((element) {dfsMap(element, list);});
    }else if(jsonMap is Map) {
      if(!jsonMap.containsKey('card_type')) return;
      if(jsonMap['card_type']==9){
        var weiboLite=WeiboLite.fromJson(jsonMap['mblog']);
        list.add(weiboLite);
        return;
      }
      else{
        jsonMap.values.forEach((element) {
          dfsMap(element, list);
        });
      }
    }else{
      return;
    }

  }
}