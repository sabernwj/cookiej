import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

part 'local_config.g.dart';

@HiveType(typeId: HiveBoxType.localConfigBox)
class LocalConfig {
  // 用户相关

  @HiveField(0)
  String currentUserId;

  @HiveField(1)
  List<String> loginUsers;

  // 显示设置

  @HiveField(2)
  bool isDarkMode;

  @HiveField(3)
  String fontName;

  @HiveField(4)
  String themeName;

  @HiveField(5)
  String i18nName;

  @HiveField(6)
  bool isDarkModeAuto;

  // 过滤设置

  @HiveField(7)
  List<String> filterWords;

  @HiveField(8)
  bool isFilterWeibo;

  @HiveField(9)
  bool isFilterComment;

  // 浏览设置

  @HiveField(10)
  bool isNoPictureMode;

  @HiveField(11)
  bool useInternalBrowser;

  LocalConfig();

  LocalConfig.defaultValue() {
    currentUserId = '';
    loginUsers = [];
    isDarkMode = false;
    fontName = '';
    themeName = '';
    i18nName = '';
    isDarkModeAuto = false;
    filterWords = [];
    isFilterWeibo = false;
    isFilterComment = false;
    isNoPictureMode = false;
    useInternalBrowser = true;
  }
}
