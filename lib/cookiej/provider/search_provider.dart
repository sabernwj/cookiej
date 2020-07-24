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
}