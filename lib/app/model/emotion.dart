import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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