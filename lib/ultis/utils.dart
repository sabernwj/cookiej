import 'package:intl/intl.dart';

class Utils {

  static const String urlRegexStr="((ht|f)tp(s?):\\/\\/|www\\.)(([\\w\\-]+\\.){1,}?([\\w\\-.~]+\\/?)*[\\p{Alnum}.,%_=?&#\\-+()\\[\\]\\*\$~@!:/{};']*)";
  static const String topicRegexStr=r"#[^#]+#";
  static const String userRegexStr=r"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}";
  static const String emotionRegexStr=r"(\[[0-9a-zA-Z\u4e00-\u9fa5]+\])";
  static const String imgSizeStrFromUrl=r"(?<=sinaimg.cn\/)\w+";
  ///获取输入时间和当前时间的距离
  static String getDistanceFromNow(String inputTime){
    inputTime=inputTime.substring(0,inputTime.indexOf('+'))+inputTime.substring(inputTime.indexOf('+')+5,inputTime.length);
    DateTime now=new DateTime.now();
    DateTime input=(new DateFormat('EEE MMM dd HH:mm:ss  yyyy')).parse(inputTime);
    var distance=now.difference(input);
    if(distance.inSeconds>=60){
      if(distance.inMinutes>=60){
        if(distance.inHours>=24){
          return distance.inDays.toString()+'天前';
        }
        return distance.inHours.toString()+'小时前';
      }
      return distance.inMinutes.toString()+'分钟前';
    }
    return distance.inSeconds.toString()+'秒前';
  }
}