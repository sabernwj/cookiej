import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../login/login_page.dart';
import './main_page.dart';
import '../utils/localstorageHelper.dart';
import '../utils/accessController.dart';

class Index extends StatefulWidget{
  @override
  State<Index> createState()=>new _IndexState();
}
class _IndexState extends State<Index> {

  Widget _acitveIndex;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    //登录页
    var loginPage=new LoginPage();
    //主页
    var mainPage= new MainPage();
    //监听是否获取新token
    final _flutterWebviewPlugin=new FlutterWebviewPlugin();
    _flutterWebviewPlugin.onUrlChanged.listen((url){
      AccessController.setNewOauth2AccessToken(url).then((result){
        if(result==true){
          setState(() {
            _acitveIndex=mainPage;
          });
        }
      });
    });
    Future storageReady=LocalstorageHelper.checkStorageIsReady();
    storageReady.then((ready)=>
      //判断进入登录页或者主页
      _acitveIndex=AccessController.loadOauth2AccessToken()?mainPage:loginPage
    );
    return FutureBuilder(
      future: LocalstorageHelper.checkStorageIsReady(),
      builder: (BuildContext context,snapshot){
        if(snapshot.data!=true){
          _acitveIndex=new Center(
            child: new CircularProgressIndicator(),
          );
        }
        return new MaterialApp(
          title: '饼干酱',
          home: new Container(
            child: _acitveIndex,
          )
        );
      }
    );

  }
}



