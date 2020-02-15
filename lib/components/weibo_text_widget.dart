import 'package:cookiej/global_config.dart';
import 'package:flutter/material.dart';
import '../cache/emotionsController.dart';
import '../components/public/weibo_text_emotion_widget.dart';

final urlRegexStr="(?:^|[\\W])((ht|f)tp(s?):\\/\\/|www\\.)(([\\w\\-]+\\.){1,}?([\\w\\-.~]+\\/?)*[\\p{Alnum}.,%_=?&#\\-+()\\[\\]\\*\$~@!:/{};']*)";
final topicRegexStr=r"#[^#]+#";
final userRegexStr=r"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}";
final emotionRegexStr=r"(\[[0-9a-zA-Z\u4e00-\u9fa5]+\])";
final totalRegex=new RegExp("$urlRegexStr|$topicRegexStr|$userRegexStr|$emotionRegexStr");
class WeiboTextWidget extends StatelessWidget {
  final String text;
  const WeiboTextWidget({
    Key key,
    this.text
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
      list.add(TextSpan(text: _texts[i],style: TextStyle(color: Colors.black,fontSize: GlobalConfig.weiboFontSize)));
      if(i<matchs.length){
        //处理微博中的自定义表情
        var text=matchs[i].group(0);
        if(text.contains(new RegExp(emotionRegexStr))&&EmotionsController.emotionsMap.containsKey(matchs[i].group(0))){
          list.add(WidgetSpan(child:WeiboTextEmotionWidget(EmotionsController.emotionsMap[matchs[i].group(0)].imageProvider)));
        }
        //处理微博中的链接(外部链接以及全文链接，甚至还有高级API的奇怪链接)
        else if(text.contains(new RegExp(urlRegexStr))){
          list.add(TextSpan(text: matchs[i].group(0),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: GlobalConfig.weiboFontSize)));
        }
        else{
          list.add(TextSpan(text: matchs[i].group(0),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: GlobalConfig.weiboFontSize)));
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
    );
  }
}





