import 'package:cookiej/app/model/local/access.dart';
import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/service/repository/access_repository.dart';
import 'package:cookiej/app/service/repository/emotion_repository.dart';
import 'package:cookiej/app/service/repository/local_config_repository.dart';
import 'package:cookiej/app/service/repository/style_repository.dart';
import 'package:cookiej/app/service/repository/user_repository.dart';
import 'package:cookiej/app/views/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GetBuilder(
            init: AppViewModel(),
            builder: (AppViewModel vm) {
              return GetMaterialApp(
                title: '饼干微博',
                home: Index(),
                theme: vm.currentTheme,
              );
            }),
        onWillPop: () async {
          final platform = MethodChannel('android/back/desktop');
          //通知安卓返回,到手机桌面
          try {
            final bool out = await platform.invokeMethod('backDesktop');
            if (out) debugPrint('返回到桌面');
          } on PlatformException catch (e) {
            debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
            print(e.toString());
          }
          return false;
        });
  }
}

class AppViewModel extends GetxController {
  LocalConfig get _config => LocalConfigRepository.getLocalConfig();

  @override
  onInit() async {
    super.onInit();
    if (isLogin) {
      API.updateReceiveAccess(
          AccessRepository.getAccessFromLocal(_config.currentUserId));
      await EmotionRepository.initLocalEmotionBox();
    }
  }

  /// 是否登录
  bool get isLogin =>
      _config.loginUsers.isNotEmpty || _config.currentUserId.isNotEmpty;

  /// 当前主题
  ThemeData get currentTheme => StyleRepository.getThemeData(_config.themeName);

  /// 已登录的用户列表
  List<UserLite> get loginUsers => _config.loginUsers
      .map((uid) => UserRepository.getUserLiteFromLocal(uid))
      .toList();

  /// 当前用户
  UserLite get currentUser =>
      UserRepository.getUserLiteFromLocal(_config.currentUserId);

  /// 添加用户
  Future<void> addLocalUser(Access access) async {
    // 用户list里添加新用户
    _config.loginUsers.add(access.uid);
    await LocalConfigRepository.setLocalConfig(loginUsers: _config.loginUsers);
    // 将活跃用户改为该用户
    await _switchCurrentUser(access.uid);
    // 初始化表情
    await EmotionRepository.initLocalEmotionBox();
    update();
  }

  /// 删除某用户
  Future<void> removeLocalUser(String uid) async {
    _config.loginUsers.remove(uid);
    await LocalConfigRepository.setLocalConfig(loginUsers: _config.loginUsers);
    if (uid == _config.currentUserId) {
      if (_config.loginUsers.isNotEmpty)
        await _switchCurrentUser(_config.loginUsers[0]);
    }
    update();
  }

  /// 更换当前用户
  Future<void> switchCurrentUser(String uid) async {
    await _switchCurrentUser(uid);
    update();
  }

  Future<void> _switchCurrentUser(String uid) async {
    // 更新Dio设置
    API.updateReceiveAccess(AccessRepository.getAccessFromLocal(uid));
    // 将最新用户信息存入本地
    await UserRepository.saveUserLiteToLocal(
        await UserRepository.getUserInfo(uid: uid));
    await LocalConfigRepository.setLocalConfig(currentUserId: uid);
  }
}
