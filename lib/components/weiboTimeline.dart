import 'weibo.dart';


class WeiboTimeline {
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
}