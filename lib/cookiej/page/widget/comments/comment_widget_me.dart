import 'package:cookiej/cookiej/model/comment.dart';
import 'package:cookiej/cookiej/page/widget/content_widget.dart';
import 'package:cookiej/cookiej/page/widget/user_icon.dart';
import 'package:cookiej/cookiej/page/widget/user_name_span.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget_mini.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';

class CommentWidgetMe extends StatelessWidget {

  final Comment comment;

  const CommentWidgetMe({Key key,@required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    final _fontSize=_theme.textTheme.bodyText2.fontSize-0.5;
    
    final _hasReply=comment.replyComment!=null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children:[
        Container(
          color: _theme.dialogBackgroundColor,
          padding: EdgeInsets.only(top:8,left:12,right: 12),
          child: Column(
            children:[
              Row(
                children:[
                  SizedBox(
                    width:36,height:36,
                    child:UserIcon(PictureProvider.getPictureFromId(comment.user.iconId))
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:8),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserNameSpan(comment.user.screenName,style: _theme.primaryTextTheme.bodyText2.copyWith(fontSize:_fontSize),),
                        Text(Utils.getDistanceFromNow(comment.createdAt)+'    '+(comment.source??''),style: _theme.primaryTextTheme.overline),
                      ],
                    )
                  )
                ]
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical:8),
                child: ContentWidget(comment,isLightMode:true,textStyle:_theme.textTheme.bodyText2.copyWith(fontSize:_fontSize),),
              ),
            ]
          ),
        ),
        Container(
          color: _hasReply?_theme.unselectedWidgetColor:_theme.dialogBackgroundColor,
          padding: EdgeInsets.only(left:12,right:12,bottom: 12),
          child:Column(
            children:[
              _hasReply
              ?Container(
                alignment: AlignmentDirectional.centerStart,
                padding: EdgeInsets.symmetric(vertical:8),
                child:RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children:[
                      TextSpan(text: '@${comment.replyComment.user.screenName}',style: _theme.textTheme.subtitle2.copyWith(color:_theme.primaryTextTheme.bodyText2.color)),
                      TextSpan(text:':${comment.replyComment.text}',style: _theme.textTheme.subtitle2)
                    ]
                  )
                ),
              )
              :Container(),
              WeiboWidgetMini(weibo: comment.weibo,backgroundColor: _hasReply?_theme.dialogBackgroundColor:null,)
            ]
          )
        )
      ]
    );
  }
}