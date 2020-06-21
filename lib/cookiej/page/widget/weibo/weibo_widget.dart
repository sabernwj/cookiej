
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/comment_listview_add_event.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/model/comment.dart';
import 'package:cookiej/cookiej/net/comment_api.dart';
import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:cookiej/cookiej/page/widget/edit_reply_widget.dart';
import 'package:cookiej/cookiej/page/widget/user_name_span.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/widget/content_widget.dart';


//单条微博的卡片形式

class WeiboWidget extends StatefulWidget {

  final WeiboLite weibo;
  final bool clicked;
  WeiboWidget(this.weibo,{this.clicked=true});

  @override
  _WeiboWidgetState createState() => _WeiboWidgetState();
}

class _WeiboWidgetState extends State<WeiboWidget> {

  WeiboLite weibo;
  bool clicked;

  @override
  void initState() {
    weibo=widget.weibo;
    clicked=widget.clicked;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    if(weibo.retweetedWeibo!=null) {
      weibo.retweetedWeibo.heroTag=weibo.idstr+weibo.retweetedWeibo.idstr;
    }
    weibo.heroTag=weibo.idstr;
    return GestureDetector(
      child:Container(
        child:Column(
          children: <Widget>[
            //标题栏
            Row(
              children: <Widget>[
                //头像
                GestureDetector(
                  child: CircleAvatar(backgroundImage: PictureProvider.getPictureFromId(weibo.user.iconId,sinaImgSize: SinaImgSize.thumbnail),radius: 20),
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserPage(inputUser:weibo.user))),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      UserNameSpan(weibo.user.name,style: _theme.primaryTextTheme.bodyText2),
                      Text(Utils.getDistanceFromNow(weibo.createdAt)+'    '+weibo.source,style: _theme.primaryTextTheme.overline),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(left: 10),
                ),
                //预留一下微博组件标题右边内容
              ],
            ),
            //微博正文
            ContentWidget(weibo),
            //是否有转发的微博
            weibo.retweetedWeibo!=null
              ?GestureDetector(
                child: Container(
                  child: ContentWidget(weibo.retweetedWeibo),
                  alignment: Alignment.topLeft,
                  color: _theme.unselectedWidgetColor,
                  //color: Color(0xFFF5F5F5)
                  padding: const EdgeInsets.only(left: 12,right: 12,bottom: 4),
                ),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.retweetedWeibo.id)));
                },
              )
              :Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Expanded(child: Text(weibo.source.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),''),style: TextStyle(color:Colors.grey,fontSize: 12))),
                FlatButton.icon(onPressed: (){
                  //转发
                }, icon: Icon(FontAwesomeIcons.shareSquare,size: CookieJTextStyle.normalText.fontSize,), label: Text(Utils.formatNumToChineseStr(weibo.repostsCount)),textColor: Colors.grey),
                FlatButton.icon(onPressed: (){
                  //评论
                  Future<bool> sendCommentFunction(String sendText) async {
                    if(sendText==null||sendText.isEmpty){
                      return false;
                    }else{
                      try{
                        var comment= Comment.fromJson((await CommentApi.createComment(weibo.id, sendText)));
                        if(comment!=null){
                          setState(() {
                            weibo.commentsCount++;
                            eventBus.fire(CommentListviewAddEvent(weibo.id,comment));
                            Utils.defaultToast('评论成功');
                          });
                        }
                      }catch(e){
                        print(e);
                      }
                      return true;
                    }
                  }
                  showModalBottomSheet(context: context, builder: (context)=>EditReplyWidget(hintText: '评论微博...',sendCall: sendCommentFunction,));
                }, icon: Icon(FontAwesomeIcons.comments,size: CookieJTextStyle.normalText.fontSize,), label: Text(Utils.formatNumToChineseStr(weibo.commentsCount)),textColor: Colors.grey),
                FlatButton.icon(onPressed: (){
                  //点赞
                }, icon: Icon(FontAwesomeIcons.thumbsUp,size: CookieJTextStyle.normalText.fontSize,), label: Text(Utils.formatNumToChineseStr(weibo.attitudesCount)),textColor: Colors.grey),
              ],
            )
          ],
        ),
        padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 4),
        color: Theme.of(context).dialogBackgroundColor,
      ),
      onTap: (){
        if(clicked) Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.id)));
      },
    );
  }
  
}