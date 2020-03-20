import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:hive/hive.dart';

part 'local_state.g.dart';

@HiveType(typeId: CookieJHiveType.LocalState)
class LocalState extends HiveObject{
  static const boxName='local_state_box';

  @HiveField(0)
  String uid;
  @HiveField(1)
  bool isDarkMode;
  @HiveField(2)
  bool isDarkAuto;
  @HiveField(3)
  String themeName;
  @HiveField(4)
  UserLite userInfo;
  @HiveField(5)
  ////主页微博的分组信息
  List<String> weiboTypes;
  @HiveField(6)
  ///当前切换到的分组
  int weiboTypesIndex;

  LocalState(this.uid,{this.isDarkMode,this.themeName,this.isDarkAuto,this.userInfo,this.weiboTypes,this.weiboTypesIndex});

  LocalState.init(String uid){
    this.uid=uid;
    isDarkMode=false;
    isDarkAuto=false;
    themeName=CookieJColors.themeColors.keys.toList()[0];
  }

}