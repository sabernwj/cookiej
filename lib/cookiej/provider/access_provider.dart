import 'dart:convert';
import 'dart:async';
import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/access_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/utils/local_storage.dart';
import 'package:redux/redux.dart';

class AccessProvider{

  static Future<ProviderResult> initAccessState(Store store) async{
    var readLocalAccess=await getAccessStateLocal();
    //读取本地access信息成功
    if(readLocalAccess.success){
      store.dispatch(SetAccessState(readLocalAccess.data));
    }
    return readLocalAccess;
  }

  static Future<ProviderResult> getAccessStateLocal() async{
    var accessStateText=await LocalStorage.get(Config.accessStateStorageKey);
    if(accessStateText!=null){
      AccessState accessState=AccessState.fromJson(json.decode(accessStateText));
      return ProviderResult(accessState,true);
    }else{
      return ProviderResult(null, false);
    }
  }

  static Future<ProviderResult> getAccessNet(String code) async{
    var accessText=await AccessApi.getOauth2Access(code);
    var access = Access.fromJson(json.decode(accessText));
    return ProviderResult(access,true);
  }

  static setAccessStateLocal(AccessState accessState) async{
    await LocalStorage.save(Config.accessStateStorageKey, accessState.toJson());
  }

}