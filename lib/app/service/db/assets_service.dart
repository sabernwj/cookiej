import 'dart:convert';

import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:flutter/services.dart';

class AssetsService {
  static Future<void> loadAppkeyData() async {
    var appkeyMap =
        json.decode(await rootBundle.loadString('assets/data/appkey.json'));
    Config.appkey_0 = appkeyMap['appkey'].toString();
    Config.appSecret_0 = appkeyMap['appSecret'].toString();
    Config.redirectUri_0 = appkeyMap['redirectUri'].toString();
    if (Config.appkey_0 == null || Config.appkey_0.isEmpty) {
      throw AppError(AppErrorType.OtherError);
    }
  }
}
