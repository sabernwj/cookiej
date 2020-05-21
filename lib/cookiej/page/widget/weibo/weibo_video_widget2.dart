import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/widget/content_widget.dart';
import 'package:cookiej/cookiej/page/widget/user_icon.dart';
import 'package:cookiej/cookiej/page/widget/user_name_span.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_video_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeiboVideoWidget2 extends StatelessWidget {

  final VideoElement videoElement;
  final WeiboLite weibo;

  const WeiboVideoWidget2({Key key,@required this.videoElement,@required this.weibo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      padding: EdgeInsets.symmetric(vertical:8,horizontal:12),
      height: MediaQuery.of(context).size.width*2/3,
      child: Column(
        children:[
          Expanded(
            child:Stack(
              alignment: Alignment.center,
              children:[
                Image(
                  width: double.infinity,
                  height: double.infinity,
                  image: PictureProvider.getPictureFromUrl(videoElement.video.image.url),
                  fit: BoxFit.cover,
                ),
                Icon(
                  Icons.play_circle_outline,
                  size: 64,
                  color: Colors.white,
                ),
              ]
            )
          ),
          ContentWidget(weibo,maxLines:2,isLightMode:true),
          Padding(
            padding: EdgeInsets.symmetric(vertical:6),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children:[
                    SizedBox(
                      width:36,
                      height:36,
                      child:UserIcon(
                        PictureProvider.getPictureFromId(weibo.user.iconId),
                        user: weibo.user,
                      )
                    ),
                    Container(width: 6,),
                    UserNameSpan(weibo.user.screenName,style: Theme.of(context).textTheme.bodyText1,)
                  ]
                ),
                Material(
                  color:Colors.transparent,
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap:(){},
                        child:Row(
                          children:[
                            Icon(FontAwesomeIcons.heart,size: 16,color:Colors.grey),
                            Container(width: 4,),
                            Text(Utils.formatNumToChineseStr(weibo.commentsCount),style: TextStyle(color:Colors.grey),)
                          ]
                        )
                      ),
                      Container(width: 16,),
                      InkWell(
                        onTap:(){},
                        child:Row(
                          children:[
                            Icon(FontAwesomeIcons.commentDots,size: 16,color:Colors.grey),
                            Container(width: 4,),
                            Text(Utils.formatNumToChineseStr(weibo.commentsCount),style: TextStyle(color:Colors.grey),)
                          ]
                        )
                      )
                    ]
                  )
                )
              ],
            )
          )
        ]
      ),
    );
  }
}