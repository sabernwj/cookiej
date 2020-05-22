import 'package:cookiej/cookiej/model/comment.dart';
import 'package:cookiej/cookiej/model/comments.dart';

class CommentListMixin{

  Comments initialComments;
  Comments earlyComments;
  Comments laterComments;

  ///根据<rootId,<id,comment>>进行分组
  Map<int,Map<int,Comment>> groupCommentMap;
  List<Comment> displayCommentList=<Comment>[]; 
  Future<Comments> commentsTask;


  

}