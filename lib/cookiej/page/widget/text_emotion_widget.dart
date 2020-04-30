import 'package:flutter/material.dart';
import 'package:cookiej/cookiej/config/style.dart';

import '../../config/style.dart';

class WeiboTextEmotionWidget extends StatelessWidget {

  final ImageProvider emotionImg;
  const WeiboTextEmotionWidget(this.emotionImg);

  @override
  Widget build(BuildContext context) {
    
    return new Container(
      child: Image(
        image: emotionImg,
        width: CookieJTextStyle.normalText.fontSize+2,
        height: CookieJTextStyle.normalText.fontSize+2,
      ),
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }
}