import 'dart:async';

import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model//local/display_content.dart';
import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/public/video_page.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/model/content.dart';
import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:cookiej/cookiej/page/public/webview_with_title.dart';
import 'package:cookiej/cookiej/provider/emotion_provider.dart';
import 'package:cookiej/cookiej/model/collection.dart';

// import 'package:cookiej/controller/apiController.dart';
// import 'package:cookiej/controller/cacheController.dart';




import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'text_emotion_widget.dart';
import 'show_image_view.dart';




///用于显示微博或评论中由链接产生的图片视频及其他微博应用
class ContentWidget extends StatelessWidget {

  final Content content;
  final List<DisplayContent> displayContentList;
  final TextStyle textStyle;
  ///轻模式，不显示多媒体信息，应用链接化
  final bool isLightMode;
  ContentWidget(this.content,{
    this.isLightMode=false, this.textStyle,
    }):displayContentList=DisplayContent.analysisContent(content);
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: getDisplayWidget(context),
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<Widget> getDisplayWidget(BuildContext context){
    if(isLightMode){
      return[factoryTextWidgetLight(context, displayContentList)];
    }else{
      final displayWidgetList= factoryContentWidget(context, displayContentList);
      //如果是微博，则可能带图片
      if(content is WeiboLite){
        var weibo=content as WeiboLite;
        if(weibo.picUrls!=null){
          if(weibo.picUrls.length>0){
            displayWidgetList.add(factoryImagesWidget(context,weibo.picUrls.map((picUrl)=>picUrl).toList(),sinaImgSize: SinaImgSize.bmiddle));
          }
        }

      }
      return displayWidgetList;
    }
  }

  ///生成显示的内容部分
  List<Widget> factoryContentWidget(BuildContext context, List<DisplayContent> displayContentList){
    final returnWidgets=<Widget>[];
    final listInlineSpan=<InlineSpan>[];
    final secondDisplayWidget=<Widget>[];
    var imgWidth=(MediaQuery.of(context).size.width-32)/3;
    var commonTextStyle=Theme.of(context).textTheme.bodyText2.merge(textStyle??TextStyle());
    var linkTextStyle=Theme.of(context).primaryTextTheme.bodyText2.merge(textStyle??TextStyle());
    displayContentList.forEach((displayContent){
      switch(displayContent.type){
        case ContentType.Text:
          listInlineSpan.add(TextSpan(text: displayContent.text,style: commonTextStyle));
          break;
        case ContentType.Link:
          listInlineSpan.add(TextSpan(
            text: displayContent.text,
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()
            ..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>WebviewWithTitle(displayContent.info.urlLong))))
          ));
          break;
        case ContentType.Emotion:
          listInlineSpan.add(WidgetSpan(child:WeiboTextEmotionWidget(EmotionProvider.getEmotion(displayContent.text).data.imageProvider)));
          break;
        case ContentType.User:
          listInlineSpan.add(TextSpan(
            text: displayContent.text,
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()
            ..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage(screenName:displayContent.text.replaceAll(RegExp('@'), '')))))
          ));
          break;
        case ContentType.Image:
          secondDisplayWidget.add(factoryImagesWidget(context, PictureProvider.getImgUrlsFromIds((displayContent.info.annotations[0].object as Collection).picIds),sinaImgSize: SinaImgSize.thumbnail));
          break;
        case ContentType.Video:
          //先展示下视频封面
          var video=(displayContent.info.annotations[0].object as Video);
          secondDisplayWidget.add(
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image(
                  width: imgWidth*1.8,
                  height: imgWidth*1.2,
                  image: PictureProvider.getPictureFromUrl(video.image.url),
                  fit: BoxFit.cover,
                ),
                Icon(
                  Icons.play_circle_outline,
                  size: 48,
                  color: Theme.of(context).accentColor,
                ),
                Positioned.fill(
                  child: Material(
                    color:Colors.transparent,
                    child:InkWell(
                      onTap:() async{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPage(video: video)));
                      }
                    )
                  )
                )
              ],
            ),
          );
          break;
        default:
          listInlineSpan.add(TextSpan(text: displayContent.text,style:linkTextStyle));
      }
    });
    returnWidgets.add(Container(
      child: RichText(
        text: TextSpan(
          children: listInlineSpan
        ),
      ),
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 4,bottom:4),
    ));
    returnWidgets.addAll(secondDisplayWidget);
    return returnWidgets;
  }
  ///生成显示的内容部分，不带多媒体信息
  Widget factoryTextWidgetLight(BuildContext context,List<DisplayContent> displayContentList){
    var listInlineSpan=<InlineSpan>[];
    var commonTextStyle=Theme.of(context).textTheme.bodyText2.merge(textStyle??TextStyle());
    var linkTextStyle=Theme.of(context).primaryTextTheme.bodyText2.merge(textStyle??TextStyle());
    displayContentList.forEach((displayContent){
      switch(displayContent.type){
        case ContentType.Text:
          listInlineSpan.add(TextSpan(text: displayContent.text,style: commonTextStyle));
          break;
        case ContentType.Emotion:
          listInlineSpan.add(WidgetSpan(child:WeiboTextEmotionWidget(EmotionProvider.getEmotion(displayContent.text).data.imageProvider)));
          break;
        case ContentType.User:
          listInlineSpan.add(TextSpan(
            text: displayContent.text,
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()
            ..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage(screenName:displayContent.text.replaceAll(RegExp('@'), '')))))
          ));
          break;
        default:
          listInlineSpan.add(TextSpan(
            text: displayContent.text,
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()
            ..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>WebviewWithTitle(displayContent.info.urlLong))))
            ));
          break;
      }
    });
    return Container(
      child: RichText(
        text: TextSpan(
          children: listInlineSpan
        ),
      ),
      alignment: Alignment.topLeft,
    );
  }
  ///生成图片部分
  Widget factoryImagesWidget(BuildContext context,List<String> imgUrls,{String sinaImgSize=SinaImgSize.bmiddle}){
    var imgWidth=(MediaQuery.of(context).size.width-32)/3;
    
    var imgOnTap=(BuildContext context,List<String> imgUrls,{int index=0}){
      Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowImagesView(imgUrls,currentIndex: index,)));
    };
    if(imgUrls.length==1){
      return GestureDetector(
        child:ConstrainedBox(
          child: Padding(
              child:Image(
              image: PictureProvider.getPictureFromUrl(imgUrls[0],sinaImgSize: sinaImgSize),
              fit:BoxFit.cover,
            ),
            padding: EdgeInsets.only(bottom:6),
          ),
          constraints: BoxConstraints(
            maxHeight:imgWidth*1.5,
            minWidth:imgWidth
          ),
        ),
        onTap: (){
          imgOnTap(context,imgUrls);
        }
      );
    }else if(imgUrls.length>1){
      var imgWidgetList=<Widget>[];
      for(var i=0;i<imgUrls.length;i++){
        imgWidgetList.add(
          GestureDetector(
            child:Image(
              image: PictureProvider.getPictureFromUrl(imgUrls[i],sinaImgSize: sinaImgSize),
              fit: BoxFit.cover,
            ),
            onTap: (){
              imgOnTap(context,imgUrls,index:i);
            },
          )
        );
      }
      return GridView.count(
        crossAxisCount: imgUrls.length<=4?2:3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: imgWidgetList,
      );
    }
    return Container();
  }
}

