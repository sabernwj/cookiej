import 'package:cookiej/model/content.dart';
import 'package:cookiej/model/weibo.dart';

class Comment extends Content{
	String createdAt;
	int id;
	int rootid;
	String rootidstr;
	int floorNumber;
	String text;
	int disableReply;
	User user;
	String mid;
	String idstr;
	Weibo weibo;
  ReplyComment replyComment;
	String readtimetype;

	Comment({this.createdAt, this.id, this.rootid, this.rootidstr, this.floorNumber, this.text, this.disableReply, this.user, this.mid, this.idstr, this.weibo, this.readtimetype,this.replyComment});

	Comment.fromJson(Map<String, dynamic> json) {
		createdAt = json['created_at'];
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
		return data;
	}
}


class ReplyComment {
	String createdAt;
	int id;
	int rootid;
	String rootidstr;
	int floorNumber;
	String text;
	int disableReply;
	User user;
	String mid;
	String idstr;

	ReplyComment({this.createdAt, this.id, this.rootid, this.rootidstr, this.floorNumber, this.text, this.disableReply, this.user, this.mid, this.idstr});

	ReplyComment.fromJson(Map<String, dynamic> json) {
		createdAt = json['created_at'];
		id = json['id'];
		rootid = json['rootid'];
		rootidstr = json['rootidstr'];
		floorNumber = json['floor_number'];
		text = json['text'];
		disableReply = json['disable_reply'];
		user = json['user'] != null ? new User.fromJson(json['user']) : null;
		mid = json['mid'];
		idstr = json['idstr'];
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
		return data;
	}
}