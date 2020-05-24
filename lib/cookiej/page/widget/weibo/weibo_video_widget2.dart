
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/public/video_page.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
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
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.id)));},
      child:Container(
        color: Theme.of(context).dialogBackgroundColor,
        padding: EdgeInsets.symmetric(vertical:8,horizontal:12),
        height: MediaQuery.of(context).size.width*2/3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Stack(
                    children: <Widget>[
                      Positioned(
                        left: 1.0,
                        top: 1.0,
                        child: Icon(Icons.play_circle_outline,size: 64, color: Colors.black54),
                      ),
                      Icon(Icons.play_circle_outline,size: 64, color: Colors.white),
                    ],
                  ),
                  Material(
                    color:Colors.transparent,
                    child:InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPage(video: videoElement.video)));
                      },
                    )
                  ),
                ]
              )
            ),
            Text(
              videoElement.text,
              maxLines: 2,
            ),
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
                      UserNameSpan(weibo.user.screenName)
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
      )
    );
  }
}