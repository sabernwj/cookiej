import 'package:flutter/material.dart';
import 'package:cookiej/cookiej/config/style.dart';


class ThemeState{
  String themeName;
  ThemeData themeData;

  ThemeState(this.themeName,this.themeData);
  ThemeState.init(){
    themeName=CookieJColors.themeColors.keys.toList()[0];
    themeData=CookieJColors.getThemeData(themeName);
  }
}

class RefreshThemeState {
  final ThemeState themeState;
  RefreshThemeState(this.themeState);
}

class SwitchDarkMode{
  final bool isDarkMode;
  SwitchDarkMode(this.isDarkMode);

}