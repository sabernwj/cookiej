import 'package:cookiej/cookiej/utils/utils.dart';
import 'api.dart';
import 'dart:async';

class UrlApi{

  static const String _urlInfo='/2/short_url/info.json';

  ///获取url短链接所包含的丰富信息
  static Future<Map> getUrlsInfo(List<String> shortUrls) async{
    try{
      var url=API.baseUrl+_urlInfo;
      shortUrls.forEach((shortUrl){
        url=Utils.formatUrlParams(url, {'url_short':shortUrl});
      });
      return (await API.httpClient.get(url)).data;

    }catch(e){
      print(e.response.data);
      return null;
    }
  }
}