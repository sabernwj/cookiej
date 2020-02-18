import 'package:cookiej/config/global_config.dart';
import 'package:cookiej/controller/httpController.dart';
import 'package:cookiej/model/comment.dart';
import 'package:cookiej/model/comments.dart';
import 'package:cookiej/view/components/comments/comment_widget.dart';
import 'package:flutter/material.dart';
import '../../../config/type.dart';
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
  Future<Comments> commentsTask;
  TabController _commentStatusController;
  @override
  void initState() {
    //_isStartLoad=startLoadData();
    _commentStatusController=TabController(length: 3,vsync: this);
    commentsTask=HttpController.getCommentsShow(widget.id).then((comments){
      initialComments=comments;
      laterComments=initialComments;
      // for(var comment in initialComments.comments){
      //   _comments.add(comment);
      // }
      return comments;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: commentsTask, 
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child:CircularProgressIndicator());
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
                    labelColor: Colors.black,
                    indicatorColor: GlobalConfig.backGroundColor,
                    labelStyle: TextStyle(fontSize:GlobalConfig.weiboFontSize),
                  ),
                  height: 42,
                  color: Colors.white,
                ),
              ]),
              margin: EdgeInsets.only(top:10),
            );
          default:
            return Text('未知状态');
        }
      },
    );
  }
}