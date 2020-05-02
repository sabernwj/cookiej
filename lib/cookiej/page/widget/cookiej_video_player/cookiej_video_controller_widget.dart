import 'package:cookiej/cookiej/model/video_raw.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_control.dart';


typedef UrlChangeCallBack<T> = void Function(T url,Duration position);
//typedef Future<void> UrlChangeCallBack (dynamic url,Duration position);
class CookieJVideoControllerWidget extends InheritedWidget{


  final String title;
  final GlobalKey<VideoPlayerControlState> controlkey;
  final Widget child;
  final VideoPlayerController controller;
  final bool videoIsInit;
  final VideoRaw videoRaw;
  final UrlChangeCallBack urlChangeCallBack;

  CookieJVideoControllerWidget({
    this.child,
    this.controlkey,
    this.controller,
    this.title,
    this.videoIsInit,
    this.videoRaw,
    this.urlChangeCallBack
  });

  static CookieJVideoControllerWidget of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<CookieJVideoControllerWidget>();
  }

  @override
  bool updateShouldNotify(CookieJVideoControllerWidget oldWidget) {
    return controller!=oldWidget.controller;
  }
  
}