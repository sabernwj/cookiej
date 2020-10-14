import 'dart:convert';

import 'package:cookiej/cookiej/model/content.dart';
import 'package:cookiej/cookiej/model/url_info.dart';
import 'package:cookiej/cookiej/net/url_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:hive/hive.dart';

import 'dart:async';

class UrlProvider {
  static Map<String, dynamic> urlInfoRAMCache = new Map();
  static Box _urlInfoBox;

  static Future<void> init() async {
    _urlInfoBox = await Hive.openBox('url_info_box');
    //.registerAdapter(UrlInfoAdapter());
  }

  ///将url信息缓存至内存
  // static Future<void> saveUrlInfoToRAM(List<Content> contents) async {
  //   //传入微博或者评论的内容，提取其中的短链接
  //   var shortUrlList = findUrlFromContents(contents);
  //   //根据短链获取Url内容
  //   if (shortUrlList.length > 0 && shortUrlList.length <= 20) {
  //     var urlsInfoJson = await UrlApi.getUrlsInfo(shortUrlList);

  //     (urlsInfoJson['urls'] as List<dynamic>).forEach((urlInfoJson) {
  //       //将获取到的短链信息存入内存
  //       var urlInfo = UrlInfo.fromJson(urlInfoJson);
  //       urlInfoRAMCache[urlInfo.urlShort] = urlInfo;
  //     });
  //   }
  // }

  ///从微博内容中提取url
  static List<String> findUrlFromContents(List<Content> contents) {
    var shortUrlList = <String>[];
    var reg = new RegExp(Utils.urlRegexStr);
    contents.forEach((content) {
      String text = content.longText == null
          ? content.text
          : content.longText.longTextContent;
      reg
          .allMatches(text)
          .toList()
          //.where((r)=>!urlInfoRAMCache.containsKey(r.group(0)))
          .where((r) => r.group(0).contains('//t.cn/'))
          .forEach((r) => shortUrlList.add(r.group(0)));
    });
    return shortUrlList;
  }

  static ProviderResult<UrlInfo> getUrlInfo(String url) {
    var urlJsonInfo = urlInfoRAMCache[url] ?? _urlInfoBox.get(url);
    if (urlJsonInfo == null) return ProviderResult(null, false);
    var urlInfo;
    try {
      urlInfo = UrlInfo.fromJson(urlJsonInfo);
    } on TypeError {
      try {
        urlInfo = UrlInfo.fromJson(jsonDecode(jsonEncode(urlJsonInfo)));
      } catch (e) {
        print(
            '从hive取urlinfo发生错误${urlJsonInfo == null ? null : urlJsonInfo['url_short']}');
      }
    }
    if (urlInfo != null)
      return ProviderResult(urlInfo, true);
    else
      return ProviderResult(null, false);
  }

  static Future<void> saveUrlInfoToHive(List<Content> contents) async {
    var shortUrlList = findUrlFromContents(contents);
    if (shortUrlList.length > 0 && shortUrlList.length <= 20) {
      var infosJson = await UrlApi.getUrlsInfo(shortUrlList);
      var map = new Map<String, dynamic>();
      (infosJson['urls'] as List<dynamic>).forEach((urlInfoJson) {
        map[urlInfoJson['url_short']] = urlInfoJson;
      });
      // 每次获取批量获取UrlInfo做个临时缓存
      if (contents.length > 1) urlInfoRAMCache = {}..addAll(map);
      await _urlInfoBox.putAll(map);
      print('存入urlinfojson进hive完成');
    }
  }
}
