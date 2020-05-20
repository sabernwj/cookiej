import 'dart:convert';

import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/net/friendships_api.dart';
import 'package:cookiej/cookiej/net/user_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'dart:async';
import 'package:cookiej/cookiej/db/sql_manager.dart';
import 'package:sqflite/sqlite_api.dart';

class UserProvider{
  static final String _tableName=Config.userInfoDB;
  static final String _columnId=Config.userInfoDB_Id;
  static final Map<String,String> _userModel={
    'id':'INTEGER',
    'data':'TEXT'
  };
  static Future<bool> init( Database db) async{
    if(!await SqlManager.isTableExits(_tableName)){
      db.execute(createTableSql());
      return true;
    }
    return false;
  }

  static String createTableSql(){
    var str=SqlManager.tableBaseString(_tableName, _columnId);
    _userModel.forEach((columnName,columnValue){
      str+='$columnName $columnValue,';
    });
    str= str.substring(0,str.length-1)+')';
    return str;
  }

  static Future<ProviderResult<User>> getUserInfo(String uid) async{
    //首先尝试从本地读取
    var result= await getUserInfoFromDB(uid);
    if(result.success){
      return result;
    }
    //本地获取失败再从网络获取
    return await getUserInfoFromNet(uid: uid);
    //获得之后存入本地

  }
  
  static Future<ProviderResult<User>> getUserInfoFromDB(String uid) async{
    Database db=await SqlManager.getCurrentDatabase();
    var result=await db.rawQuery('select * from $_tableName where id = $uid');
    if(result.length!=0){
      var user=User.fromJson(json.decode(result[0]['data']));
      return ProviderResult(user, true);
    }
    return ProviderResult(null, false);
  } 

  ///获取在本地已经登陆的用户
  static Future<ProviderResult<List<User>>> getLocalAccessUsers(AccessState accessState) async{
    if(accessState==null||accessState.loginAccesses.length==0){
      return ProviderResult(null, false);
    }
    var localUsers=<User>[];
    var accessList=accessState.loginAccesses.values.toList();
    for(int i=0;i<accessList.length;i++){
      var result= await getUserInfo(accessList[i].uid);
      if(result.success){
        localUsers.add(result.data);
      }
    }
    if(localUsers.length==0){
      return ProviderResult(null, false);
    }
    return ProviderResult(localUsers, true);
  }
  ///从网络上获取用户信息
  static Future<ProviderResult<User>> getUserInfoFromNet({String uid,String screenName}) async{
    return UserApi.getUserInfo(uid: uid,screenName: screenName)
      .then((json){
        if(json!=null){
          var result=User.fromJson(json);
          if(uid!=null) saveUserInfoToDB(result);
          return ProviderResult(result,true);
        }
        return ProviderResult(null, false);
      }).catchError((e)=>ProviderResult(null, false));
  }

  ///将用户信息存入本地数据库
  static Future<ProviderResult<bool>> saveUserInfoToDB(User user) async{
    Database db=await SqlManager.getCurrentDatabase();
    var model={
      'id':user.id,
      'data':json.encode(user.toJson())
    };
    //存入
    var result=await db.insert(_tableName,model);
    if(result==user.id){
      return ProviderResult(true,true);
    }
    return ProviderResult(false, false);
    //如果已存在，则更新
  }

  static Future<ProviderResult<List<User>>> getFriends({String uid,String screenName}) async {
    var jsonRes=await FriendshipsApi.getFriends(uid: uid,screenName: screenName);
    List<User> userList=[];
    jsonRes['users'].forEach((user)=>userList.add(User.fromJson(user)));
    if(userList.isNotEmpty) return ProviderResult(userList, true);
    return ProviderResult(null, false);
  }

  static Future<ProviderResult<List<User>>> getFollowers({String uid,String screenName}) async {
    var jsonRes=await FriendshipsApi.getFollowers(uid: uid,screenName: screenName);
    List<User> userList=[];
    jsonRes['users'].forEach((user)=>userList.add(User.fromJson(user)));
    if(userList.isNotEmpty) return ProviderResult(userList, true);
    return ProviderResult(null, false);
  }
}