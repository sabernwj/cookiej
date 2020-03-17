import 'user_lite.dart';
import 'comment_badge.dart';
import 'content.dart';
import 'reply_comment.dart';
import 'user.dart';
import 'weibo.dart';
import 'package:cookiej/cookiej/utils/utils.dart';

class Comment extends Content{
	DateTime createdAt;
	int id;
	int rootid;
	String rootidstr;
	int floorNumber;
	String text;
	int disableReply;
	UserLite user;
	String mid;
	String idstr;
	Weibo weibo;
  ReplyComment replyComment;
	String readtimetype;
  List<CommentBadge> commentBadge;
  Map<int,Comment> commentReplyMap;
	String replyOriginalText;
  

	Comment({this.createdAt, this.id, this.rootid, this.rootidstr, this.floorNumber, this.text, this.disableReply, this.user, this.mid, this.idstr, this.weibo, this.readtimetype,this.replyComment,this.commentBadge,this.replyOriginalText});

	Comment.fromJson(Map<String, dynamic> json) {
		createdAt = Utils.parseWeiboTimeStrToUtc(json['created_at']);
		id = json['id'];
		rootid = json['rootid'];
		rootidstr = json['rootidstr'];
		floorNumber = json['floor_number'];
		text = json['text'];
		disableReply = json['disable_reply'];
		user = json['user'] != null ? new User.fromJson(json['user']) : null;
		mid = json['mid'];
		idstr = json['idstr'];
		weibo = json['status'] != null ? new Weibo.fromJson(json['status']) : null;
    replyComment = json['reply_comment'] != null ? new ReplyComment.fromJson(json['reply_comment']) : null;
		readtimetype = json['readtimetype'];
		if (json['comment_badge'] != null) {
			commentBadge = new List<CommentBadge>();
			json['comment_badge'].forEach((v) { commentBadge.add(new CommentBadge.fromJson(v)); });
		}
    replyOriginalText = json['reply_original_text'];

    //去除评论中回复自己的@
    if(replyOriginalText!=null&&user.id==replyComment.user.id){
      text=replyOriginalText;
    }
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['created_at'] = this.createdAt;
		data['id'] = this.id;
		data['rootid'] = this.rootid;
		data['rootidstr'] = this.rootidstr;
		data['floor_number'] = this.floorNumber;
		data['text'] = this.text;
		data['disable_reply'] = this.disableReply;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		data['mid'] = this.mid;
		data['idstr'] = this.idstr;
		if (this.weibo != null) {
      data['status'] = this.weibo.toJson();
    }
		data['readtimetype'] = this.readtimetype;
    if (this.replyComment != null) {
      data['reply_comment'] = this.replyComment.toJson();
    }
		if (this.commentBadge != null) {
      data['comment_badge'] = this.commentBadge.map((v) => v.toJson()).toList();
    }
    data['reply_original_text'] = this.replyOriginalText;
		return data;
	}
}