import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/service/repository/local_config_repository.dart';
import 'package:cookiej/app/service/repository/style_repository.dart';
import 'package:flutter/material.dart';

class GlobaViewModel with ChangeNotifier {
  LocalConfig _config;

  ThemeData currentTheme;

  void initData() {
    _config = LocalConfigRepository.getLocalConfig();
    currentTheme = StyleRepository.getThemeData(_config.themeName);
  }
}
