import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../../../controller/apiController.dart';

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
        title: new Text("用户授权"),
      ),
      url: ApiController.getOauth2Authorize(),
    );
  }
}