import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../../utils/httpController.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState()=>new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text("登录"),
      ),
      url: HttpController.getOauth2Authorize(),
    );
  }
}