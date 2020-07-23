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
      "scope":'friendships_groups_read,friendships_groups_write,statuses_to_me_read,direct_messages_write,direct_messages_read',
      //'display':'wap'
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

  // static Future<String> loginByDio(String userName,String password) async{
  //   var dio=Dio();
  //   var cookieJar=CookieJar();
  //   dio.interceptors.add(CookieManager(cookieJar));
  //   var url1='https://passport.weibo.cn/sso/login';
  //   var res=await dio.post(
  //     url1,
  //     options: Options(
  //       headers: {
  //         'Content-Type':'application/x-www-form-urlencoded',
  //         'Content-Length':'645',
  //         'Host':'passport.weibo.cn',
  //         'Origin':'https://passport.weibo.cn',
  //         'Referer':'https://passport.weibo.cn/signin/login?entry=openapi&r=https%3A%2F%2Fapi.weibo.com%2Foauth2%2Fauthorize%3Fclient_id%3D2200697181%26redirect_uri%3Dhttp%3A%2F%2F06peng.com%26scope%3Dfriendships_groups_read%2Cfriendships_groups_write%2Cstatuses_to_me_read%2Cdirect_messages_write%2Cdirect_messages_read'
  //       },
  //     ),
  //     data: FormData.fromMap({
  //       'username': userName,
  //       'password': password,
  //       'savestate': 1,
  //       'r': 'https://api.weibo.com/oauth2/authorize?client_id=2200697181&redirect_uri=http://06peng.com&scope=friendships_groups_read,friendships_groups_write,statuses_to_me_read,direct_messages_write,direct_messages_read',
  //       'ec': 0,
  //       'pagerefer': 'https://api.weibo.com/oauth2/authorize?client_id=2200697181&redirect_uri=http://06peng.com&scope=friendships_groups_read,friendships_groups_write,statuses_to_me_read,direct_messages_write,direct_messages_read',
  //       'entry': 'mweibo',
  //       'mainpageflag': 1,
  //       'wentry': '',
  //       'loginfrom': '',
  //       'client_id': '',
  //       'code': '',
  //       'qq':'',
  //       'hff':'', 
  //       'hfp':''
  //     })
  //     //data: 'username=${Uri.encodeComponent(userName)}&password=${Uri.encodeComponent(password)}&savestate=1&r=https%3A%2F%2Fapi.weibo.com%2Foauth2%2Fauthorize%3Fclient_id%3D2200697181%26redirect_uri%3Dhttp%3A%2F%2F06peng.com%26scope%3Dfriendships_groups_read%2Cfriendships_groups_write%2Cstatuses_to_me_read%2Cdirect_messages_write%2Cdirect_messages_read&ec=0&pagerefer=https%3A%2F%2Fapi.weibo.com%2Foauth2%2Fauthorize%3Fclient_id%3D2200697181%26redirect_uri%3Dhttp%3A%2F%2F06peng.com%26scope%3Dfriendships_groups_read%2Cfriendships_groups_write%2Cstatuses_to_me_read%2Cdirect_messages_write%2Cdirect_messages_read&entry=mweibo&wentry=&loginfrom=&client_id=&code=&qq=&mainpageflag=1&hff=&hfp='
  //   );
  //   return res.data;
  // }
}