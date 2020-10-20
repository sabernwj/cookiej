import 'comment.dart';
import 'weibo.dart';

class Comments {
  List<Comment> comments;
  List<dynamic> marks;
  bool hasvisible;
  int previousCursor;
  int nextCursor;
  String previousCursorStr;
  String nextCursorStr;
  int totalNumber;
  int sinceId;
  int maxId;
  String sinceIdStr;
  String maxIdStr;
  Weibo weibo;

  Comments(
      {this.comments,
      this.marks,
      this.hasvisible,
      this.previousCursor,
      this.nextCursor,
      this.previousCursorStr,
      this.nextCursorStr,
      this.totalNumber,
      this.sinceId,
      this.maxId,
      this.sinceIdStr,
      this.maxIdStr,
      this.weibo});

  Comments.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
    if (json['marks'] != null) {
      marks = new List<dynamic>();
      json['marks'].forEach((v) {
        marks.add(v);
      });
    }
    hasvisible = json['hasvisible'];
    previousCursor = json['previous_cursor'];
    nextCursor = json['next_cursor'];
    previousCursorStr = json['previous_cursor_str'];
    nextCursorStr = json['next_cursor_str'];
    totalNumber = json['total_number'];
    sinceId = json['since_id'];
    maxId = json['max_id'];
    sinceIdStr = json['since_id_str'];
    maxIdStr = json['max_id_str'];
    weibo= json['status'] != null ? new Weibo.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.marks != null) {
      data['marks'] = this.marks.map((v) => v.toJson()).toList();
    }
    data['hasvisible'] = this.hasvisible;
    data['previous_cursor'] = this.previousCursor;
    data['next_cursor'] = this.nextCursor;
    data['previous_cursor_str'] = this.previousCursorStr;
    data['next_cursor_str'] = this.nextCursorStr;
    data['total_number'] = this.totalNumber;
    data['since_id'] = this.sinceId;
    data['max_id'] = this.maxId;
    data['since_id_str'] = this.sinceIdStr;
    data['max_id_str'] = this.maxIdStr;
    data['status'] = this.weibo.toJson();
    return data;
  }
}
