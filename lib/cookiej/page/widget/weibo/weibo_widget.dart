
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/widget/content_widget.dart';


//单条微博的卡片形式

class WeiboWidget extends StatelessWidget {
  final WeiboLite weibo;
  WeiboWidget(this.weibo);

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    var returnWidget=Container(
      child:Column(
        children: <Widget>[
          //标题栏
          Row(
            children: <Widget>[
              //头像
              Container(child: CircleAvatar(backgroundImage: PictureProvider.getPictureFromId(weibo.user.iconId),radius: 20)),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(weibo.user.name,),
                    Text(Utils.getDistanceFromNow(weibo.createdAt)+'    '+weibo.source.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),''),style: _theme.primaryTextTheme.overline),
                    // Text(weibo.source.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),''),style: TextStyle(color:Colors.grey,fontSize: 12))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                margin: const EdgeInsets.only(left: 10),
              ),
              //预留一下微博组件标题右边内容
            ],
          ),
          //微博正文
          ContentWidget(weibo)
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
      margin: const EdgeInsets.only(bottom: 10),
      color: _theme.dialogBackgroundColor,
      //color: Colors.white,
    );
    //判断当前微博是否有转发原微博
    if(weibo.retweetedWeibo!=null){
      (returnWidget.child as Column).children.add(GestureDetector(
        child: Container(
          child: ContentWidget(weibo.retweetedWeibo.rWeibo),
          alignment: Alignment.topLeft,
          color: _theme.unselectedWidgetColor,
          //color: Color(0xFFF5F5F5)
          margin: EdgeInsets.only(top:4),
          padding: const EdgeInsets.only(left: 10,top: 6,right: 4,bottom: 10),
        ),
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.retweetedWeibo.rWeibo.id)));
        },
      ));
    }
    //来源转发评论点赞显示
    (returnWidget.child as Column).children.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Expanded(child: Text(weibo.source.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),''),style: TextStyle(color:Colors.grey,fontSize: 12))),
        FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.shareSquare,size: CookieJTextStyle.normalText.fontSize,), label: Text(weibo.repostsCount.toString()),textColor: Colors.grey),
        FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.comments,size: CookieJTextStyle.normalText.fontSize,), label: Text(weibo.commentsCount.toString()),textColor: Colors.grey),
        FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.thumbsUp,size: CookieJTextStyle.normalText.fontSize,), label: Text(weibo.attitudesCount.toString()),textColor: Colors.grey),
      ],
    ));
    return returnWidget;
  }
}