import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

part 'local_config.g.dart';

@HiveType(typeId: HiveBoxType.localConfigBox)
class LocalConfig {
  @HiveField(0)
  String currentUserId;

  @HiveField(1)
  List<String> loginUsers;

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
}
