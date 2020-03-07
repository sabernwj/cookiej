import 'package:cookiej/model/urlInfo.dart';
import 'package:cookiej/model/weibo.dart';
import '../model/content.dart';
import '../model/weibo.dart';
import '../ultis/utils.dart';
import './apiController.dart';
import 'dart:async';

class CacheController{
  static Map<String,UrlInfo> urlInfoCache=new Map();
  ///将url信息缓存至内存
  static Future<void> cacheUrlInfoToRAM(List<Content> contents) async {
    var shortUrlList=<String>[];
    var reg=new RegExp(Utils.urlRegexStr);
    var findUrl=(content){
      String text=content.longText==null?content.text:content.longText.longTextContent;
      var regList = reg.allMatches(text).toList();
      regList.where((r)=>!urlInfoCache.containsKey(r.group(0))).where((r)=>r.group(0).contains('//t.cn/')).forEach((r)=>shortUrlList.add(r.group(0)));
    };
    contents.forEach((content){
      findUrl(content);
      if(content is Weibo){
        if(content.retweetedWeibo!=null){
          findUrl(content.retweetedWeibo.rWeibo);
        }
      }
    });
    if(shortUrlList.length>0 && shortUrlList.length<=20){
      var urlInfoList =await ApiController.getUrlsInfo(shortUrlList);
      urlInfoList.forEach((urlInfo)=>urlInfoCache[urlInfo.urlShort]=urlInfo);
    }
  }
  
}