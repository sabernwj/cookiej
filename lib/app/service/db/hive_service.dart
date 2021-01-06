import 'package:cookiej/app/model/data_object.dart';
import 'package:cookiej/app/model/annotations.dart';
import 'package:cookiej/app/model/emotion.dart';
import 'package:cookiej/app/model/local/access.dart';
import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/model/url_info.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static LazyBox<Map> urlInfoBox;
  static Box<LocalConfig> localConfigBox;
  static Box<String> pictureServerBox;
  static Box<Access> accessBox;
  static Box<UserLite> userBox;
  static Box<Map<String, Emotion>> emotionBox;
  static LazyBox<Weibos> weibosBox;

  static Future<void> preInit() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LocalConfigAdapter());
    Hive.registerAdapter(AccessAdapter());
    localConfigBox = await Hive.openBox('local_config_box');
    accessBox = await Hive.openBox('access_box');
  }

  static Future<void> init() async {
    Hive.registerAdapter(WeibosAdapter());
    Hive.registerAdapter(WeiboLiteAdapter());
    Hive.registerAdapter(UserLiteAdapter());
    Hive.registerAdapter(UrlInfoAdapter());
    Hive.registerAdapter(AnnotationsAdapter());
    Hive.registerAdapter(DataObjectAdapter());
    Hive.registerAdapter(EmotionAdapter());
    urlInfoBox = await Hive.openLazyBox('url_info_box');
    pictureServerBox = await Hive.openBox('pciture_server_box');
    weibosBox = await Hive.openLazyBox('weibos_box');
    userBox = await Hive.openBox('user_box');
    emotionBox = await Hive.openBox('emotion_box');
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

  /// url model中使用到的类型
  static const int urlAnnotations = 7;
  static const int urlAnnotationsDataObject = 8;

  /// emotion 表情
  static const int emotionBox = 9;
}
