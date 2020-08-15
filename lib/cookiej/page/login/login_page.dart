import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/net/access_api.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_redux/flutter_redux.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    var cookieManager=CookieManager.instance();
    cookieManager.deleteAllCookies();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        title: new Text("用户授权"),
      ),
      body: InAppWebView(
        initialUrl:'https://passport.weibo.cn/signin/login',
        onLoadStart: (controller, url) async {
          print(url);
          if(url.contains('https://m.weibo.cn/')){
            controller.stopLoading();
            controller.loadUrl(url: AccessApi.getOauth2Authorize());
          }
          if(url.contains('?code=')){
            await controller.stopLoading();
            //登录成功，下面获取access
            var provider=await AccessProvider.getAccessNet(Uri.tryParse(url).queryParameters['code']);
            if(provider.success){
              StoreProvider.of<AppState>(context).dispatch(AddNewAccess(provider.data));
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
              Navigator.pop(context);
            }
          }
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


  // @override
  // Widget build(BuildContext context){
  //   var userNameController=TextEditingController();
  //   var passwordController=TextEditingController();
  //   userNameController.text='599123803@qq.com';
  //   passwordController.text='nwjleo5315187';
  //   return Scaffold(
  //     appBar: AppBar(title: Text('添加用户')),
  //     body: Container(
  //       child:Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           TextField(
  //             controller: userNameController,
  //             decoration: InputDecoration(
  //               hintText:'用户名',
  //             ),
  //           ),
  //           TextField(
  //             controller: passwordController,
  //             obscureText: true,
  //             keyboardType: TextInputType.visiblePassword,
  //             decoration: InputDecoration(
  //               hintText:'密码'
  //             ),
  //           ),
  //           Container(height: 32,),
  //           RaisedButton(
  //             child: Text('登录'),
  //             onPressed: (){
  //               if(userNameController.text.isNotEmpty&&passwordController.text.isNotEmpty){
  //                 AccessApi.loginByDio(userNameController.text, passwordController.text);
  //               }
  //             }
  //           )
  //         ],
  //       ),
  //       padding:EdgeInsets.symmetric(horizontal:32,vertical: 32)
  //     )
  //   );