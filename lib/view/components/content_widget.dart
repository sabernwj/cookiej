import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/config/global_config.dart';
import 'package:cookiej/controller/apiController.dart';
import 'package:cookiej/model/comment.dart';
import 'package:cookiej/model/content.dart';
import 'package:cookiej/controller/cacheController.dart';
import 'package:cookiej/model/extraAPI.dart';
import 'package:cookiej/model/urlInfo.dart';
import 'package:cookiej/model/weibo.dart';
import 'package:cookiej/ultis/utils.dart';

import '../public/webview_with_title.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../controller/emotionsController.dart';
import './text_emotion_widget.dart';
import 'show_image_view.dart';


final urlRegexStr=Utils.urlRegexStr;
final topicRegexStr=Utils.topicRegexStr;
final userRegexStr=Utils.userRegexStr;
final emotionRegexStr=Utils.emotionRegexStr;
final totalRegex=new RegExp("$urlRegexStr|$topicRegexStr|$userRegexStr|$emotionRegexStr");

///用于显示微博或评论中由链接产生的图片视频及其他微博应用
class ConetntWidget extends StatelessWidget {

  final Content content;
  final List<Widget> displayWidgetList=<Widget>[];
  final List<Widget> secondDisplayWidget=<Widget>[];
  final List<DisplayContent> displayContentList;
  ConetntWidget(this.content):displayContentList=analysisContent(content);
  @override
  Widget build(BuildContext context) {
    displayWidgetList.add(factoryTextWidget(context, displayContentList));
    displayWidgetList.addAll(secondDisplayWidget);
    typeAction(context);
    return Container(
      child:Column(
        children: displayWidgetList,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
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
          if(EmotionsController.emotionsMap.containsKey(_singleText)){
            _displayContentList.add(DisplayContent(ContentType.Emotion, _singleText));
          }else{_displayContentList.add(DisplayContent(ContentType.Text,_singleText));}
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
            var urlInfo=CacheController.urlInfoCache[matchs[i].group(0)];
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
                default:
                  displayText='\u{f0c1}未知微博应用';
              }
            }
            _displayContentList.add(DisplayContent(contentType,displayText,info: urlInfo));
          }
        }
      }
    }
    return _displayContentList;
  }

  Widget factoryTextWidget(BuildContext context, List<DisplayContent> displayContentList){
    var listInlineSpan=<InlineSpan>[];
    displayContentList.forEach((displayContent){
      switch(displayContent.type){
        case ContentType.Text:
          listInlineSpan.add(TextSpan(text: displayContent.text,style: GlobalConfig.contentTextStyle));
          break;
        case ContentType.Link:
          listInlineSpan.add(TextSpan(
            text: displayContent.text,
            style: GlobalConfig.contentLinkStyle,
            recognizer: TapGestureRecognizer()
            ..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>WebviewWithTitle(displayContent.info.urlLong))))
            ));
          break;
        case ContentType.Emotion:
          listInlineSpan.add(WidgetSpan(child:WeiboTextEmotionWidget(EmotionsController.emotionsMap[displayContent.text].imageProvider)));
          break;
        case ContentType.Image:
          secondDisplayWidget.add(factoryImagesWidget(context, ApiController.getImgUrlFromId((displayContent.info.annotations[0].object as Collection).picIds)));
          break;
        case ContentType.Video:
          secondDisplayWidget.add(factoryImagesWidget(context, [(displayContent.info.annotations[0].object as Video).image.url.replaceFirst(RegExp(Utils.imgSizeStrFromUrl), ImgSize.thumbnail)]));
          break;
        default:
          listInlineSpan.add(TextSpan(text: displayContent.text,style: GlobalConfig.contentLinkStyle));
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
  Widget factoryImagesWidget(BuildContext context,List<String> imgUrls){
    var imgWidgetList=<Widget>[];
    var imgOnTap=(BuildContext context,List<String> imgUrls,{int index=0}){
      Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowImagesView(imgUrls,currentIndex: index,)));
    };
    Completer<bool> isImgLoadComplete=new Completer();
    if(imgUrls.length==1){
      final imgProvider=CachedNetworkImageProvider(imgUrls[0]);
      imgProvider.resolve(ImageConfiguration()).addListener((ImageStreamListener((ImageInfo info,bool _) async{
        final imgWidth=info.image.width.toDouble();
        final imgHeight=info.image.width.toDouble();
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
                image: CachedNetworkImageProvider(imgUrls[i]),
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

  void typeAction(BuildContext context){
    if(content is Weibo){
      var weibo=content as Weibo;
      if(weibo.picUrls.length>0){
        displayWidgetList.add(factoryImagesWidget(context,weibo.picUrls.map((picUrl)=>picUrl.thumbnailPic.replaceFirst(RegExp(Utils.imgSizeStrFromUrl), ImgSize.bmiddle)).toList()));
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