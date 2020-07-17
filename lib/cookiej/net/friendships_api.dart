import 'api.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

class FriendshipsApi{

  static const String friends='/2/friendships/friends.json';
  static const String followers='/2/friendships/followers.json';
  static const String groups='/2/friendships/groups.json';

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

  //获取当前登陆用户好友分组列表
  static Future<Map> getGroups() async{
    var url=groups;
    return (await API.get(url)).data;
  }

}