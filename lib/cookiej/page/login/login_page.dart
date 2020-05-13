import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/net/access_api.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class LoginPage extends StatelessWidget{
  final _flutterWebviewPlugin=new FlutterWebviewPlugin();
  @override
  Widget build(BuildContext context){
    _flutterWebviewPlugin.onUrlChanged.listen((url) async{
      _flutterWebviewPlugin.cleanCookies();
      if(url.contains('?code=')){
        _flutterWebviewPlugin.close();
        //登录成功，获取到code，下面获取access
        var provider=await AccessProvider.getAccessNet(Uri.tryParse(url).queryParameters['code']);
        if(provider.success){
          StoreProvider.of<AppState>(context).dispatch(AddNewAccess(provider.data));
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
          Navigator.pop(context);
        }
        _flutterWebviewPlugin.dispose();
      }
    });
    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text("用户授权"),
      ),
      url: AccessApi.getOauth2Authorize(),
    );
  }
}
