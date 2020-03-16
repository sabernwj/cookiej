import 'dart:async';

import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/display_content.dart';
import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/model/content.dart';
import 'package:cookiej/cookiej/model/url_info.dart';
import 'package:cookiej/cookiej/model/weibo.dart';
import 'package:cookiej/cookiej/provider/url_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
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
  final List<Widget> displayWidgetList=<Widget>[];
  final List<Widget> secondDisplayWidget=<Widget>[];
  final List<DisplayContent> displayContentList;
  TextStyle commonTextStyle;
  TextStyle linkTextStyle;
  ///轻模式，不显示多媒体信息，应用链接化
  final bool isLightMode;
  ContentWidget(this.content,{
    this.isLightMode=false,
    }):displayContentList=DisplayContent.analysisContent(content);
  @override
  Widget build(BuildContext context) {
    commonTextStyle=Theme.of(context).textTheme.body1;
    linkTextStyle=Theme.of(context).primaryTextTheme.body1;
    displayWidgetList.add(isLightMode?factoryTextWidgetLight(context, displayContentList):factoryTextWidget(context, displayContentList));
    displayWidgetList.addAll(secondDisplayWidget);
    typeAction(context);
    return Container(
      child:Column(
        children: displayWidgetList,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(top:4),
    );
  }

  ///生成显示的内容部分
  Widget factoryTextWidget(BuildContext context, List<DisplayContent> displayContentList){
    var listInlineSpan=<InlineSpan>[];
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
          secondDisplayWidget.add(factoryImagesWidget(context, [(displayContent.info.annotations[0].object as Video).image.url],sinaImgSize: SinaImgSize.thumbnail));
          break;
        default:
          listInlineSpan.add(TextSpan(text: displayContent.text,style:linkTextStyle));
      }
    });
    if(listInlineSpan.isEmpty){
      return Container();
    }
    return Container(
      child: RichText(
        text: TextSpan(
          children: listInlineSpan
        ),
      ),
      alignment: Alignment.topLeft,
    );
  }
  ///生成显示的内容部分，不带多媒体信息
  Widget factoryTextWidgetLight(BuildContext context,List<DisplayContent> displayContentList){
    var listInlineSpan=<InlineSpan>[];
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
    var imgWidgetList=<Widget>[];
    var imgOnTap=(BuildContext context,List<String> imgUrls,{int index=0}){
      Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowImagesView(imgUrls,currentIndex: index,)));
    };
    Completer<bool> isImgLoadComplete=new Completer();
    if(imgUrls.length==1){
      final imgProvider=PictureProvider.getPictureFromUrl(imgUrls[0],sinaImgSize: sinaImgSize);
      var imgStream=imgProvider.resolve(ImageConfiguration());
      imgStream.completer.addListener((ImageStreamListener((ImageInfo info,bool _) async{
        if(isImgLoadComplete.isCompleted){
          return;
        }
        final imgWidth=info.image.width.toDouble();
        final imgHeight=info.image.height.toDouble();
        final imgWidget=Image(image: imgProvider,fit:BoxFit.cover,width:imgWidth/imgHeight<0.42?200:null);
        imgWidgetList.add(GestureDetector(
          child:LimitedBox(child: imgWidget,maxHeight: 300),
          onTap: (){
            imgOnTap(context,imgUrls);
          }
        ));
        isImgLoadComplete.complete(true);
      })));
    }else if(imgUrls.length>1){
      for(var i=0;i<imgUrls.length;i++){
        imgWidgetList.add(
          GestureDetector(
            child:SizedBox(
              child:Image(
                image: PictureProvider.getPictureFromUrl(imgUrls[i],sinaImgSize: sinaImgSize),
                fit: BoxFit.cover,
              ),
              width: 119,
              height: 119,   
            ),
            onTap: (){
              imgOnTap(context,imgUrls,index:i);
            },
          )
        );
      }
      isImgLoadComplete.complete(true);
    }
    return Container(
      child: FutureBuilder(
        future: isImgLoadComplete.future,
        builder: (context,snaphot){
          if(snaphot.hasData){
            if(snaphot.data==true){
              return Wrap(
                children: imgWidgetList,
                spacing: 5.0,
                runSpacing: 5.0,
              );
            }
          }
          return Text('图片加载中');
        },
      ),
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 5),
    );
  }

  ///判断传入的是微博还是评论，做出不同动作
  void typeAction(BuildContext context){
    //如果是微博，则可能带图片
    if(content is WeiboLite){
      var weibo=content as WeiboLite;
      if(weibo.picUrls.length>0){
        displayWidgetList.add(factoryImagesWidget(context,weibo.picUrls.map((picUrl)=>picUrl).toList(),sinaImgSize: SinaImgSize.bmiddle));
      }
    }
  }
}

