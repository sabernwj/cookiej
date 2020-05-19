import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:async';

class PictureProvider{
  ///均衡发给新浪服务器的图片请求
  static final imgUrlPool=API.imgUrlPool;
  static String _currentServer;
  static int _serverUseCount=0;
  ///记录某ID图片使用哪个服务器的使用记录，才能正确使用根据url缓存的图片
  static Map<String,String> _imgIdServerCache=new Map();
  static Box _imgIdBox;

  static Future<void> init() async {
    _imgIdBox=await Hive.openBox('img_id_box');
    //.registerAdapter(UrlInfoAdapter());
  }


  static String _getImgServer(){
    if(_currentServer==null || _serverUseCount>200){
      _currentServer=imgUrlPool[Random.secure().nextInt(imgUrlPool.length)];
      _serverUseCount=0;
    }
    _serverUseCount++;
    return _currentServer;
  }

  ///根据图片ID和size参数返回图片
  static ImageProvider getPictureFromId(String id,{String sinaImgSize=SinaImgSize.bmiddle}){
    if(id==null||id.isEmpty||id=='null'){
      return ExtendedAssetImageProvider('images/white.jpg');
    }
    String url=getImgUrlFromId(id,sinaImgSize:sinaImgSize);
    return getPictureFromUrl(url);
  }
  ///根据图片ID和size参数返回图片list
  static List<ImageProvider> getPicturesFromIds(List<String> ids,{String sinaImgSize=SinaImgSize.bmiddle}){
    var imgList=<ImageProvider>[];
    var urls=getImgUrlsFromIds(ids,sinaImgSize: sinaImgSize);
    urls.forEach((url)=>imgList.add(getPictureFromUrl(url)));
    return imgList;
  }

  ///根据图片ID返回url
  static String getImgUrlFromId(String id,{String sinaImgSize=SinaImgSize.bmiddle}){
    String baseUrl=_imgIdServerCache[id]??_imgIdBox.get(id)??_getImgServer();
    _imgIdServerCache[id]=baseUrl;
    if(_imgIdServerCache.length>20){
      var cacheClone=Map.from(_imgIdServerCache);
      _imgIdBox.putAll(cacheClone);
      _imgIdServerCache.clear();
    }
    return '$baseUrl$sinaImgSize/$id.jpg';
  }

  static List<String> getImgUrlsFromIds(List<String> ids,{String sinaImgSize=SinaImgSize.bmiddle}){
    var urlList=<String>[];
    String baseUrl=_getImgServer();
    ids.forEach((id){
      urlList.add('${_imgIdServerCache[id]??_imgIdBox.get(id)??baseUrl}$sinaImgSize/$id.jpg');
      _imgIdServerCache[id]=_imgIdServerCache[id]??_imgIdBox.get(id)??baseUrl;
    });
    //缓存到20次存入一次到Hive
    if(_imgIdServerCache.length>20){
      var cacheClone=Map.from(_imgIdServerCache);
      _imgIdBox.putAll(cacheClone);
      _imgIdServerCache.clear();
    }
    return urlList;
  }

  static String getImgIdFromUrl(String url){
    return RegExp(Utils.imgIdStrFromUrl).firstMatch(url).group(0);
  }

  ///根据图片Url返回图片Provider
  static ImageProvider getPictureFromUrl(String url,{String sinaImgSize}){
    if(url==null||url.contains('default')){
      return ExtendedAssetImageProvider('assets/images/white.jpg');
    }
    if(sinaImgSize!=null){
      url=url.replaceFirst(RegExp(Utils.imgSizeStrFromUrlRegStr), sinaImgSize);
    }
    CachedNetworkImageProvider returnImageProvider;
    try{
      returnImageProvider=CachedNetworkImageProvider(url);
    }catch(e){
      print(e);
    }
    
    return returnImageProvider;
  }

  static String changeUrlImgSize(String url,String sinaImgSize){
    return url.replaceAll(RegExp(Utils.imgSizeStrFromUrlRegStr), sinaImgSize);
  }

}
