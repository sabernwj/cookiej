import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/net/access_api.dart';
import 'package:cookiej/cookiej/page/main_page.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget{
  static final routePath='login';

  @override
  _LoginPageState createState()=>new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  @override
  void initState(){
    //监听是否获取新token
    final _flutterWebviewPlugin=new FlutterWebviewPlugin();
    _flutterWebviewPlugin.onUrlChanged.listen((url) async{
      if(url.contains(RegExp('code'))){
        _flutterWebviewPlugin.close();
        //登录成功，获取到code，下面获取access
        var provider=await AccessProvider.getAccessNet(Uri.tryParse(url).queryParameters['code']);
        if(provider.success){
          StoreProvider.of<AppState>(context).dispatch(AddNewAccess(provider.data));
          Navigator.pushReplacementNamed(context, MainPage.routePath);
        }
        _flutterWebviewPlugin.dispose();
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text("用户授权"),
      ),
      url: AccessApi.getOauth2Authorize(),
    );
  }
}