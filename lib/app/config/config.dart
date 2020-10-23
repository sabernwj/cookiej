import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Config {
  static const appkey = '';
  static const appSecret = '';
  static const redirectUri = '';

  //网上找的appkey
  static String appkey_0 = '';
  static String appSecret_0 = '';
  static String redirectUri_0 = '';

  static const loginAccessesStorageKey = 'login_accesses';
  static const currentAccessStorageKey = 'current_access';
  static const accessStateStorageKey = 'access_state';

  static const themeNameStorageKey = 'theme_name';
  static const isDarkModeStorageKey = 'is_dark_mode';
  static const isDarkModeAutoStorageKey = 'is_dark_mode_auto';

  static const userInfoDB = 'UserInfo';
  static const userInfoDB_Id = 'uid';

  static const pictureDB = 'PictureInfo';
  static const pictureDB_id = 'picture_id';

  static const List<String> imgBaseUrlPool = [
    'http://wx1.sinaimg.cn/',
    'http://wx2.sinaimg.cn/',
    'http://wx3.sinaimg.cn/',
    'http://ww1.sinaimg.cn/',
    'http://ww2.sinaimg.cn/',
    'http://ww3.sinaimg.cn/',
    'http://tva2.sinaimg.cn/',
    'http://tvax3.sinaimg.cn/',
  ];
  static const String baseUrl = 'https://api.weibo.com';
}

class HiveBoxNames {
  static const String cookie = 'cookie_box';
}

class SinaImgSize {
  static const String thumbnail = 'thumbnail';
  static const String bmiddle = 'bmiddle';
  static const String large = 'large';
  static const String small = 'small';
  static const String mw690 = 'mw690';
  static const String mw1024 = 'mw1024';
  static const String mw2048 = 'mw2048';
}

enum WeibosType {
  Public,
  Firends,
  Statuses,
  Bilateral,
  Reposts,
  User,
  Group,
  Mentions
}

extension WeiboTimelineExtesnsion on WeibosType {
  String toStringNew() {
    return this.toString().split('.').last;
  }

  String get text =>
      ['公共', '朋友', '全部关注', '好友圈', '转发', '用户', '自定义分组', '@我的微博'][this.index];
}

extension CookieInAppWebview on Cookie {
  static Cookie fromString(String str) {
    Map<String, dynamic> map = json.decode(str);
    return Cookie(
        name: map['name'],
        value: map['value'],
        expiresDate: map['expiresDate'],
        isSessionOnly: map['isSessionOnly'],
        domain: map['domain'],
        isSecure: map['isSecure'],
        isHttpOnly: map['isHttpOnly'],
        path: map['path']);
  }
}

enum CommentsType { Hot, Time, Mentions, ByMe, ToMe }
enum FunctionCallBack { UserPageRefresh }
