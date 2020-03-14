import 'dart:math';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PictureProvider{
  static final imgUrlPool=API.imgUrlPool;
  static String _currentServer;
  static int _serverUseCount=0;


  static String _getImgServer(){
    if(_currentServer==null || _serverUseCount>200){
      _currentServer=imgUrlPool[Random.secure().nextInt(imgUrlPool.length)];
    }
    _serverUseCount++;
    return _currentServer;
  }

  ///根据图片ID和size参数返回图片
  static ImageProvider getPictureFromId(String id,{String sinaImgSize=SinaImgSize.bmiddle}){

    String url=_getImgServer();
    url='$url$sinaImgSize/$id.jpg';
    return CachedNetworkImageProvider(url);
  }
  ///根据图片ID和size参数返回图片list
  static List<ImageProvider> getPicturesFromIds(List<String> ids,{String sinaImgSize=SinaImgSize.bmiddle}){
    var imgList=<CachedNetworkImageProvider>[];
    String url=_getImgServer();
    ids.forEach((id)=>imgList.add(CachedNetworkImageProvider('$url$sinaImgSize/$id.jpg')));
    return imgList;
  }

  ///根据图片ID返回url
  static String getImgUrlFromId(String id,{String sinaImgSize=SinaImgSize.bmiddle}){
    String url=_getImgServer();
    return '$url$sinaImgSize/$id.jpg';
  }

  static List<String> getImgUrlsFromIds(List<String> ids,{String sinaImgSize=SinaImgSize.bmiddle}){
    var urlList=<String>[];
    String url=_getImgServer();
    ids.forEach((id)=>urlList.add('$url$sinaImgSize/$id.jpg'));
    return urlList;
  }

  static String getImgIdFromUrl(String url){
    return RegExp(Utils.imgIdStrFromUrl).firstMatch(url).group(0);
  }

  ///根据图片Url返回图片
  static ImageProvider getPictureFromUrl(String url,{String sinaImgSize}){
    if(sinaImgSize!=null){
      url=url.replaceFirst(RegExp(Utils.imgSizeStrFromUrlRegStr), sinaImgSize);
    }
    return CachedNetworkImageProvider(url);
  }

}
