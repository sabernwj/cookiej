import 'package:cookiej/cookiej/utils/utils.dart';
import 'api.dart';
import 'dart:async';

class UrlApi{

  static const String _urlInfo='/2/short_url/info.json';
  ///重磅！经过不断看花眼睛的搜寻，终于找到了获取微博视频Url的链接(为了阿比达呦冲鸭！)
  static const String _requestVideoRawUrls='https://video.h5.weibo.cn/s/video/object';

  ///获取url短链接所包含的丰富信息
  static Future<Map> getUrlsInfo(List<String> shortUrls) async{
    var url=API.baseUrl+_urlInfo;
    shortUrls.forEach((shortUrl){
      url=Utils.formatUrlParams(url, {'url_short':shortUrl});
    });
    return (await API.get(url)).data;
  }

  static Future<Map> getVideoRaw(String objectId) async {
    var url=_requestVideoRawUrls;
    var params={
      'object_id':objectId,
    };
    url=Utils.formatUrlParams(url, params);
    return (await API.get(url)).data;
  }

}