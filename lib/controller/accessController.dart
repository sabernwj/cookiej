import 'httpController.dart';
import '../ultis/localstorageHelper.dart';
import 'dart:async';

class AccessController {

  static String _accessTokenName='accessToken';

  static void init(){
    
  }

  ///用于加载token，加载失败返回false
  static bool loadOauth2AccessToken(){
    try{
      String token=LocalstorageHelper.getFromStorage(_accessTokenName);
      if(token==null||token.isEmpty){
        return false;
      }else{
        HttpController.setTokenToHttpClient(token);
        // print('获取到token：'+token);
        return true;
      }

    }catch(err){
      return false;
    }
  }

  ///根据code获取新的accessToken
 static Future<bool> setNewOauth2AccessToken(String url) async{
    var uri=Uri.tryParse(url);
    var accessToken='';
    try{
      var code= uri.queryParameters["code"];
      if(code.isNotEmpty){
        accessToken=await HttpController.getOauth2AccessToken(code);
      }
    }catch(err){
      return false;
    }

    //此处假装我们已经获取到了accessToken
    LocalstorageHelper.setToStorage(_accessTokenName, accessToken);
    loadOauth2AccessToken();
    return true;
  }

  ///检测AccessToken是否有效
  static checkOauth2AccessToken(){
    
  }

}