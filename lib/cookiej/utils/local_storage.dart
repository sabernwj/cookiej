import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

///SharedPreferences 本地存储
class LocalStorage {

  static Future<bool> save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value is Map){
      value=json.encode(value??'');
    }
    return prefs.setString(key, value);
  }

  static Future<String> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
