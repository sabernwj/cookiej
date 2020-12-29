import 'package:cookiej/app/model/group.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/user.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:cookiej/app/service/net/api.dart';

class UserRepository {
  static final _userbox = HiveService.userBox;

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

  /// 获取本地用户信息
  static UserLite getUserLiteFromLocal(String uid) => _userbox.get(uid);

  /// 存入用户信息到本地
  static Future<void> saveUserLiteToLocal(UserLite userLite) async {
    await _userbox.put(userLite.idstr, userLite);
  }

  /// 删除本地用户信息
  static Future<void> deleteUserListFromLocal(String uid) async {
    await _userbox.delete(uid);
  }

  /// 获取关注的人
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

  /// 获取粉丝
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

  /// 获取分组信息
  static Future<List<Group>> getGroups() async {
    var url = '/2/friendships/groups.json';
    var jsonRes = (await API.get(url)).data;
    try {
      return (jsonRes['lists'] as List)
          .map((group) => Group.fromJson(group))
          .toList();
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }
}
