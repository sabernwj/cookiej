import 'package:cookiej/cookiej/model/user.dart';
import 'package:flutter/material.dart';

import 'access_state.dart';

class AppState{

  //授权状态
  AccessState accessState;

  // ///用户信息
  User currentUser;

  // ///主题
  // ThemeData themeData;

  // ///语言
  // Locale locale;

  // ///当前手机平台默认语言
  // Locale platformLocale;

  // AppState({this.currentUser,this.locale,this.accessState,this.platformLocale,this.themeData});
  AppState({this.accessState,this.currentUser});

}