import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:cookiej/app/model/local/access.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AccessRepository {
  static final _accessBox = HiveService.accessBox;

  /// 获取本地存储的所有Access
  static List<Access> getLocalAccess() {
    return _accessBox.values.toList();
  }

  /// 根据uid获取Access
  static Access getAccessFromLocal(String uid) {
    return _accessBox.get(uid);
  }

  /// 根据uid删除Access
  static Future<void> removeLocalAccess(String uid) async {
    await _accessBox.delete(uid);
  }

  /// 获取用户登陆页面地址
  static String getOauth2Authorize() {
    var url = '${API.baseUrl}/oauth2/authorize';
    var params = {
      "client_id": Config.appkey_0,
      "redirect_uri": Config.redirectUri_0,
      "scope":
          'friendships_groups_read,friendships_groups_write,statuses_to_me_read,direct_messages_write,direct_messages_read',
      //'display':'wap'
    };
    url = Utils.formatUrlParams(url, params);
    return url;
  }

  /// 获取access
  static Future<Access> getAccessFromNet(String code) async {
    var url = '/oauth2/access_token';
    var params = {
      "client_id": Config.appkey_0,
      "client_secret": Config.appSecret_0,
      "grant_type": "authorization_code",
      "redirect_uri": Config.redirectUri_0,
      "code": code,
    };
    var jsonRes = (await API.post(url, queryParameters: params)).data;
    Access access;
    // 获取token
    try {
      access = Access.fromJson(jsonRes);
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
    // 获取cookie
    var cookieManager = CookieManager.instance();
    var cookies = await cookieManager.getCookies(url: 'https://weibo.cn');
    var cookieStr = '';
    cookies
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .forEach((str) => cookieStr += str + ';');
    access.cookieStr = cookieStr;
    access.accessInvalid = true;

    // 存入hive
    await _accessBox.put(access.uid, access);
    return access;
  }
}
