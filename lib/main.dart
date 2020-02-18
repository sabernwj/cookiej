import 'package:flutter/material.dart';
import './view/route/index.dart';
import 'boot.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Boot.init();
    return new Index();
  }
}


