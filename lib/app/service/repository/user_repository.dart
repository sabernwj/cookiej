import 'package:cookiej/app/model/group.dart';
import 'package:cookiej/app/model/user.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:cookiej/cookiej/net/api.dart';

class UserRepository {
  //获取Token

  //存储Token

  //获取用户信息
  static Future<User> getUserInfo({String uid, String screenName}) async {
    var url = '/2/users/show.json';
    var params = <String, String>{};
    if (screenName != null) params['screen_name'] = screenName;
    if (uid != null) params['uid'] = uid;
    var json = (await API.get(Utils.formatUrlParams(url, params))).data;
    try {
      return User.fromJson(json);
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }

  static Future<List<User>> getFriends({String uid, String screenName}) async {
    var url = '/2/friendships/friends.json';
    var params = <String, String>{};
    if (screenName != null) params['screen_name'] = screenName;
    if (uid != null) params['uid'] = uid;
    var jsonRes = (await API.get(Utils.formatUrlParams(url, params))).data;
    try {
      return jsonRes['users'].map((user) => User.fromJson(user));
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }

  static Future<List<User>> getFollowers(
      {String uid, String screenName}) async {
    var url = '/2/friendships/followers.json';
    var params = <String, String>{};
    if (screenName != null) params['screen_name'] = screenName;
    if (uid != null) params['uid'] = uid;
    var jsonRes = (await API.get(Utils.formatUrlParams(url, params))).data;
    try {
      return jsonRes['users'].map((user) => User.fromJson(user));
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }

  static Future<List<Group>> getGroups() async {
    var url = '/2/friendships/groups.json';
    var jsonRes = (await API.get(url)).data;
    try {
      return jsonRes['lists'].map((group) => Group.fromJson(group));
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }
}
