import 'dart:convert';

import 'package:cookiej/cookiej/model/content.dart';
import 'package:cookiej/cookiej/model/url_info.dart';
import 'package:cookiej/cookiej/net/url_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:hive/hive.dart';

import 'dart:async';

class UrlProvider{
  //static Map<String,UrlInfo> urlInfoRAMCache=new Map();
  static Box<String> _urlInfoBox;

  static Future<void> init() async {
    _urlInfoBox=await Hive.openBox<String>('url_info_box');
    //.registerAdapter(UrlInfoAdapter());
  }
  ///将url信息缓存至内存
  // static Future<void> saveUrlInfoToRAM(List<Content> contents) async {
  //   //传入微博或者评论的内容，提取其中的短链接
  //   var shortUrlList=<String>[];
  //   var reg=new RegExp(Utils.urlRegexStr);
  //   //用于提取短连接的方法
  //   var findUrl=(content){
  //     String text=content.longText==null?content.text:content.longText.longTextContent;
  //     var regList = reg.allMatches(text).toList();
  //     regList.where((r)=>!urlInfoRAMCache.containsKey(r.group(0))).where((r)=>r.group(0).contains('//t.cn/')).forEach((r)=>shortUrlList.add(r.group(0)));
  //   };
  //   //开始提取短链并加入list
  //   contents.forEach((content){
  //     findUrl(content);
  //     if(content is Weibo){
  //       if(content.retweetedWeibo!=null){
  //         findUrl(content.retweetedWeibo);
  //       }
  //     }
  //   });
  //   //根据短链获取Url内容
  //   if(shortUrlList.length>0 && shortUrlList.length<=20){
  //     UrlApi.getUrlsInfo(shortUrlList).then((json){
  //       (json['urls'] as List<dynamic>).forEach((urlInfoJson){
  //         //将获取到的短链信息存入内存
  //         var urlInfo= UrlInfo.fromJson(urlInfoJson);
  //         urlInfoRAMCache[urlInfo.urlShort]=urlInfo;
  //       });
  //     });
  //   }
  // }

  static List<String> findUrlFromContents(List<Content> contents){
    var shortUrlList=<String>[];
    var reg=new RegExp(Utils.urlRegexStr);
    contents.forEach((content){
      String text=content.longText==null?content.text:content.longText.longTextContent;
      reg.allMatches(text).toList()
        //.where((r)=>!urlInfoRAMCache.containsKey(r.group(0)))
        .where((r)=>r.group(0).contains('//t.cn/'))
        .forEach((r)=>shortUrlList.add(r.group(0)));
    });
    return shortUrlList;
  }

  static ProviderResult<UrlInfo> getUrlInfo(String url) {
    var urlJsonStr=_urlInfoBox.get(url);
      // ??UrlApi.getUrlsInfo([url]).then((json){
      //   _urlInfoBox.put(url, json['urls'][0]);
      //   return json['urls'][0];
      // }).catchError((e)=>null);
    if(urlJsonStr!=null) return ProviderResult(UrlInfo.fromJson(json.decode(urlJsonStr)), true);
    else return ProviderResult(null, false);
  }

  static Future<void> saveUrlInfoToHive(List<Content> contents) async{
    var shortUrlList=findUrlFromContents(contents);
    if(shortUrlList.length>0 && shortUrlList.length<=20){
      
      UrlApi.getUrlsInfo(shortUrlList).then((infosJson) async {
        var map=new Map<dynamic,String>();
        (infosJson['urls'] as List<dynamic>).forEach((urlInfoJson){
          //将获取到的短链信息存入内存
          map[urlInfoJson['url_short']]=json.encode(urlInfoJson);
        });
        await _urlInfoBox.putAll(map);
      });
    }
  }
}
