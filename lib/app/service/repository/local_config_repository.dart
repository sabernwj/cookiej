import 'package:cookiej/app/model/local/local_config.dart';
import 'package:cookiej/app/service/db/hive_service.dart';

class LocalConfigRepository {
  static final _localConfigBox = HiveService.localConfigBox;
  static const _localConfigKey = 'defaultLocalConfigKey';

  /// 获取本地配置
  static LocalConfig getLocalConfig() {
    return _localConfigBox.get(_localConfigKey);
  }

  /// 更新本地配置
  static Future<void> setLocalConfig(
      {LocalConfig newLocalConfig,
      String currentUserId,
      List<String> loginUsers,
      bool isDarkMode,
      String fontName,
      String themeName,
      String i18nName,
      bool isDarkModeAuto,
      List<String> filterWords,
      bool isFilterWeibo,
      bool isFilterComment,
      bool isNoPictureMode,
      bool useInternalBrowser}) async {
    if (newLocalConfig != null) {
      _localConfigBox.put(_localConfigKey, newLocalConfig);
    } else {
      var config = _localConfigBox.get(_localConfigKey);
      config.currentUserId = currentUserId ?? config.currentUserId;
      config.loginUsers = loginUsers ?? config.loginUsers;
      config.isDarkMode = isDarkMode ?? config.isDarkMode;
      config.fontName = fontName ?? config.fontName;
      config.themeName = themeName ?? config.themeName;
      config.i18nName = i18nName ?? config.i18nName;
      config.isDarkModeAuto = isDarkModeAuto ?? config.isDarkModeAuto;
      config.filterWords = filterWords ?? config.filterWords;
      config.isFilterWeibo = isFilterWeibo ?? config.isFilterWeibo;
      config.isFilterComment = isFilterComment ?? config.isFilterComment;
      config.isNoPictureMode = isNoPictureMode ?? config.isNoPictureMode;
      config.useInternalBrowser =
          useInternalBrowser ?? config.useInternalBrowser;

      await _localConfigBox.put(_localConfigKey, config);
    }
  }
}
