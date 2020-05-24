import 'package:cookiej/cookiej/config/config.dart';
import 'package:hive/hive.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';

part 'weibos.g.dart';

@HiveType(typeId: CookieJHiveType.Weibos)
class Weibos {
  @HiveField(0)
  List<WeiboLite> statuses;
  bool hasVisible;
  int previousCursor;
  int nextCursor;
  int totalNumber;
  int interval;
  int uveBlank;
  ///若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博）
  @HiveField(1)
  int sinceId;
  ///若指定此参数，则返回ID小于或等于max_id的微博
  @HiveField(2)
  int maxId;
  int hasUnread;

  Weibos({this.statuses,this.sinceId,this.maxId});
  //factory Weibos(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Weibos.fromJson(json.decode(jsonStr)) : new Weibos.fromJson(jsonStr);
  
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
    statuses = new List<WeiboLite>();
    jsonRes['statuses'].forEach((v) { statuses.add(WeiboLite.fromJson(v)); });
  }

}