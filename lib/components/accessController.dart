import 'httpController.dart';

class AccessController {
  //加载accessToken
 static loadOauth2AccessToken(String url) async{
    var uri=Uri.tryParse(url);
    try{
      var code= uri.queryParameters["code"];
      if(code.isNotEmpty){
        var accessToken=await HttpController.getOauth2AccessToken(code);
        HttpController.setOauth2AccessToken(accessToken??"");
      }
    }catch(err){
      return;
    }
  }
}