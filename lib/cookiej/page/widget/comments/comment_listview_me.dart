import 'dart:async';
import 'dart:core';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/comments.dart';
import 'package:cookiej/cookiej/page/widget/comments/comment_widget_me.dart';
import 'package:cookiej/cookiej/provider/comment_provider.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:flutter/material.dart';

class CommentListviewMe extends StatefulWidget {

  final CommentsType type;

  const CommentListviewMe({Key key,@required this.type}) : super(key: key);

  @override
  _CommentListviewMeState createState() => _CommentListviewMeState();
}

class _CommentListviewMeState extends State<CommentListviewMe> with AutomaticKeepAliveClientMixin{

  Future<ProviderResult<Comments>> commentTask;

  @override
  void initState() {
    commentTask=CommentProvider.getCommentsAboutMe(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: commentTask,
      builder: (context,snaphot){
        if(snaphot.hasError){
          return Container(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SizedBox(height: 16),
                Text(snaphot.error.toString()),
                SizedBox(height: 16),
                RaisedButton(
                  child: Text('刷新试试'),
                  onPressed: (){
                    commentTask=CommentProvider.getCommentsAboutMe(widget.type);
                  }
                ),
                SizedBox(height: 16),
              ]
            )
          );
        }
        if(snaphot.hasData){
          if(snaphot.data.success){
            Comments comments=snaphot.data.data;
            return ListView.builder(
              itemCount: comments.comments.length,
              itemBuilder: (context,index){
                return Container(
                  child:CommentWidgetMe(comment:comments.comments[index]),
                  margin:EdgeInsets.only(bottom:12),
                  decoration: BoxDecoration(
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 1.0), //阴影xy轴偏移量
                        )
                    ]
                  ),
                );
              }
            );
          }else{
            return Center(child:Text('没有找到相关信息'));
          }
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  @override
  bool get wantKeepAlive => true;

}