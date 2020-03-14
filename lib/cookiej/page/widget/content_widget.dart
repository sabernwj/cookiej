import 'dart:async';

import 'package:cookiej/cookiej/config/config.dart';
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


final urlRegexStr=Utils.urlRegexStr;
final topicRegexStr=Utils.topicRegexStr;
final userRegexStr=Utils.userRegexStr;
final emotionRegexStr=Utils.emotionRegexStr;
final totalRegex=new RegExp("$urlRegexStr|$topicRegexStr|$userRegexStr|$emotionRegexStr");

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
    }):displayContentList=analysisContent(content);
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

  ///分析text成分，是否包含图片视频，链接内容等等
  static List<DisplayContent> analysisContent(Content content){
    //文本分析
    var _text=content.longText!=null?content.longText.longTextContent:content.text;
    final matchs=totalRegex.allMatches(_text).toList();
    var textsList=_text.split(totalRegex);
    var _displayContentList=<DisplayContent>[];
    for(int i=0;i<textsList.length;i++){
      //添加普通文字
      if(textsList[i].trim().isNotEmpty){
        _displayContentList.add(DisplayContent(ContentType.Text, textsList[i]));
      }
      //添加普通文字之外的东西
      if(i<matchs.length){
        var _singleText=matchs[i].group(0);
        //Emotion表情
        if(_singleText.contains(RegExp(emotionRegexStr))){
          EmotionProvider.getEmotion(_singleText).success
            ?_displayContentList.add(DisplayContent(ContentType.Emotion, _singleText))
            :_displayContentList.add(DisplayContent(ContentType.Text,_singleText));
          continue;
        }
        //@用户昵称
        if(_singleText.contains(RegExp(userRegexStr))){
          _displayContentList.add(DisplayContent(ContentType.User,_singleText));
          continue;
        }
        //话题
        if(_singleText.contains(RegExp(topicRegexStr))){
          _displayContentList.add(DisplayContent(ContentType.Topic,_singleText));
        }
        //url链接
        if(_singleText.contains(RegExp(urlRegexStr))){
          //微博全文，else的都是短链接
          if(_singleText.contains(RegExp('http://m.weibo.cn/'))){
            _displayContentList.add(DisplayContent(ContentType.WeiboWebLink,'查看'));
          }
          else{
            var urlInfo=UrlProvider.urlInfoRAMCache[_singleText]??UrlInfo(annotations: []);
            var displayText='\u{f0c1}网页链接';
            var contentType=ContentType.Link;
            if(urlInfo.annotations.length!=0){
              switch(urlInfo.annotations[0].objectType){
                case 'place':
                  displayText='\u{f124}'+urlInfo.annotations[0].object.displayName;
                  contentType=ContentType.Place;
                  break;
                case 'video':
                  displayText='\u{f03d}'+urlInfo.annotations[0].object.displayName;
                  contentType=ContentType.Video;
                  break;
                case 'collection':
                  displayText=urlInfo.annotations[0].object.displayName;
                  contentType=ContentType.Image;
                  break;
                case 'webpage':
                  contentType=ContentType.Link;
                  break;
                default:
                  displayText='\u{f18a}未知微博应用';
              }
            }
            _displayContentList.add(DisplayContent(contentType,displayText,info: urlInfo));
          }
        }
      }
    }
    return _displayContentList;
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
      imgProvider.resolve(ImageConfiguration()).addListener((ImageStreamListener((ImageInfo info,bool _) async{
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
        displayWidgetList.add(factoryImagesWidget(context,weibo.picUrls.map((picUrl)=>picUrl.thumbnailPic).toList(),sinaImgSize: SinaImgSize.bmiddle));
      }
    }
  }
}

class DisplayContent{
  final ContentType type;
  final String text;
  final UrlInfo info;
  DisplayContent(this.type,this.text,{this.info});
}
enum ContentType{
  Text,
  WeiboWebLink,
  Link,
  User,
  Emotion,
  Image,
  Video,
  Reply,
  Place,
  Topic
}