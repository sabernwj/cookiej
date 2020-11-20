import 'dart:async';

import 'package:cookiej/app/app.dart';
import 'package:cookiej/cookiej/cookiej_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  //debugProfileBuildsEnabled=true;
  runZoned(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(App());
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }, onError: (obj, stack) {
    print(obj);
    print(stack);
  });
}

class CookieJ extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CookieJAPP();
  }
}
