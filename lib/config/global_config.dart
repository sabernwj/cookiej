import 'package:flutter/material.dart';

class GlobalConfig{

  static TextStyle contentTextStyle=TextStyle(
    fontFamily: 'fontawesome',
    fontSize: weiboFontSize,
    color: Colors.black
  );
  static TextStyle contentLinkStyle=TextStyle(
    fontFamily: 'fontawesome',
    fontSize: weiboFontSize,
    color: Colors.blue
  );
  static TextStyle commentTextStyle=TextStyle(
    fontFamily: 'fontawesome',
    fontSize: commentFontSize,
    color: Colors.black
  );
  static TextStyle commentLinkStyle=TextStyle(
    fontFamily: 'fontawesome',
    fontSize: commentFontSize,
    color: Colors.blue
  );

  static Color backGroundColor=new Color.fromARGB(255,241,242,246);

  static double weiboFontSize=_WeiboFontSize.middle;

  static double commentFontSize=_CommentFontSize.middle;

}

class _WeiboFontSize{
  static const double small=13;
  static const double middle=15;
  static const double large=17;
}

class _CommentFontSize{
  static const double small=12;
  static const double middle=14;
  static const double large=16;
}