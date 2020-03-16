import 'package:extended_image/extended_image.dart';
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
    imageProvider=ExtendedNetworkImageProvider(map['url'],cache: true);
  }
}