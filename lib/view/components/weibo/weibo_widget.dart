import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../model/weibo.dart';
import '../../../ultis/utils.dart';
import '../../public/weibo_page.dart';
import '../../../config/global_config.dart';
import '../show_text_widget.dart';
import '../weibo/weibo_image_widget.dart';

//单条微博的卡片形式

class WeiboWidget extends StatelessWidget {
  final Weibo weibo;
  WeiboWidget(this.weibo);

  @override
  Widget build(BuildContext context) {
    var returnWidget=Container(
      child:Column(
        children: <Widget>[
          //标题栏
          Container(
            child: Row(
              children: <Widget>[
                Container(child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(weibo.user.avatarLarge),radius: 20)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(weibo.user.name,),
                      Text(Utils.getDistanceFromNow(weibo.createdAt),style: TextStyle(fontSize: 12,color: Colors.grey[600]))
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(left: 10),
                ),
                //预留一下微博组件标题右边内容
              ],
            ),
          ),
          //微博正文
          Container(
            child: ShowTextWidget(text: weibo.longText!=null?weibo.longText.longTextContent:weibo.text,fontSize: GlobalConfig.weiboFontSize,),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 10),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
    );
    //微博正文图片
    if(weibo.picUrls.length>0){
      (returnWidget.child as Column).children.add(Container(
          child: WeiboImageWidget(weibo),
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 5),
        )
      );
    }
    //判断当前微博是否有转发原微博
    if(weibo.retweetedWeibo!=null){
      final sourceUser='@'+weibo.retweetedWeibo.rWeibo.user.name+'\n';
      (returnWidget.child as Column).children.add(GestureDetector(
        child: Container(
          child: Column(children: <Widget>[
            ShowTextWidget(text: sourceUser+weibo.retweetedWeibo.rWeibo.text,fontSize: GlobalConfig.weiboFontSize,),
            weibo.retweetedWeibo.rWeibo.picUrls.length>0?Container(
              child: WeiboImageWidget(weibo.retweetedWeibo.rWeibo),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 5),
            ):Container(),
          ]),
          alignment: Alignment.topLeft,
          color: Color(0xFFF5F5F5),
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
        Expanded(child: Text(weibo.source.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),''),style: TextStyle(color:Colors.grey,fontSize: 11))),
        FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.shareSquare,size: GlobalConfig.weiboFontSize,), label: Text(weibo.repostsCount.toString()),textColor: Colors.grey,),
        FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.comments,size: GlobalConfig.weiboFontSize,), label: Text(weibo.commentsCount.toString()),textColor: Colors.grey,),
        FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.heart,size: GlobalConfig.weiboFontSize,), label: Text(weibo.attitudesCount.toString()),textColor: Colors.grey,)
      ],
    ));
    return returnWidget;
  }
}