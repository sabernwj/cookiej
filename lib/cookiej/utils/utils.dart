import 'package:intl/intl.dart';

class Utils {

  static const String urlRegexStr="((ht|f)tp(s?):\\/\\/|www\\.)(([\\w\\-]+\\.){1,}?([\\w\\-.~]+\\/?)*[\\p{Alnum}.,%_=?&#\\-+()\\[\\]\\*\$~@!:/{};']*)";
  static const String topicRegexStr=r"#[^#]+#";
  static const String userRegexStr=r"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}";
  static const String emotionRegexStr=r"(\[[0-9a-zA-Z\u4e00-\u9fa5]+\])";
  static const String imgSizeStrFromUrlRegStr=r"(?<=sinaimg.cn\/)\w+";
  static const String imgIdStrFromUrl=r"\w+(?=\.jpg)";


  ///将微博内日期字符串转化为标准UTC时间
  static DateTime parseWeiboTimeStrToUtc(String timeStr){
    int index=timeStr.indexOf('+');
    String timeZone=timeStr.substring(index,index+5);
    timeStr=timeStr.substring(0,index)+timeStr.substring(index+5,timeStr.length);
    return DateTime.parse(DateFormat('EEE MMM dd HH:mm:ss  yyyy').parse(timeStr).toIso8601String()+timeZone);
  }

  ///获取输入时间和当前时间的距离
  static String getDistanceFromNow(DateTime inputTime){
    DateTime now=new DateTime.now();
    var distance=now.difference(inputTime);
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
  
  ///将数字转化为文字
  static String formatNumToChineseStr(int number){
    if(number>=1000&&number<10000) return '${(number/1000).toStringAsFixed(1)}k';
    else if(number>=10000) return '${(number/10000).toStringAsFixed(1)}万';
    return number.toString();
  }

  ///格式化url地址和参数
  static String formatUrlParams(String url,Map<String,String> params){
    if(!url.contains("?")){
      url+="?";
    }else{
      url+="&";
    }
    
    params.forEach((k,v)=>url+="$k=$v&");
    url=url.substring(0,url.length-1);
    return url;
  }

}