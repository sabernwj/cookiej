import 'package:cookiej/cookiej/cookiej_app.dart';
import 'package:flutter/material.dart';
import './view/route/index.dart';
import 'boot.dart';

void main() {
  
  runApp(CookieJ());
} 

class CookieJ extends StatelessWidget {
  // This widget is the root of your application.

  CookieJ(){
    Boot.init();
  }
  
  @override
  Widget build(BuildContext context) {
    return CookieJAPP();
  }
}


