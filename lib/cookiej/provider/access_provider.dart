import 'dart:convert';
import 'dart:async';
import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/access_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/utils/local_storage.dart';

class AccessProvider{

  // static Future<ProviderResult<AccessState>> initAccessState() async{
  //   var readLocalAccess=await getAccessStateLocal();

  //   return readLocalAccess;
  // }

  static Future<ProviderResult<AccessState>> getAccessStateLocal() async{
    var accessStateText=await LocalStorage.get(Config.accessStateStorageKey);
    if(accessStateText!=null&&accessStateText.isNotEmpty){
      AccessState accessState=AccessState.fromJson(json.decode(accessStateText));
      if(accessState.loginAccesses.length==0){
        return ProviderResult(null,false);
      }
      return ProviderResult(accessState,true);
    }else{
      return ProviderResult(null, false);
    }
  }

  static Future<ProviderResult<Access>> getAccessNet(String code) async{
    var accessText=await AccessApi.getOauth2Access(code);
    var access = Access.fromJson(json.decode(accessText));
    return ProviderResult(access,true);
  }

  static saveAccessStateLocal(AccessState accessState) async{
    await LocalStorage.save(Config.accessStateStorageKey, accessState.toJson());
  }

}