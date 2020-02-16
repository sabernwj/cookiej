import 'package:flutter/material.dart';

class GlobalConfig{
  static TextStyle grayFontStyle=new TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );

  static Color backGroundColor=new Color.fromARGB(255,241,242,246);

  static double weiboFontSize=_FontSize.middle;

}

class _FontSize{
  static const double small=13;
  static const double middle=15;
  static const double large=17;
}