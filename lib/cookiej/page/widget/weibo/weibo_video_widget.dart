import 'dart:ui';

import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/page/public/video_page.dart';

import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:flutter/material.dart';

class WeiboVideoWidget extends StatelessWidget {

  final VideoElement videoElement;

  const WeiboVideoWidget({Key key,@required this.videoElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:12),
      height: MediaQuery.of(context).size.width*2/3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image(
              width: double.infinity,
              height: double.infinity,
              image: PictureProvider.getPictureFromUrl(videoElement.video.image.url),
              fit: BoxFit.cover,
            ),
            Column(
              children:[
                Expanded(
                  child:Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Center(
                        child:Stack(
                          children: <Widget>[
                            //这部分是图标的阴影
                            Positioned(
                              left: 1.0,
                              top: 1.0,
                              child: Icon(Icons.play_circle_outline,size: 64, color: Colors.black54),
                            ),
                            Icon(Icons.play_circle_outline,size: 64, color: Colors.white),
                          ],
                        )
                      ),
                      Material(
                        color:Colors.transparent,
                        child:InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPage(video: videoElement.video)));
                          },
                        )
                      ),
                      
                    ],
                  ),
                ),
                //模糊遮罩
                GestureDetector(
                  onTap: videoElement.onTap,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width/5+2,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.black26
                              ),
                            ),
                          ),
                        ),
                        //文字
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            videoElement.text,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color:Colors.white,fontSize: 14),
                          ),
                          padding:EdgeInsets.all(8)
                        )
                      ],
                    ),
                  ),
                )
              ],
              mainAxisAlignment:MainAxisAlignment.end
            ),
          ],
        )
      ),
    );
  }
}

class VideoElement{
  final String text;
  final Function onTap;
  final Video video;

  VideoElement(this.text, this.video,{this.onTap});
}