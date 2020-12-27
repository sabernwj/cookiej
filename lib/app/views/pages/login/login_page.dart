import 'package:cookiej/app/app.dart';
import 'package:cookiej/app/provider/async_view_widget.dart';
import 'package:cookiej/app/service/repository/access_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class LoginPage extends AsyncViewWidget {
  final CookieManager cookieManager = CookieManager.instance();

  LoginPage() {
    cookieManager.deleteAllCookies();
  }

  @override
  Widget build(BuildContext context) {
    var appVM = Get.find<AppViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text("用户授权"),
      ),
      body: InAppWebView(
        initialUrl: 'https://passport.weibo.cn/signin/login?entry=mweibo',
        onLoadStart: (controller, url) async {},
        onLoadStop: (controller, url) async {
          debugPrint(url);
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
          if (url.contains('?code=')) {
            await controller.stopLoading();
            // 登录成功，下面获取access
            var access = await AccessRepository.getAccessFromNet(
                Uri.tryParse(url).queryParameters['code']);
            // 获取access成功后操作
            await appVM.addLocalUser(access);

            Navigator.pop(context);
          }
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
