import 'dart:convert';

import 'package:cookiej/app/model/content.dart';
import 'package:cookiej/app/model/url_info.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/utils/utils.dart';

class UrlRepository {
  static final _urlInfoBox = HiveService.urlInfoBox;
  static Map<String, Map> _urlInfoRAMCache = new Map();

  /// 获取本地缓存的urlInfo
  static Future<UrlInfo> getUrlInfo(String url) async {
    var json = _urlInfoRAMCache[url] ?? (await _urlInfoBox.get(url));
    if (json == null) return null;
    try {
      UrlInfo urlInfo = UrlInfo.fromJson(json);
      return urlInfo;
    } on TypeError {
      // 2021年了，还在用土办法解决问题
      UrlInfo urlInfo = UrlInfo.fromJson(jsonDecode(jsonEncode(json)));
      return urlInfo;
    } catch (e) {
      throw AppError(AppErrorType.OtherError, rawErrorInfo: e);
    }
  }

  /// 将UrlInfo存入Hive
  static Future<void> saveUrlInfoToHiveByContents(
      List<Content> contents) async {
    await saveUrlInfoToHive(findUrlFromContents(contents));
  }

  /// 将UrlInfo存入Hive
  static Future<void> saveUrlInfoToHive(List<String> shortUrlList) async {
    try {
      // 从接口获取UrlInfo
      if (shortUrlList == null || shortUrlList.isEmpty) return;
      var url = '/2/short_url/info.json';
      shortUrlList.forEach((shortUrl) {
        shortUrl = shortUrl.replaceAll('#', '');
        shortUrl = Uri.encodeComponent(shortUrl);
        url = Utils.formatUrlParams(url, {'url_short': shortUrl});
      });
      var infos = (await API.get(url)).data['urls'] as List<dynamic>;
      // 解析Json
      var map = Map<String, Map>();
      infos.forEach(
          (urlInfoJson) => map[urlInfoJson['url_short']] = urlInfoJson as Map);
      if (shortUrlList.length > 1) _urlInfoRAMCache = {}..addAll(map);
      // 存入hive
      await _urlInfoBox.putAll(map);
      //print('存入urlinfojson${map.length}条进hive完成');
    } catch (e) {
      throw AppError(AppErrorType.OtherError, rawErrorInfo: e);
    }
  }

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
}
