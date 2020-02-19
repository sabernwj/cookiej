import 'package:cookiej/controller/cacheController.dart';

import '../public/webview_with_title.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../controller/emotionsController.dart';
import './text_emotion_widget.dart';

const urlRegexStr="((ht|f)tp(s?):\\/\\/|www\\.)(([\\w\\-]+\\.){1,}?([\\w\\-.~]+\\/?)*[\\p{Alnum}.,%_=?&#\\-+()\\[\\]\\*\$~@!:/{};']*)";
const topicRegexStr=r"#[^#]+#";
const userRegexStr=r"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}";
const emotionRegexStr=r"(\[[0-9a-zA-Z\u4e00-\u9fa5]+\])";
final totalRegex=new RegExp("$urlRegexStr|$topicRegexStr|$userRegexStr|$emotionRegexStr");


///通用的显示微博文字内容的组件，处理了各种@以及超链接
class ShowTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  ShowTextWidget({
    Key key,
    this.text,
    this.fontSize=15
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
  ///将微博文字内容格式化后组装返回
  List<InlineSpan> returnFormatResult(String text){
    final list=<InlineSpan>[];
    if(text==null||text.isEmpty){
      return list;
    }
    final matchs=totalRegex.allMatches(text).toList();
    var _texts=text.split(totalRegex);
    for(int i=0;i<_texts.length;i++){
      list.add(TextSpan(text: _texts[i],style: TextStyle(color: Colors.black,fontSize: fontSize)));
      if(i<matchs.length){
        //处理微博中的自定义表情
        var text=matchs[i].group(0);
        if(text.contains(new RegExp(emotionRegexStr))&&EmotionsController.emotionsMap.containsKey(matchs[i].group(0))){
          list.add(WidgetSpan(child:WeiboTextEmotionWidget(EmotionsController.emotionsMap[matchs[i].group(0)].imageProvider)));
        }
        //处理微博中的链接(外部链接以及全文链接，甚至还有高级API的奇怪链接)
        else if(text.contains(new RegExp(urlRegexStr))){
          if(text.contains(new RegExp('http://m.weibo.cn/'))){
            list.add(TextSpan(text: '查看',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: fontSize)));
          }
          else{
            //ApiController.getUrlsInfo([matchs[i].group(0)]);
            list.add(TextSpan(
              text:((){
                var urlInfo=CacheController.urlInfoCache[matchs[i].group(0)];
                if(urlInfo.annotations!=null){
                  if(urlInfo.annotations.length!=0){
                    switch(urlInfo.annotations[0].objectType){
                      case 'place':
                        return '\u{f124}'+urlInfo.annotations[0].object.displayName;
                      case 'video':
                        return '\u{f03d}'+urlInfo.annotations[0].object.displayName;
                      default:
                        return '\u{f0c1}网页链接';
                    }
                  }
                }
                return '\u{f0c1}网页链接';
              }()),
              style: TextStyle(color: Theme.of(context).primaryColor,fontSize: fontSize,fontFamily: 'fontawesome'),
              recognizer:new TapGestureRecognizer()
              ..onTap=(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WebviewWithTitle(matchs[i].group(0))));
            }));
          }
        }
        else{
          list.add(TextSpan(text: matchs[i].group(0),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: fontSize)));
        }
      }
      
    }
    return list;
  }
    return Container(
      child: RichText(
        text: TextSpan(
          children: returnFormatResult(text)
        ),
      ),
      alignment: Alignment.topLeft,
    );
  }
}





