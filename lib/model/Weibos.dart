import 'weibo.dart';
import 'dart:convert' show json;

class Weibos {
  List<Weibo> statuses;
  bool hasVisible;
  int previousCursor;
  int nextCursor;
  int totalNumber;
  int interval;
  int uveBlank;
  int sinceId;
  int maxId;
  int hasUnread;

  factory Weibos(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Weibos.fromJson(json.decode(jsonStr)) : new Weibos.fromJson(jsonStr);
  
  Weibos.fromJson(jsonRes){
    hasVisible=jsonRes["hasvisible"];
    previousCursor=jsonRes["previous_cursor"];
    nextCursor=jsonRes["next_cursor"];
    totalNumber=jsonRes["total_number"];
    interval=jsonRes["interval"];
    uveBlank=jsonRes["uve_blank"];
    sinceId=jsonRes["since_id"];
    maxId=jsonRes["max_id"];
    hasUnread=jsonRes["has_unread"];
    statuses=jsonRes["statuses"]== null ? null : [];
    for (var weiboItem in statuses == null ? [] : jsonRes['statuses']){
            statuses.add(weiboItem == null ? null : Weibo.fromJson(weiboItem));
    }
  }

}