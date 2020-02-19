import 'dart:io';
import 'package:cookiej/ultis/utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import '../model/weibos.dart';
import '../model/weibo.dart';
import '../model/comments.dart';
import '../model/urlInfo.dart';
import '../config/type.dart';
import 'cacheController.dart';

class ApiController{
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
    //微博
    "statuses":{
      "publicTimeline":{"type":"get","value":"/2/statuses/public_timeline.json"},
      //用户所有关注人的微博
      "homeTimeline":{"type":"get","value":"/2/statuses/home_timeline.json"},
      //与用户双向关注人的微博
      "bilateralTimeline":{"type":"get","value":"/2/statuses/bilateral_timeline.json"},
      //单条微博的全部内容
      //该死的微博文档里没写要获取全文即超过140字的长微博要加上 isGetLongText=1 
      'show':{"type":"get","value":"/2/statuses/show.json"}
    },
    //评论
    'comments':{
      //根据评论id获取评论的 List
      'show':{"type":"get","value":"/2/comments/show.json"}
    },
    //短链接
    'short_url':{
      'info':{"type":"get","value":"/2/short_url/info.json"}
    }
  };
  static Dio _httpClient=new Dio(new Options(
    baseUrl: _apiUrl,
  ));
  //类初始化
  static void init(){
    var httpcount=0;
    //发起请求前加入accessToken
    _httpClient.interceptor.request.onSend=(Options options){
      if(_accessToken.isNotEmpty){
        var url=options.path;
        var params= {"access_token":_accessToken};
        options.path=formatUrlParams(url, params);
      }
      httpcount++;
      print('Http已发起请求次数'+httpcount.toString());
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
  
  ///获取微博列表
  static Future<Weibos> getTimeLine({int sinceId=0,int maxId=0,WeiboTimelineType timelineType=WeiboTimelineType.Statuses}){
    Future<Weibos> returnTimeline;
    switch (timelineType){
      case WeiboTimelineType.Public:
        returnTimeline = getStatusesPublicTimeline();
        break;
      case WeiboTimelineType.Statuses:
        returnTimeline = getStatusesHomeTimeline(sinceId: sinceId,maxId: maxId);
        break;
      case WeiboTimelineType.Bilateral:
        returnTimeline = getStatusesBilateralTimeline(sinceId: sinceId,maxId: maxId);
        break;
      default:
        returnTimeline = null;
    }
    //缓存文本中url的实际内容
     return returnTimeline.then((weibos) async{
      if(weibos.statuses.length==0){
        return returnTimeline;
      }
      var shortUrlList=<String>[];
      var reg=new RegExp(Utils.urlRegexStr);
      weibos.statuses.forEach((weibo){
        String text=weibo.longText==null?weibo.text:weibo.longText.longTextContent;
        var regList = reg.allMatches(text).toList();
        regList.forEach(
          (r){
            if(r.group(0).contains('//t.cn/')){
              shortUrlList.add(r.group(0)); 
            }
          });
      });
      if(shortUrlList.length<=20){
        var urlInfoList =await getUrlsInfo(shortUrlList);
        urlInfoList.forEach((urlInfo)=>CacheController.urlInfoCache[urlInfo.urlShort]=urlInfo);
      }
      return returnTimeline;
    });
    
  }

  ///获取公共微博
  static Future<Weibos>  getStatusesPublicTimeline() async{
    return null;
  }

  ///获取当前登录用户及其所关注（授权）用户的最新微博
  static Future<Weibos> getStatusesHomeTimeline({int sinceId=0,int maxId=0}) async{
    try{
      var url=_apiUrl+_apiUrlMap["statuses"]["homeTimeline"]["value"];
      var params={
        "since_id":sinceId.toString(),
        "max_id":maxId.toString()
      };
      final result=(await _httpClient.get(formatUrlParams(url, params))).data;
      return Weibos.fromJson(result);
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  ///获取双向关注用户的最新微博
  static Future<Weibos> getStatusesBilateralTimeline({int sinceId=0,int maxId=0}) async{
    try{
      var url=_apiUrl+_apiUrlMap["statuses"]["bilateralTimeline"]["value"];
      var params={
        "since_id":sinceId.toString(),
        "max_id":maxId.toString()
      };
      final result=(await _httpClient.get(formatUrlParams(url, params))).data;
      return Weibos.fromJson(result);
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  ///根据微博ID获取单条微博内容
  static Future<Weibo> getStatusesShow(int id) async{
    try{
      var url=_apiUrl+_apiUrlMap["statuses"]["show"]["value"];
      var params={
        'id':id.toString(),
        'isGetLongText':'1'
      };
      Weibo returnWeibo=Weibo.fromJson((await _httpClient.get(formatUrlParams(url, params))).data);
      return returnWeibo;
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  ///根据微博ID获取该微博评论列表
  static Future<Comments> getCommentsShow(int id,[int sinceId=0,int maxId=0]) async{
    try{
      var url=_apiUrl+_apiUrlMap["comments"]["show"]["value"];
      var params={
        'id':id.toString(),
        "since_id":sinceId.toString(),
        "max_id":maxId.toString()
      };
      var comments=(await _httpClient.get(formatUrlParams(url, params))).data;
      Comments returnComments=Comments.fromJson(comments);
      return returnComments;
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  static Future<List<UrlInfo>> getUrlsInfo(List<String> shortUrls) async{
    try{
      var url=_apiUrl+_apiUrlMap["short_url"]["info"]["value"];
      shortUrls.forEach((shortUrl){
        url=formatUrlParams(url, {'url_short':shortUrl});
      });
      var reuslt=(await _httpClient.get(url));
      var returnList = <UrlInfo>[];
      (reuslt.data['urls'] as List<dynamic>).forEach((urlInfoJson){
        returnList.add(UrlInfo.fromJson(urlInfoJson));
      });
      return returnList;
    }catch(e){
      print(e.response.data);
      return null;
    }
  }

  ///获取表情
  static Future<List<Map>> getEmotions() async{
    try{
      var url=_apiUrl+_apiUrlMap["emotions"]["emotions"]["value"];
      var result=(await _httpClient.get(url)).data;
      if(result is List<dynamic>){
        List<Map> jsonMap=new List<Map>();
        result.forEach((m){
          jsonMap.add(m);
        });
        return jsonMap;
      }
      else return null;
    }catch(e){
      print(e.response.data);
      return null;
    }

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