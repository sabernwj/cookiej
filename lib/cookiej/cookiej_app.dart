import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/page/boot_page.dart';
import 'package:cookiej/cookiej/page/main_page.dart';
import 'package:cookiej/cookiej/reducer/app_reducer.dart';
import 'package:cookiej/cookiej/page/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CookieJAPP extends StatefulWidget {
  @override
  _CookieJState createState() => _CookieJState();
}

class _CookieJState extends State<CookieJAPP> {

  final store=Store<AppState>(
    appReducer,
    initialState: AppState(
      accessState:AccessState.init()
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
            routes: {
              BootPage.routePath:(context){
                return BootPage();
              },
              LoginPage.routePath:(context){
                return LoginPage();
              },
              MainPage.routePath:(context){
                return MainPage();
              }
            },
          );
        },
      )
    );
  }
}