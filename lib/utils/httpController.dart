import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../components/weibo.dart';
import '../components/weiboTimeline.dart';

class HttpController{
  static final _appKey="1532678245";
  static final _appSecret="71663753d61d39daa0cd6a7689304c64";
  static final _redirectUri="https://api.weibo.com/oauth2/default.html";
  static String _accessToken="";

  static final _apiUrl="https://api.weibo.com";
  static final _apiUrlMap={
    "emotions":{
      "emotions":{"type":"get","value":"/2/emotions.json"}
    },
    "oauth2":{
      "authorize":{"type":"get","value":"/oauth2/authorize"},
      "accessToken":{"type":"post","value":"/oauth2/access_token"}
    },
    "statuses":{
      "publicTimeline":{"type":"get","value":"/2/statuses/public_timeline.json"},
      "homeTimeline":{"type":"get","value":"/2/statuses/home_timeline.json"},
      "bilateralTimeline":{"type":"get","value":"2/statuses/bilateral_timeline.json"}
    }
  };
  static Dio _httpClient=new Dio(new Options(
    baseUrl: _apiUrl,
  ));
  //类初始化
  static void init(){
    //发起请求前加入accessToken
    _httpClient.interceptor.request.onSend=(Options options){
      if(_accessToken.isNotEmpty){
        var url=options.path;
        var params= {"access_token":_accessToken};
        options.path=formatUrlParams(url, params);
      }
      return options;
    };
  }



  ///获取登录页面地址
  static String getOauth2Authorize(){
    var url= _apiUrlMap["oauth2"]["authorize"]["value"];
    url=_apiUrl+url;
    var params={
      "client_id":_appKey,
      "redirect_uri":_redirectUri
    };
    return formatUrlParams(url, params);
  }
  

  ///为HTTP请求器设置token
  static setTokenToHttpClient(String token){
    _accessToken=token;
  }
  ///获取accessToken
  static Future<String> getOauth2AccessToken(String code) async{
    var url=_apiUrlMap["oauth2"]["accessToken"]["value"];
    
    var params={
      "client_id":_appKey,
      "client_secret":_appSecret,
      "grant_type":"authorization_code",
      "redirect_uri":_redirectUri,
      "code":code,
    };
    var httpCli=new HttpClient();
    var uri=new Uri.https('api.weibo.com',url,params);
    var request=await httpCli.postUrl(uri);
    var httpResponse=await request.close();
    var responseBody = await httpResponse.transform(utf8.decoder).join();
    // Response response;
    // response=await _httpClient.post(formatUrlParams(url, params),data: {});
    var result=json.decode(responseBody);
    return result["access_token"].toString();
    
  }

  ///获取公共微博
  static Future<WeiboTimeline>  getStatusesPublicTimeline() async{

  }

  ///获取当前登录用户及其所关注（授权）用户的最新微博
  static Future<Map> getStatusesHomeTimeline({int sinceId=0,int maxId=0}) async{
    try{
      var url=_apiUrl+_apiUrlMap["statuses"]["homeTimeline"]["value"];
      var params={
        "since_id":sinceId.toString(),
        "max_id":maxId.toString()
      };
      return (await _httpClient.get(formatUrlParams(url, params))).data;
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  ///获取双向关注用户的最新微博
  static Future<Map> getStatusesBilateralTimeline({int sinceId=0,int maxId=0}) async{
    try{
      var url=_apiUrl+_apiUrlMap["statuses"]["bilateralTimeline"]["value"];
      var params={
        "since_id":sinceId.toString(),
        "max_id":maxId.toString()
      };
      return (await _httpClient.get(formatUrlParams(url, params))).data;
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  static Future<Map> getEmotions() async{
    var url=_apiUrlMap["emotions"]["emotions"]["value"];
    return (await _httpClient.get(url)).data;
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