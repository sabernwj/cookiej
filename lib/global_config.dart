import 'package:flutter/material.dart';

class GlobalConfig{
  static TextStyle grayFontStyle=new TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );

  static Color backGroundColor=new Color.fromARGB(255,241,242,246);
}

enum LinkType{
  Url,
  Topic,
  User
}