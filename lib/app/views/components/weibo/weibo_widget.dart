import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:cookiej/app/views/components/user/user_avatar.dart';
import 'package:cookiej/app/views/components/user/user_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WeiboWidget extends StatelessWidget {
  final WeiboWidgetVM viewModel;
  WeiboWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<WeiboWidgetVM>(
        init: viewModel,
        builder: (vm) {
          return Container(
            child: Column(
              children: <Widget>[
                //标题栏
                Row(
                  children: <Widget>[
                    //头像
                    UserAvatar(
                      user: vm.user,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          UserName(vm.user.screenName,
                              style: theme.primaryTextTheme.bodyText2),
                          Text(vm.createTimeStr,
                              style: theme.primaryTextTheme.overline),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      margin: const EdgeInsets.only(left: 10),
                    ),
                    //预留一下微博组件标题右边内容
                  ],
                ),
                //微博正文
                //ContentWidget(weibo),
                Text(vm.rawText),
                //是否有转发的微博
                if (vm.hasReTweetedWeibo)
                  GestureDetector(
                    child: Container(
                      //child: ContentWidget(vm.retweetedWeiboWidgetVM),
                      child: Text(vm.retweetedWeiboWidgetVM.rawText),
                      alignment: Alignment.topLeft,
                      color: theme.unselectedWidgetColor,
                      //color: Color(0xFFF5F5F5)
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             WeiboPage(weibo.retweetedWeibo.id)));
                    },
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Expanded(child: Text(weibo.source.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),''),style: TextStyle(color:Colors.grey,fontSize: 12))),
                    FlatButton.icon(
                        onPressed: () {
                          //转发
                        },
                        icon: Icon(
                          FontAwesomeIcons.shareSquare,
                        ),
                        label:
                            Text(Utils.formatNumToChineseStr(vm.repostsCount)),
                        textColor: Colors.grey),
                    FlatButton.icon(
                        onPressed: () {
                          // //评论
                          // Future<bool> sendCommentFunction(String sendText) async {
                          //   if (sendText == null || sendText.isEmpty) {
                          //     return false;
                          //   } else {
                          //     try {
                          //       var comment = Comment.fromJson(
                          //           (await CommentApi.createComment(
                          //               weibo.id, sendText)));
                          //       if (comment != null) {
                          //         setState(() {
                          //           weibo.commentsCount++;
                          //           eventBus.fire(
                          //               CommentListviewAddEvent(weibo.id, comment));
                          //           Utils.defaultToast('评论成功');
                          //         });
                          //       }
                          //     } catch (e) {
                          //       print(e);
                          //     }
                          //     return true;
                          //   }
                          // }

                          // showModalBottomSheet(
                          //     context: context,
                          //     builder: (context) => EditReplyWidget(
                          //           hintText: '评论微博...',
                          //           sendCall: sendCommentFunction,
                          //         ));
                        },
                        icon: Icon(
                          FontAwesomeIcons.comments,
                        ),
                        label:
                            Text(Utils.formatNumToChineseStr(vm.commentsCount)),
                        textColor: Colors.grey),
                    FlatButton.icon(
                        onPressed: () {
                          //点赞
                          //WeiboApi.createAttitudes(weibo.id.toString());
                        },
                        icon: Icon(
                          FontAwesomeIcons.thumbsUp,
                          //size: CookieJTextStyle.normalText.fontSize,
                        ),
                        label: Text(
                            Utils.formatNumToChineseStr(vm.attitudesCount)),
                        textColor: Colors.grey),
                  ],
                )
              ],
            ),
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
            color: Theme.of(context).dialogBackgroundColor,
          );
        });
  }
}

class WeiboWidgetVM extends GetxController {
  final WeiboLite _model;
  WeiboWidgetVM(this._model);

  /// 用户
  UserLite get user => _model.user;

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
