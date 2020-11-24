import 'package:cookiej/app/model/local/access.dart';
import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/service/repository/access_repository.dart';
import 'package:cookiej/app/service/repository/local_config_repository.dart';
import 'package:cookiej/app/service/repository/style_repository.dart';
import 'package:cookiej/app/service/repository/user_repository.dart';
import 'package:flutter/material.dart';

class GlobalViewModel extends ChangeNotifier {
  LocalConfig get _config => LocalConfigRepository.getLocalConfig();

  /// 是否登录
  bool get isLogin => _config.loginUsers.isNotEmpty;

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
    notifyListeners();
  }

  /// 删除某用户
  Future<void> removeLocalUser(String uid) async {
    _config.loginUsers.remove(uid);
    await LocalConfigRepository.setLocalConfig(loginUsers: _config.loginUsers);
    if (uid == _config.currentUserId) {
      if (_config.loginUsers.isNotEmpty)
        _switchCurrentUser(_config.loginUsers[0]);
    }
    notifyListeners();
  }

  /// 更换当前用户
  Future<void> switchCurrentUser(String uid) async {
    await _switchCurrentUser(uid);
    notifyListeners();
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
