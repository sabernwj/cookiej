import 'package:cookiej/cookiej/page/widget/content_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../../model/comment.dart';
class CommentWidget extends StatelessWidget{
  
  final Comment comment;
  CommentWidget(this.comment);
  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    final returnWidget= Container(
      child:Column(
        children: <Widget>[
          //标题栏
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(child: CircleAvatar(backgroundImage:PictureProvider.getPictureFromId(comment.user.iconId)),width: 36,height: 36,),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(comment.user.name,style: _theme.textTheme.subhead,),
                      Text(Utils.getDistanceFromNow(comment.createdAt),style: _theme.primaryTextTheme.overline),
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
            child: ContentWidget(comment),
            margin: EdgeInsets.only(left:46),
          ),
          
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
      margin: const EdgeInsets.only(bottom: 1),
      color: _theme.dialogBackgroundColor,
    );
    //该条评论存在回复的话
    if(comment.commentReplyMap.length>1){
      final displayReplyWidgetList=<Widget>[];
      comment.commentReplyMap.forEach((id,_comment){
        if(id!=comment.id){
          displayReplyWidgetList.add(ContentWidget(_comment,isLightMode: true));
        }
      });
      (returnWidget.child as Column).children.add(Container(
          child: Column(children: displayReplyWidgetList),
          alignment: Alignment.topLeft,
          color: Color.lerp(_theme.dialogBackgroundColor, Colors.black, 0.05),
          margin: EdgeInsets.only(top:4,left: 46),
          padding: const EdgeInsets.only(left: 10,top: 6,right: 4,bottom: 10),
      ));
    }
    return returnWidget;
  }
}
