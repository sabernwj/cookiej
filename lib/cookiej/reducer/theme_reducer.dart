import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:cookiej/cookiej/config/style.dart';

final themeDataReducer = combineReducers<ThemeState>([

  TypedReducer<ThemeState, RefreshThemeState>(_refresh),
  TypedReducer<ThemeState,SwitchDarkMode>(_switchDarkMode)
]);

///定义处理 Action 行为的方法，返回新的 State
ThemeState _refresh(ThemeState themeState,RefreshThemeState action) {
  //只有在亮色模式下才会更换主题
  themeState = action.themeState;
  return themeState;
}

ThemeState _switchDarkMode(ThemeState themeState,SwitchDarkMode action){
  themeState.themeData=CookieJColors.getThemeData(themeState.themeName,isDarkMode: action.isDarkMode);
  return themeState;
}

