import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/provider/async_view_model.dart';
import 'package:cookiej/app/provider/async_view_widget.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:flutter/material.dart';

class WeiboWidget extends AsyncViewWidget<WeiboWidgetVM> {
  @override
  Widget buildCompleteWidget(BuildContext context, WeiboWidgetVM vm) {
    return Container();
  }
}

class WeiboWidgetVM extends AsyncViewModel {
  final WeiboLite _model;
  WeiboWidgetVM(this._model);

  /// 用户昵称
  String get userName => _model.user.screenName;

  /// 用户ID
  String get userId => _model.user.idstr;

  /// 创建时间
  String get createTimeStr =>
      _model.createdAtStr ?? Utils.getDistanceFromNow(_model.createdAt);

  /// 来源
  String get source => _model.source;

  /// 原始微博文本
  String get rawText => _model.longText?.longTextContent ?? _model.text;

  /// 图片列表
  List<ImageProvider> get imageList => _model.picUrls
      .map((url) => PictureRepository.getPictureFromUrl(url,
          sinaImgSize: SinaImgSize.bmiddle))
      .toList();

  /// 评论数
  int get commentsCount => _model.commentsCount;

  /// 点赞数
  int get attitudesCount => _model.attitudesCount;

  /// 转发数
  int get repostsCount => _model.repostsCount;

  /// 是否存在原微博
  bool get hasReTweetedWeibo => _model.retweetedWeibo != null;

  /// 该条微博的原微博
  WeiboWidgetVM get retweetedWeiboWidgetVM =>
      hasReTweetedWeibo ? WeiboWidgetVM(_model.retweetedWeibo) : null;

  /// 是否点赞此微博
  bool get favorited => _model.favorited;

  void favoriteWeibo() {}

  void commentWeibo() {}
}
