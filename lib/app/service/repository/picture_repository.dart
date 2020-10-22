import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PictureRepository {
  /// 均衡发给新浪服务器的图片请求
  static final imgUrlPool = Config.imgBaseUrlPool;
  static String _currentServer;
  static int _serverUseCount = 0;

  /// 记录某ID图片使用哪个服务器的使用记录，才能正确使用根据url缓存的图片
  static Map<String, String> _imgIdServerCache = new Map();
  static Box<String> _pictureServerBox = HiveService.pictureServerBox;

  static String _getImgServer() {
    if (_currentServer == null || _serverUseCount > 200) {
      _currentServer = imgUrlPool[Random.secure().nextInt(imgUrlPool.length)];
      _serverUseCount = 0;
    }
    _serverUseCount++;
    return _currentServer;
  }

  /// 根据图片ID和size参数返回图片
  static ImageProvider getPictureFromId(String id,
      {String sinaImgSize = SinaImgSize.bmiddle}) {
    if (id == null || id.isEmpty || id == 'null') {
      return ExtendedAssetImageProvider('assets/images/white.jpg');
    }
    String url = getImgUrlFromId(id, sinaImgSize: sinaImgSize);
    return getPictureFromUrl(url);
  }

  /// 根据图片ID和size参数返回图片list
  static List<ImageProvider> getPicturesFromIds(List<String> ids,
      {String sinaImgSize = SinaImgSize.bmiddle}) {
    var imgList = <ImageProvider>[];
    var urls = getImgUrlsFromIds(ids, sinaImgSize: sinaImgSize);
    urls.forEach((url) => imgList.add(getPictureFromUrl(url)));
    return imgList;
  }

  /// 根据图片ID返回url
  static String getImgUrlFromId(String id,
      {String sinaImgSize = SinaImgSize.bmiddle}) {
    if (id == null) id = id.toString();

    //从内存/hive/随机服务器取地址
    String baseUrl =
        _imgIdServerCache[id] ?? _pictureServerBox.get(id) ?? _getImgServer();
    _imgIdServerCache[id] = baseUrl;
    if (_imgIdServerCache.length > 50) {
      var cacheClone = Map<dynamic, String>.from(_imgIdServerCache);
      _pictureServerBox.putAll(cacheClone);
      _imgIdServerCache.clear();
    }
    return '$baseUrl$sinaImgSize/$id.jpg';
  }

  static List<String> getImgUrlsFromIds(List<String> ids,
          {String sinaImgSize = SinaImgSize.bmiddle}) =>
      ids.map((id) => getImgUrlFromId(id));

  /// 从url中提取id
  static String getImgIdFromUrl(String url) =>
      RegExp(Utils.imgIdStrFromUrl).firstMatch(url).group(0);

  /// 根据图片Url返回图片Provider
  static ImageProvider getPictureFromUrl(String url, {String sinaImgSize}) {
    if (url == null || url.contains('default') || url.contains('null')) {
      return ExtendedAssetImageProvider('assets/images/white.jpg');
    }
    if (sinaImgSize != null) {
      url =
          url.replaceFirst(RegExp(Utils.imgSizeStrFromUrlRegStr), sinaImgSize);
    }
    CachedNetworkImageProvider returnImageProvider;

    returnImageProvider = CachedNetworkImageProvider(url);

    return returnImageProvider;
  }

  /// 更改url的size
  static String changeUrlImgSize(String url, String sinaImgSize) =>
      url.replaceAll(RegExp(Utils.imgSizeStrFromUrlRegStr), sinaImgSize);
}
