import 'dart:async';

import 'package:cookiej/cookiej/cookiej_app.dart';
import 'package:flutter/material.dart';

void main() {
  runZoned((){
    runApp(CookieJ());
  },onError: (obj,stack){
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


