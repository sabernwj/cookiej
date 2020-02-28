import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'dart:async';

class UserProvider{
  static final String _tableName=Config.userInfoDB_UserName;
  static final String _columnId=Config.userInfoDB_Id;
  static final String _columnUserName=Config.userInfoDB_UserName;
  static final String _columnIconId=Config.userInfoDB_IconId;
  static final String _columnData=Config.userInfoDB_Data;

  static ProviderResult getUserInfo(String uid){
    //首先尝试从本地读取

  }
  static Future<User> getUserInfoFromDB(String uid){

  }
}