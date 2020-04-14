import 'package:flutter/material.dart';

class EmotionPanel extends StatelessWidget {

  //显示emotion的Grid，获取方式为该组件从emotionProvider中获得，非传入
  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        TabBarView(
          children: null
        ),
        TabBar(tabs: null)
      ]
    );
  }
}