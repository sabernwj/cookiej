import 'package:cookiej/config/global_config.dart';
import 'package:cookiej/controller/apiController.dart';
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

  // @override
  // bool get wantKeepAlive => true;
  @override
  void initState() {
    //_isStartLoad=startLoadData();
    commentsTask=ApiController.getCommentsShow(widget.id).then((comments){
      initialComments=comments;
      laterComments=initialComments;
      return comments;
    });
    _commentStatusController=TabController(initialIndex: 1,length: 3,vsync: this);
    _commentStatusController.addListener(()=>_commentStatusController.indexIsChanging?setState((){}):(){});
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
                Container(
                  child: [
                    Text('转发'),
                    ListView.builder(
                      itemBuilder: (context,index){
                        return CommentWidget(initialComments.comments[index]);
                      },
                      itemCount: initialComments.comments.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    Text('点赞')
                  ][_commentStatusController.index],
                )
              ]),
              margin: EdgeInsets.only(top:10),
            );
          default:
            return Text('未知状态');
        }
      },
    );
  }

  List<Comment> formatCommentList(Comments comments){
    
  }
}