import 'package:cookiej/cookiej/model/content.dart';
import 'package:cookiej/cookiej/model/url_info.dart';
import 'package:cookiej/cookiej/model/weibo.dart';
import 'package:cookiej/cookiej/net/url_api.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'dart:async';

class UrlProvider{
  static Map<String,UrlInfo> urlInfoRAMCache=new Map();

  ///将url信息缓存至内存
  static Future<void> saveUrlInfoToRAM(List<Content> contents) async {
    //传入微博或者评论的内容，提取其中的短链接
    var shortUrlList=<String>[];
    var reg=new RegExp(Utils.urlRegexStr);
    //用于提取短连接的方法
    var findUrl=(content){
      String text=content.longText==null?content.text:content.longText.longTextContent;
      var regList = reg.allMatches(text).toList();
      regList.where((r)=>!urlInfoRAMCache.containsKey(r.group(0))).where((r)=>r.group(0).contains('//t.cn/')).forEach((r)=>shortUrlList.add(r.group(0)));
    };
    //开始提取短链并加入list
    contents.forEach((content){
      findUrl(content);
      if(content is Weibo){
        if(content.retweetedWeibo!=null){
          findUrl(content.retweetedWeibo.rWeibo);
        }
      }
    });
    //根据短链获取Url内容
    if(shortUrlList.length>0 && shortUrlList.length<=20){
      UrlApi.getUrlsInfo(shortUrlList).then((json){
        (json['urls'] as List<dynamic>).forEach((urlInfoJson){
          //将获取到的短链信息存入内存
          var urlInfo= UrlInfo.fromJson(urlInfoJson);
          urlInfoRAMCache[urlInfo.urlShort]=urlInfo;
        });
      });
    }
  }
}