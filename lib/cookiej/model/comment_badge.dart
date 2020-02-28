import 'action_log.dart';

class CommentBadge {
	String picUrl;
	double length;
	Actionlog actionlog;
	String scheme;

	CommentBadge({this.picUrl, this.length, this.actionlog, this.scheme});

	CommentBadge.fromJson(Map<String, dynamic> json) {
		picUrl = json['pic_url'];
		length = json['length'];
		actionlog = json['actionlog'] != null ? new Actionlog.fromJson(json['actionlog']) : null;
		scheme = json['scheme'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['pic_url'] = this.picUrl;
		data['length'] = this.length;
		if (this.actionlog != null) {
      data['actionlog'] = this.actionlog.toJson();
    }
		data['scheme'] = this.scheme;
		return data;
	}
}