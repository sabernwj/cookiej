import 'package:flutter/material.dart';
import '../../config/global_config.dart';

class WeiboTextEmotionWidget extends StatelessWidget {

  final ImageProvider emotionImg;
  const WeiboTextEmotionWidget(this.emotionImg);

  @override
  Widget build(BuildContext context) {
    
    return new Container(
      child: Image(
        image: emotionImg,
        width: GlobalConfig.weiboFontSize+2.5,
        height: GlobalConfig.weiboFontSize+2.5,
      ),
      margin: EdgeInsets.only(left:1,right:1),
    );
  }
}