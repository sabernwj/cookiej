import 'package:cookiej/app/model/local/access.dart';
import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/model/url_info.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static LazyBox<UrlInfo> urlInfoBox;
  static Box<LocalConfig> localConfigBox;
  static Box<String> pictureServerBox;
  static Box<Access> accessBox;
  static LazyBox<UserLite> userBox;
  static LazyBox<Weibos> weibosBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    urlInfoBox = await Hive.openLazyBox('url_info_box');
    pictureServerBox = await Hive.openBox('pciture_server_box');
    accessBox = await Hive.openBox('access_box');
    weibosBox = await Hive.openLazyBox('weibos_box');
    userBox = await Hive.openLazyBox('user_box');
    localConfigBox = await Hive.openBox('local_config_box');

    Hive.registerAdapter(WeibosAdapter());
    Hive.registerAdapter(WeiboLiteAdapter());
    Hive.registerAdapter(UserLiteAdapter());
    Hive.registerAdapter(AccessAdapter());
    Hive.registerAdapter(LocalConfigAdapter());
  }
}

class HiveBoxType {
  /// 已登录用户的access数据
  static const int accessBox = 0;

  /// 已登录用户的weibos数据
  static const int weibosBox = 1;

  /// 本地配置
  static const int localConfigBox = 2;

  /// 已登录用户的资料UserLite类型
  static const int userBox = 3;

  /// 图片对应的服务器
  static const int pictureServerBox = 4;

  /// url对应的信息
  static const int urlInfoBox = 5;

  /// (暂无对应box)存储WeiboLite类型数据
  static const int weiboLiteType = 6;
}
