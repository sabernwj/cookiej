import 'package:cached_network_image/cached_network_image.dart';
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
        children: <Widget>[
          Container(child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(comment.user.avatarLarge),radius: 20)),
          Container(
            child: Column(
              children: <Widget>[
                Text(comment.user.name,),
                Text(Utils.getDistanceFromNow(comment.createdAt),style: TextStyle(fontSize: 12,color: Colors.grey[600]))
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            margin: const EdgeInsets.only(left: 10),
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
