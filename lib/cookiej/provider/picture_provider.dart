import 'dart:math';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PictureProvider{
  static final imgUrlPool=API.imgUrlPool;
  static String _currentServer;
  static int _serverUseCount=0;

  ///根据图片ID和size参数返回图片
  static ImageProvider getPictureFromId(String id,{String sinaImgSize=SinaImgSize.bmiddle}){
    if(_currentServer==null || _serverUseCount>100){
      _currentServer=imgUrlPool[Random.secure().nextInt(imgUrlPool.length)];
    }
    _serverUseCount++;
    String url=_currentServer;
    url='$url$sinaImgSize/$id.jpg';
    return CachedNetworkImageProvider(url);
  }
  ///根据图片ID和size参数返回图片list
  static List<ImageProvider> getPicturesFromIds(List<String> ids,{String sinaImgSize=SinaImgSize.bmiddle}){
    var imgList=<CachedNetworkImageProvider>[];
    String url=imgUrlPool[Random.secure().nextInt(imgUrlPool.length)];
    ids.forEach((id)=>imgList.add(CachedNetworkImageProvider('$url$sinaImgSize/$id.jpg')));
    return imgList;
  }
  ///根据图片Url返回图片
  static ImageProvider getPictureFromUrl(String url){
    return CachedNetworkImageProvider(url);
  }

}

class SinaImgSize{
  static const String thumbnail='thumbnail';
  static const String bmiddle='bmiddle';
  static const String large='large';
  static const String original='original';
}