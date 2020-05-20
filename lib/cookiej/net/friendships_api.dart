import 'api.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

class FriendshipsApi{

  static const String friends='/2/friendships/friends.json';
  static const String followers='/2/friendships/followers.json';

  ///获取用户的关注列表
  static Future<Map> getFriends({String uid,String screenName}) async{
    var url=friends;
    var params=<String,String>{};
    if(screenName!= null) params['screen_name']=screenName;
    if(uid!=null) params['uid']=uid;
    
    return (await API.get(Utils.formatUrlParams(url, params))).data;
  }

  ///获取用户的粉丝列表
  static Future<Map> getFollowers({String uid,String screenName}) async{
    var url=followers;
    var params=<String,String>{};
    if(screenName!= null) params['screen_name']=screenName;
    if(uid!=null) params['uid']=uid;
    
    return (await API.get(Utils.formatUrlParams(url, params))).data;
  }

}