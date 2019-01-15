import 'package:flutter/material.dart';
import 'weibo.dart';
import '../utils/utils.dart';
import '../global_config.dart';
import 'weibo_text_widget.dart';
import 'weibo_image_widget.dart';

//单条微博的卡片形式

class WeiboWidget extends StatelessWidget {
  final Weibo weibo;
  WeiboWidget(this.weibo);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
          //标题栏
          new Container(
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(weibo.user.avatar_large),
                    radius: 20,
                  ),
                ),
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Text(weibo.user.name,),
                      new Text(Utils.getDistanceFromNow(weibo.created_at),style: GlobalConfig.grayFontStyle)
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(left: 10),
                ),
                //预留一下微博组件标题右边内容
              ],
            ),
          ),
          //微博正文
          new Container(
            child: WeiboTextWidget(text:weibo.text),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 10),
          ),
          //微博正文图片
          new Container(
            child: WeiboImageWidget(weibo),
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 5),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
    );
  }
  int rowImagesCout(imgCount){
    var count=imgCount;
    if(count>=3){
      return 3;
    }else if(count==2){
      return 2;
    }else if(count==1){
      return 1;
    }else{
      return 1;
    }
  }
}