import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/page/boot_page.dart';
import 'package:cookiej/cookiej/page/main_page.dart';
import 'package:cookiej/cookiej/reducer/app_reducer.dart';
import 'package:cookiej/cookiej/page/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cookiej/cookiej/config/style.dart';

class CookieJAPP extends StatefulWidget {
  @override
  _CookieJState createState() => _CookieJState();
}

class _CookieJState extends State<CookieJAPP> {

  final store=Store<AppState>(
    appReducer,
    middleware: middleware,
    initialState: AppState(
      accessState:AccessState.init(),
      currentUser: User(),
      themeState: ThemeState.init()
    )
  );
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context,store){
          return new MaterialApp(
            title: '饼干酱',
            home: BootPage(),
            theme: store.state.themeState.themeData,
          );
        },
      )
    );
  }
}