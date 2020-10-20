import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/utils/utils.dart';
import 'package:cookiej/app/model/access.dart';

class AccessRepository {
  static final baseUrl = Config.baseUrl;

  /// 获取用户登陆页面地址
  static String getOauth2Authorize() {
    var url = '$baseUrl/oauth2/authorize';
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
  static Future<Access> getOauth2Access(String code) async {
    var url = '$baseUrl/oauth2/access_token';
    var params = {
      "client_id": Config.appkey_0,
      "client_secret": Config.appSecret_0,
      "grant_type": "authorization_code",
      "redirect_uri": Config.redirectUri_0,
      "code": code,
    };
    var jsonRes = (await API.get(url, queryParameters: params)).data;
    try {
      return Access.fromJson(jsonRes);
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }
}
