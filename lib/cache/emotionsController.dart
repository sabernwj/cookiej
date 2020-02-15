import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../utils/httpController.dart';

class EmotionsController{
  static Map<String,Emotion> emotionsMap=new Map();

  static Future<List<Map>> downloadEmotions() async{
    return await HttpController.getEmotions();
  }

  static void loadEmotions() async{
    final mapList=await downloadEmotions();
    mapList.forEach((map)=>emotionsMap[map['phrase']]=Emotion.fromMap(map));
  }
}

class Emotion{
  String phrase;
  String url;
  String category;
  bool hot;
  bool common;
  ImageProvider imageProvider; 

  Emotion.fromMap(map){
    phrase=map['phrase'];
    url=map['url'];
    category=map['category'];
    hot=map['hot'];
    common=map['common'];
    imageProvider=CachedNetworkImageProvider(map['url']);
  }
}