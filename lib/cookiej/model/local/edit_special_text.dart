import 'package:cookiej/cookiej/provider/emotion_provider.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeiboSpecialTextSpanBuilder extends SpecialTextSpanBuilder{

  final BuildContext context;
  WeiboSpecialTextSpanBuilder(this.context);

  @override
  TextSpan build(String data, {TextStyle textStyle, onTap}) {
    var textSpan = super.build(data, textStyle: Theme.of(context).textTheme.bodyText2, onTap: onTap);
    return textSpan;
  }

  @override
  SpecialText createSpecialText(String flag, {TextStyle textStyle, onTap, int index}) {
    
    if(flag==null||flag=='') return null;
    if(isStart(flag, AtText.startKey)){
      return AtText(Theme.of(context).primaryTextTheme.bodyText2, onTap);
    }else if(isStart(flag, EmotionText.startKey)){
      return EmotionText(Theme.of(context).textTheme.bodyText2);
    }else if(isStart(flag, TopicText.startKey)){
      return TopicText(Theme.of(context).primaryTextTheme.bodyText2, onTap);
    }
    return null;
  }
}

///@某人
class AtText extends SpecialText{
  static const String startKey='@';
  static const String endKey=' ';
  final int start;

  AtText(TextStyle textStyle,SpecialTextGestureTapCallback onTap, {this.start}) 
  : super(startKey, endKey, textStyle);
  
  @override
  InlineSpan finishText() {
    final atText=toString();
    var textSpan= TextSpan(
      text: atText,
      style: textStyle,
    );
    return textSpan;
  }
}

///表情
class EmotionText extends SpecialText{
  static const String startKey='[';
  static const String endKey=']';
  final int start;
  EmotionText(TextStyle textStyle, {this.start})
  : super(startKey,endKey,textStyle);

  @override
  InlineSpan finishText(){
    final emotionText=toString();
    var emotionResult=EmotionProvider.getEmotion(emotionText);
    if(emotionResult.success) {
      return ImageSpan(
        emotionResult.data.imageProvider,
        imageWidth: textStyle.fontSize+2,
        imageHeight: textStyle.fontSize+2,
        margin: EdgeInsets.symmetric(horizontal:2),
        actualText: emotionText
      );
    }
    return TextSpan(text:emotionText);
  }
}
///话题
class TopicText extends SpecialText{
  static const startKey='#';
  static const endKey='#';
  final int start;
  TopicText(TextStyle textStyle,SpecialTextGestureTapCallback onTap, {this.start}) 
  : super(startKey, endKey, textStyle);
  @override
  InlineSpan finishText() {
    var textSpan= TextSpan(
      text: toString(),
      style: textStyle,
    );
    return textSpan;
  }
}