import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/provider/async_view_model.dart';
import 'package:cookiej/app/service/repository/local_config_repository.dart';
import 'package:cookiej/app/service/repository/style_repository.dart';
import 'package:cookiej/app/service/repository/user_repository.dart';
import 'package:flutter/material.dart';

class GlobalViewModel extends AsyncViewModel {
  LocalConfig _config;

  bool get isLogin => _config.loginUsers.isNotEmpty;

  ThemeData get currentTheme => StyleRepository.getThemeData(_config.themeName);

  List<UserLite> get loginUsers => _config.loginUsers
      .map((uid) => UserRepository.getUserLiteFromLocal(uid))
      .toList();

  UserLite get currentUser =>
      UserRepository.getUserLiteFromLocal(_config.currentUserId);

  GlobalViewModel() {
    _config =
        LocalConfigRepository.getLocalConfig() ?? LocalConfig.defaultValue();
  }
}
