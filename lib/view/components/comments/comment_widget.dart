import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/view/components/content_widget.dart';
import 'package:flutter/material.dart';
import '../../../model/comment.dart';
import '../../../ultis/utils.dart';
class CommentWidget extends StatelessWidget{
  
  final Comment comment;
  CommentWidget(this.comment);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(comment.user.avatarLarge),radius: 20)),
          Container(
            child: Column(
              children: <Widget>[
                Text(comment.user.name,style: TextStyle(fontSize: 12),),
                Text(Utils.getDistanceFromNow(comment.createdAt),style: TextStyle(fontSize: 11,color: Colors.grey[600])),
                //评论正文
                ConetntWidget(comment),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            margin: const EdgeInsets.only(left: 10),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
    );
  }
}
