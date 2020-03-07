import 'api.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

class UserApi {

  static Future<Map> getUserInfo(String uid) async{
    var url='/2/users/show.json';
    var params={
      'uid':uid
    };
    return (await API.httpClient.get(Utils.formatUrlParams(url, params))).data;
  }
}