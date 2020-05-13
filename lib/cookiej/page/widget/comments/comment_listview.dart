
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/model/comment.dart';
import 'package:cookiej/cookiej/model/comments.dart';
import 'package:cookiej/cookiej/page/widget/comments/comment_widget.dart';
import 'package:cookiej/cookiej/page/widget/comments/repost_listview.dart';
import 'package:cookiej/cookiej/provider/comment_provider.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class CommentListview extends StatefulWidget {

  final CommentsType commentsType;
  final int id;
  CommentListview(this.id,[this.commentsType=CommentsType.Time]);

  @override
  _CommentListviewState createState() => _CommentListviewState();
}

class _CommentListviewState extends State<CommentListview> with SingleTickerProviderStateMixin{

  Comments initialComments;
  Comments earlyComments;
  Comments laterComments;
  ///根据<rootId,<id,comment>>进行分组
  Map<int,Map<int,Comment>> groupCommentMap;
  List<Comment> displayCommentList=<Comment>[]; 
  Future<Comments> commentsTask;
  TabController _commentStatusController;

  // @override
  // bool get wantKeepAlive => true;
  @override
  void initState() {
    //_isStartLoad=startLoadData();
    commentsTask=CommentProvider.getCommentsShow(widget.id).then((result){
      var comments=result.data;
      initialComments=comments;
      laterComments=initialComments;
      groupCommentMap=formatComments(comments);
      //将直接回微博的-评论筛选出来
      groupCommentMap.forEach((rootId,sameRootCommentMap){       
        if(sameRootCommentMap[rootId]==null){
          //这种情况是有评论，但没有该评论rootId对应的评论
          sameRootCommentMap.forEach((_, value)=>displayCommentList.add(value));
        }
        else{
          //此处将同一rootId的评论扔到了和该rootId相同的评论的属性里
          sameRootCommentMap[rootId].commentReplyMap=sameRootCommentMap;
          displayCommentList.add(sameRootCommentMap[rootId]);
        }

      });
      displayCommentList.sort((a,b)=>b.rootid.compareTo(a.rootid));
      return comments;
    });
    _commentStatusController=TabController(initialIndex: 1,length: 3,vsync: this);
    _commentStatusController.addListener(()=>_commentStatusController.indexIsChanging?setState((){}):(){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return FutureBuilder(
      future: commentsTask, 
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(margin: EdgeInsets.all(32), child:Center(child:CircularProgressIndicator()));
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return snapshot.data==null?Text('未知状态'):Container(
              child:Column(children: <Widget>[
                Container(
                  child:TabBar(
                    tabs: <Widget>[
                      Text('转发(${initialComments.weibo.repostsCount})'),
                      Text('评论(${initialComments.weibo.commentsCount})'),
                      Text('赞(${initialComments.weibo.attitudesCount})')
                    ],
                    controller: _commentStatusController,
                    labelColor: _theme.textTheme.bodyText1.color,
                    // indicatorColor: Theme.of(context).primaryColor,
                    // labelStyle: TextStyle(fontSize:CookieJTextStyle.normalText.fontSize),
                  ),
                  height: 42,
                  color: _theme.dialogBackgroundColor,
                ),
                Container(
                  child: [
                    RepostListview(widget.id),
                    ListView.builder(
                      itemBuilder: (context,index){
                        return CommentWidget(displayCommentList[index]);
                      },
                      itemCount: groupCommentMap.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    Text('点赞')
                  ][_commentStatusController.index],
                )
              ]),
              constraints: BoxConstraints(minHeight:300),
              margin: EdgeInsets.only(top:10),
            );
          default:
            return Text('未知状态');
        }
      },
    );
  }

  ///将获取到的评论数据集进行分组<rootId,<id,comment>>
  Map<int,Map<int,Comment>> formatComments(Comments comments){
    var commentMap=new Map<int,Map<int,Comment>>();
    comments.comments.forEach((comment){
      //对内容处理
      if(comment.replyComment!=null){
        comment.text='@'+comment.user.screenName+':'+(comment.replyOriginalText??comment.text).toString();
      }
      //进行分组
      if(!commentMap.containsKey(comment.rootid)){
        commentMap[comment.rootid]={comment.id:comment};
      }else{
        commentMap[comment.rootid][comment.id]=comment;
      }
    });
    return commentMap;
  }
}