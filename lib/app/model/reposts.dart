import 'weibo.dart';

class Reposts {
  bool hasvisible;
  int previousCursor;
  int nextCursor;
  String previousCursorStr;
  String nextCursorStr;
  int totalNumber;
  int interval;
  List<Weibo> reposts;
  Reposts(
      {this.hasvisible,
      this.previousCursor,
      this.nextCursor,
      this.previousCursorStr,
      this.nextCursorStr,
      this.totalNumber,
      this.interval,
      this.reposts});

  Reposts.fromJson(Map<String, dynamic> json) {
    hasvisible = json['hasvisible'];
    previousCursor = json['previous_cursor'];
    nextCursor = json['next_cursor'];
    previousCursorStr = json['previous_cursor_str'];
    nextCursorStr = json['next_cursor_str'];
    totalNumber = json['total_number'];
    interval = json['interval'];
		if (json['reposts'] != null) {
			reposts = new List<Weibo>();
			json['reposts'].forEach((v) { reposts.add(new Weibo.fromJson(v)); });
		}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasvisible'] = this.hasvisible;
    data['previous_cursor'] = this.previousCursor;
    data['next_cursor'] = this.nextCursor;
    data['previous_cursor_str'] = this.previousCursorStr;
    data['next_cursor_str'] = this.nextCursorStr;
    data['total_number'] = this.totalNumber;
    data['interval'] = this.interval;
		if (this.reposts != null) {
      data['reposts'] = this.reposts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}