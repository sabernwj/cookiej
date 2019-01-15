import 'package:flutter/material.dart';
import '../global_config.dart';



final urlRegexStr="(?:^|[\\W])((ht|f)tp(s?):\\/\\/|www\\.)(([\\w\\-]+\\.){1,}?([\\w\\-.~]+\\/?)*[\\p{Alnum}.,%_=?&#\\-+()\\[\\]\\*\$~@!:/{};']*)";
final topicRegexStr=r"#[^#]+#";
final userRegexStr=r"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}";
final totalRegex=new RegExp("$urlRegexStr|$topicRegexStr|$userRegexStr");
class WeiboTextWidget extends StatelessWidget {
  final String text;
  const WeiboTextWidget({
    Key key,
    this.text
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
  ///将微博文字内容格式化后组装返回
  List<TextSpan> returnFormatResult(String text){
    final list=<TextSpan>[];
    if(text==null||text.isEmpty){
      return list;
    }
    final matchs=totalRegex.allMatches(text).toList();
    var _texts=text.split(totalRegex);
    for(int i=0;i<_texts.length;i++){
      list.add(TextSpan(text: _texts[i],style: TextStyle(color: Colors.black)));
      if(i<matchs.length){
        list.add(TextSpan(text: matchs[i].group(0),style: TextStyle(color: Theme.of(context).primaryColor)));
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





