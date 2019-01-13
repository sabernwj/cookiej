import 'package:localstorage/localstorage.dart';


class LocalstorageHelper{
  static final LocalStorage _storage =new LocalStorage('key');

  static checkStorageIsReady(){
    return _storage.ready;
  }
  ///存入数据到storage缓存
  static bool setToStorage(String key,dynamic item){
    try{
      _storage.setItem(key, item);
      return true;
    }catch(e){
      return false;
    }
  }

  ///从storage缓存读取数据
  static dynamic getFromStorage(String key){
    try{
      var item=_storage.getItem((key));
      return item??'';
    }catch(e){
      return '';
    }
  }
}