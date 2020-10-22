import 'package:cookiej/app/model/local/access.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/model/local/weibos.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Box urlInfoBox;
  static Box<String> pictureServerBox;
  static Box<Access> accessBox;
  static LazyBox<Weibos> weibosBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    urlInfoBox = await Hive.openBox('url_info_box');
    pictureServerBox = await Hive.openBox('pciture_server_box');
    accessBox = await Hive.openBox('access_box');
    weibosBox = await Hive.openLazyBox('weibos_box');
    Hive.registerAdapter(WeibosAdapter());
    Hive.registerAdapter(WeiboLiteAdapter());
    Hive.registerAdapter(UserLiteAdapter());
  }
}
