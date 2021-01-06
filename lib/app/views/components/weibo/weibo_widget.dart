import 'package:cookiej/app/model/local/display_content.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:cookiej/app/views/components/base/image_set_widget.dart';
import 'package:cookiej/app/views/components/base/rich_text_content.dart';
import 'package:cookiej/app/views/components/user/user_avatar.dart';
import 'package:cookiej/app/views/components/user/user_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WeiboWidget extends StatelessWidget {
  final WeiboWidgetVM viewModel;

  const WeiboWidget(this.viewModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<WeiboWidgetVM>(
        init: viewModel,
        global: false,
        initState: (_) {
          viewModel.loadDisplayContent();
        },
        builder: (vm) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //标题栏
                Row(
                  children: <Widget>[
                    //头像
                    UserAvatar(
                        user: vm.user, shape: UserAvatarShape.RoundedRectAngle),
                    Container(
                      child: Column(
                        children: <Widget>[
                          UserName(vm.user.screenName,
                              style: theme.primaryTextTheme.bodyText2),
                          Text(vm.createTimeStr,
                              style: theme.textTheme.caption),
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
                RichTextContentWidget(displayContentList: vm.displayContent),
                if (viewModel.imageList.isNotEmpty)
                  ImageSetWidget(imgUrls: viewModel.imageList),
                //是否有转发的微博
                if (vm.hasReTweetedWeibo)
                  GestureDetector(
                    child: Container(
                      //child: ContentWidget(vm.retweetedWeiboWidgetVM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichTextContentWidget(
                              displayContentList:
                                  vm.retweetedWeiboWidgetVM.displayContent),
                          if (viewModel
                              .retweetedWeiboWidgetVM.imageList.isNotEmpty)
                            ImageSetWidget(
                                imgUrls:
                                    viewModel.retweetedWeiboWidgetVM.imageList),
                        ],
                      ),
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
  WeiboWidgetVM(this._model)
      : retweetedWeiboWidgetVM = _model.retweetedWeibo != null
            ? WeiboWidgetVM(_model.retweetedWeibo)
            : null;

  /// ID
  int get id => _model.id;

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
  List<String> get imageList => _model.picUrls ?? [];

  /// 评论数
  int get commentsCount => _model.commentsCount;

  /// 点赞数
  int get attitudesCount => _model.attitudesCount;

  /// 转发数
  int get repostsCount => _model.repostsCount;

  /// 是否存在原微博
  bool get hasReTweetedWeibo => retweetedWeiboWidgetVM != null;

  /// 该条微博的原微博
  WeiboWidgetVM retweetedWeiboWidgetVM;

  /// 是否点赞此微博
  bool get favorited => _model.favorited;

  List<DisplayContent> displayContent = [];

  /// 加载微博富文本内容
  void loadDisplayContent() async {
    displayContent = await DisplayContent.analysisStr(rawText);
    if (hasReTweetedWeibo) {
      retweetedWeiboWidgetVM.displayContent =
          await DisplayContent.analysisStr(retweetedWeiboWidgetVM.rawText);
    }
    update();
  }

  void favoriteWeibo() {}

  void commentWeibo() {}
}
