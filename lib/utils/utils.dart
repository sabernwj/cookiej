import 'package:intl/intl.dart';
import 'package:intl/date_time_patterns.dart';

class Utils {
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