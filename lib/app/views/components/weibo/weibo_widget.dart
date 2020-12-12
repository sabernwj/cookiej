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

  /// 原数据模型
  WeiboLite get model => _model;

  /// 用户昵称
  String get userName => model.user.screenName;

  /// 用户ID
  String get userId => model.user.idstr;

  /// 创建时间
  String get createTimeStr =>
      model.createdAtStr ?? Utils.getDistanceFromNow(model.createdAt);

  /// 来源
  String get source => model.source;

  /// 原始微博文本
  String get rawText => model.longText?.longTextContent ?? model.text;

  /// 图片列表
  List<ImageProvider> get imageList => model.picUrls
      .map((url) => PictureRepository.getPictureFromUrl(url,
          sinaImgSize: SinaImgSize.bmiddle))
      .toList();

  /// 评论数
  int get commentsCount => model.commentsCount;

  /// 点赞数
  int get attitudesCount => model.attitudesCount;

  /// 转发数
  int get repostsCount => model.repostsCount;

  /// 是否存在原微博
  bool get hasReTweetedWeibo => model.retweetedWeibo != null;

  /// 该条微博的原微博
  WeiboWidgetVM get retweetedWeiboWidgetVM =>
      hasReTweetedWeibo ? WeiboWidgetVM(_model.retweetedWeibo) : null;
}
