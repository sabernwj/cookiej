import 'package:cookiej/app/service/repository/access_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginPage extends StatelessWidget {
  final CookieManager cookieManager = CookieManager.instance();

  LoginPage({Key key}) : super(key: key) {
    cookieManager.deleteAllCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("用户授权"),
      ),
      body: InAppWebView(
        initialUrl: 'https://passport.weibo.cn/signin/login',
        onLoadStart: (controller, url) async {},
        onLoadStop: (controller, url) async {
          print(url);
          if (url.contains('?code=')) {
            await controller.stopLoading();
            // 登录成功，下面获取access
            var access = await AccessRepository.getAccessFromNet(
                Uri.tryParse(url).queryParameters['code']);
            // 获取access成功后操作
            Navigator.pop(context);
          }
          if (url.contains('https://m.weibo.cn/')) {
            await controller.stopLoading();
            var cookies =
                await cookieManager.getCookies(url: 'https://weibo.cn');
            List<String> cookiesStr = [];
            cookies.forEach((cookie) {
              cookiesStr.add('${cookie.name}=${cookie.value}');
            });
            var cookieStr = '';
            cookiesStr.forEach((str) {
              cookieStr += str + ';';
            });
            controller.loadUrl(
                url: AccessRepository.getOauth2Authorize(),
                headers: {'cookie': cookieStr});
          }
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
