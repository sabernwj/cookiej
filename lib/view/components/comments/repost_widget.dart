import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/config/global_config.dart';
import 'package:cookiej/model/weibo.dart';
import 'package:cookiej/ultis/utils.dart';
import 'package:flutter/material.dart';
import 'package:cookiej/view/components/content_widget.dart';
class RepostWidget extends StatelessWidget {

  final Weibo repost;
  RepostWidget(this.repost);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: <Widget>[
          //标题栏
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(repost.user.avatarLarge),radius: 20),width: 36,height: 36,),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(repost.user.name,style: TextStyle(fontSize: 12),),
                      Text(Utils.getDistanceFromNow(repost.createdAt),style: TextStyle(fontSize: 11,color: Colors.grey[600])),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(left: 10),
                ),
                //预留一下微博组件标题右边内容
              ],
            ),
          ),
          //转发内容正文
          Container(
            child: ContentWidget(repost,fontSize: GlobalConfig.commentFontSize),
            margin: EdgeInsets.only(left:46),
          ),
          
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
    );
  }
}