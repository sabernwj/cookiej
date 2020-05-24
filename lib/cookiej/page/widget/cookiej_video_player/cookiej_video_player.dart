
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cookiej/cookiej/model/video_raw.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

import 'cookiej_video_controller_widget.dart';
import 'video_player_control.dart';
import 'video_player_pan.dart';

class CookieJVideoPlayer extends StatefulWidget {

  ///播放路径参数
  final url;
  ///视频来源类型
  final VideoPlayerType type;
  ///播放器尺寸（大于等于视频播放区域）
  final double width;
  final double height;
  /// 视频需要显示的标题
  final String title;

  final VideoRaw videoRaw;

  CookieJVideoPlayer.network({
    Key key,
    @required String url,
    this.width: double.infinity,
    this.height: double.infinity,
    this.title = '',
    this.videoRaw
  })  : type = VideoPlayerType.network,
        url = url,
        super(key: key);

  CookieJVideoPlayer.asset({
    Key key,
    @required String dataSource,
    this.width: double.infinity,
    this.height: double.infinity,
    this.title = '',
    this.videoRaw
  })  : type = VideoPlayerType.asset,
        url = dataSource,
        super(key: key);

  CookieJVideoPlayer.file({
    Key key,
    @required File file,
    this.width: double.infinity, 
    this.height: double.infinity,
    this.title = '',
    this.videoRaw 
  })  : type = VideoPlayerType.file,
        url = file,
        super(key: key);
  CookieJVideoPlayer.videoRaw({
    Key key,
    @required this.videoRaw,
    this.width: double.infinity, 
    this.height: double.infinity,
    this.title = '', 
  }) :type = VideoPlayerType.videoRaw,
      url = videoRaw.data.object.stream.hdUrl??videoRaw.data.object.stream.url,
      super(key:key);

  
  
  @override
  _CookieJVideoPlayerState createState() => _CookieJVideoPlayerState();
}

class _CookieJVideoPlayerState extends State<CookieJVideoPlayer> {
  final GlobalKey<VideoPlayerControlState> _key =
      GlobalKey<VideoPlayerControlState>();

  ///指示video资源是否加载完成，加载完成后会获得总时长和视频长宽比等信息
  bool _videoInit = false;
  bool _videoError = false;
  VideoPlayerController _controller; // video控件管理器

  /// 记录是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  @override
  void initState() {
    super.initState();
    _urlChange(widget.url); // 初始进行一次url加载
    Screen.keepOn(true); // 设置屏幕常亮
  }

  @override
  void didUpdateWidget(CookieJVideoPlayer oldWidget) {
    if (oldWidget.url != widget.url) {
      _urlChange(widget.url); // url变化时重新执行一次url加载
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() async {
    super.dispose();
    if (_controller != null) {
      // _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    Screen.keepOn(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !_isFullScreen,
      bottom: !_isFullScreen,
      left: !_isFullScreen,
      right: !_isFullScreen,
      child: Container(
        width: _isFullScreen ? _window.width : widget.width,
        height: _isFullScreen ? _window.height : widget.height,
        child: _isHadUrl(),
      ),
    );
  }

// 判断是否有url
  Widget _isHadUrl() {
    if (widget.url != null) {
      return CookieJVideoControllerWidget(
        controlkey: _key,
        controller: _controller,
        videoIsInit: _videoInit,
        urlChangeCallBack: _updateUrlForSameVideo,
        title: widget.title,
        videoRaw: widget.videoRaw,
        child: VideoPlayerPan(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: _isVideoInit(),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          '暂无视频信息',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

// 加载url成功时，根据视频比例渲染播放器
  Widget _isVideoInit() {
    if (_videoInit) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else if (_controller != null && _videoError) {
      return Text(
        '加载出错',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
  }
  
  ///同一个视频更换url，即播放进度不变
  void _updateUrlForSameVideo(dynamic url,Duration position) async {
    await _urlChange(url);
    _controller.seekTo(position);
  }

  Future<void> _urlChange(dynamic url) async {
    if (url == null || url == '') return;
    VideoPlayerController tempController;
    if (_controller != null) {
      /// 如果控制器存在，清理掉重新创建
      // _controller.removeListener(_videoListener);
      //_controller.dispose();
      tempController=_controller;
    }
    setState(() {
      /// 重置组件参数
      _videoInit = false;
      _videoError = false;
    });
    if (widget.type == VideoPlayerType.file) {
      _controller = VideoPlayerController.file(url);
    } else if (widget.type == VideoPlayerType.asset) {
      _controller = VideoPlayerController.asset(url);
    } else {
      _controller = VideoPlayerController.network(url);
    }

    /// 加载资源完成时，监听播放进度，并且标记_videoInit=true加载完成
    //_controller.addListener(_videoListener);
    await _controller.initialize();
    // Timer.periodic(Duration(seconds:1), (timer){
    //   _videoListener();
    // });
    setState(() {
      _videoInit = true;
      _videoError = false;
      _controller.play();
    });
    tempController?.dispose();
  }

}

enum VideoPlayerType{
  network,
  asset,
  file,
  videoRaw
}