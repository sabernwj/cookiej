import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/config/global_config.dart';
import 'package:cookiej/view/components/content_widget.dart';
import 'package:flutter/material.dart';
import '../../../model/comment.dart';
import '../../../ultis/utils.dart';
class CommentWidget extends StatelessWidget{
  
  final Comment comment;
  CommentWidget(this.comment);
  @override
  Widget build(BuildContext context) {
    final returnWidget= Container(
      child:Column(
        children: <Widget>[
          //标题栏
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(comment.user.avatarLarge),radius: 20),width: 36,height: 36,),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(comment.user.name,style: TextStyle(fontSize: 12),),
                      Text(Utils.getDistanceFromNow(comment.createdAt),style: TextStyle(fontSize: 11,color: Colors.grey[600])),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(left: 10),
                ),
                //预留一下微博组件标题右边内容
              ],
            ),
          ),
          //评论正文
          Container(
            child: ContentWidget(comment,fontSize: GlobalConfig.commentFontSize,),
            margin: EdgeInsets.only(left:46),
          ),
          
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
    );
    //该条评论存在回复的话
    if(comment.commentReplyMap.length>1){
      final displayReplyWidgetList=<Widget>[];
      comment.commentReplyMap.forEach((id,_comment){
        if(id!=comment.id){
          displayReplyWidgetList.add(ContentWidget(_comment,isLightMode: true,fontSize: GlobalConfig.commentFontSize));
        }
      });
      (returnWidget.child as Column).children.add(Container(
          child: Column(children: displayReplyWidgetList),
          alignment: Alignment.topLeft,
          color: Color(0xFFF5F5F5),
          margin: EdgeInsets.only(top:4,left: 46),
          padding: const EdgeInsets.only(left: 10,top: 6,right: 4,bottom: 10),
      ));
    }
    return returnWidget;
  }
}
