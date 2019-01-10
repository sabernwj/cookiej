import 'package:flutter/material.dart';
import 'weibo.dart';
//单条微博的卡片形式

class WeiboWidget extends StatefulWidget {
  Weibo weibo;

  WeiboWidget(this.weibo);
  @override
  _WeiboWidgetState createState() => _WeiboWidgetState();


}

class _WeiboWidgetState extends State<WeiboWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}