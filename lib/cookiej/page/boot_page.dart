import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/page/main_page.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:cookiej/cookiej/page/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

import 'package:redux/redux.dart';

class BootPage extends StatefulWidget {
  static final String routePath = "/";
  @override
  _BootPageState createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    Store<AppState> store = StoreProvider.of(context);
    Future.delayed(Duration(seconds: 1),(){
      AccessProvider.initAccessState(store).then((res){
        Navigator.pushReplacementNamed(context,MainPage.routePath);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child:Text('启动页')),
    );
  }
}