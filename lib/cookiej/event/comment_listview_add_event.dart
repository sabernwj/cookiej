import 'package:cookiej/cookiej/model/comment.dart';

class CommentListviewAddEvent{
  final int weiboId;
  final Comment comment;

  CommentListviewAddEvent(this.weiboId, this.comment);
}