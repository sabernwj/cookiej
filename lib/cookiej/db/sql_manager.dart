import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';

class SqlManager{
  static const _version=1;
  static const _dbName='cookiej.db';
  static Database _database;

  static Future<bool> init() async{
    final dbPath=await getDatabasesPath();
    //此处有一段逻辑，从本地存储读取AccessInfo

    String path=dbPath+_dbName;
    if(Platform.isIOS){
      path=dbPath+'/'+_dbName;
    }
    _database=await openDatabase(path,version:_version);
    //初始化
    return UserProvider.init(_database);
  }

  static String tableBaseString(String name, String primaryKey) {
    return '''
        create table $name (
        $primaryKey integer primary key autoincrement,
      ''';
  }

  ///判断表是否存在
  static Future<bool> isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }

  createTableString(String name, String columnId) {
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }
}