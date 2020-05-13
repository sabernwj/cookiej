import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/utils/utils.dart';

class AccessApi{
  static final baseUrl=API.baseUrl;
  
  ///获取用户登陆页面地址
  static String getOauth2Authorize(){
    var url='$baseUrl/oauth2/authorize';
    var params={
      "client_id":Config.appkey_0,
      "redirect_uri":Config.redirectUri_0,
      "scope":'friendships_groups_read,friendships_groups_write,statuses_to_me_read,direct_messages_write,direct_messages_read'
    };
    url=Utils.formatUrlParams(url, params);
    return url;
  }

  ///获取accessToken
  static Future<String> getOauth2Access(String code) async{
    var url='/oauth2/access_token';
    var params={
      "client_id":Config.appkey_0,
      "client_secret":Config.appSecret_0,
      "grant_type":"authorization_code",
      "redirect_uri":Config.redirectUri_0,
      "code":code,
    };
    var httpCli=new HttpClient();
    var uri=new Uri.https('api.weibo.com',url,params);
    var request=await httpCli.postUrl(uri);
    var httpResponse=await request.close();
    var responseBody = await httpResponse.transform(utf8.decoder).join();
    return responseBody;
  }
}