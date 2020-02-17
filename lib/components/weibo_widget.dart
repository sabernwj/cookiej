import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'weibo.dart';
import '../utils/utils.dart';
import '../pages/public/weibo_page.dart';
import '../global_config.dart';
import 'weibo_text_widget.dart';
import 'weibo_image_widget.dart';

//单条微博的卡片形式

class WeiboWidget extends StatelessWidget {
  final Weibo weibo;
  WeiboWidget(this.weibo);

  @override
  Widget build(BuildContext context) {
    var returnWidget=Container(
      child: new Column(
        children: <Widget>[
          //标题栏
          new Container(
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(weibo.user.avatar_large),
                    radius: 20,
                  ),
                ),
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Text(weibo.user.name,),
                      new Text(Utils.getDistanceFromNow(weibo.created_at),style: TextStyle(fontSize: 12,color: Colors.black54))
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
            child: WeiboTextWidget(text: weibo.longText!=null?weibo.longText.longTextContent:weibo.text),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
    );
    //微博正文图片
    if(weibo.pic_urls.length>0){
      (returnWidget.child as Column).children.add(Container(
          child: WeiboImageWidget(weibo),
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 5),
        )
      );
    }
    //判断当前微博是否有转发原微博
    if(weibo.retweetedWeibo!=null){
      final sourceUser='@'+weibo.retweetedWeibo.rWeibo.user.name+'\n';
      (returnWidget.child as Column).children.add(GestureDetector(
        child: Container(
          child: Column(children: <Widget>[
            WeiboTextWidget(text: sourceUser+weibo.retweetedWeibo.rWeibo.text),
            weibo.retweetedWeibo.rWeibo.pic_urls.length>0?Container(
              child: WeiboImageWidget(weibo.retweetedWeibo.rWeibo),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 5),
            ):Container(),
          ]),
          alignment: Alignment.topLeft,
          color: Color(0xFFF5F5F5),
          margin: EdgeInsets.only(top:4),
          padding: const EdgeInsets.only(left: 10,top: 6,right: 4,bottom: 10),
        ),
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.retweetedWeibo.rWeibo.id)));
        },
      ));
      // (returnWidget.child as Column).children.add(Container(
      //   child: WeiboImageWidget(weibo.retweetedWeibo.rWeibo),
      //   alignment: Alignment.topLeft,
      //   margin: EdgeInsets.only(top:5),
      //   color: Color(0xFFF5F5F5)
      // ));
    }

    return returnWidget;
  }
  // int rowImagesCout(imgCount){
  //   var count=imgCount;
  //   if(count>=3){
  //     return 3;
  //   }else if(count==2){
  //     return 2;
  //   }else if(count==1){
  //     return 1;
  //   }else{
  //     return 1;
  //   }
  // }
}