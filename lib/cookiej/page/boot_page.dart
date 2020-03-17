import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:cookiej/cookiej/action/user_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/db/sql_manager.dart';
import 'package:cookiej/cookiej/page/main_page.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:cookiej/cookiej/provider/url_provider.dart';
import 'package:cookiej/cookiej/provider/weibo_provider.dart';
import 'package:cookiej/cookiej/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

import 'package:redux/redux.dart';

class BootPage extends StatefulWidget {
  static final String routePath = "/";
  @override
  _BootPageState createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    Store<AppState> store = StoreProvider.of(context);
    Future.delayed(Duration(seconds: 1),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
    });
    //初始化数据库
    await SqlManager.init();
    await Hive.initFlutter();
    await UrlProvider.init();
    await PictureProvider.init();
    await WeiboProvider.init();
    //await Hive.openBox('cookiej_hive_database');
    //加载本地用户信息
    store.dispatch(InitAccessState());
    //加载主题
    String themeName=await LocalStorage.get(Config.themeNameStorageKey);
    bool isDarkMode=await LocalStorage.get(Config.isDarkModeStorageKey)=='true';
    if(themeName!=null){
      store.dispatch(RefreshThemeState(ThemeState(themeName,CookieJColors.getThemeData(themeName,isDarkMode: isDarkMode))));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child:Text('启动页')),
    );
  }
}