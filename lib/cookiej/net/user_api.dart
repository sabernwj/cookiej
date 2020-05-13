import 'api.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

class UserApi {

  static const String userShow='/2/users/show.json';

  static Future<Map> getUserInfo({String uid,String screenName}) async{
    var url='/2/users/show.json';
    var params=<String,String>{};
    if(screenName!= null) params['screen_name']=screenName;
    if(uid!=null) params['uid']=uid;
    
    return (await API.get(Utils.formatUrlParams(url, params))).data;
  }
}