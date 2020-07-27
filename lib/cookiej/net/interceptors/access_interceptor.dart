import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:dio/dio.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:hive/hive.dart';

class AccessInterceptor extends InterceptorsWrapper{
  final Access access;
  int httpCount=0;
  AccessInterceptor(this.access);
  @override
  onRequest(RequestOptions options) async{
    if(access!=null){
      var url=options.path;
      var params= {"access_token":access.accessToken};
      if(!url.contains('m.weibo.cn')) options.path=Utils.formatUrlParams(url, params);
      httpCount++;
      print('${access.uid} 已发起请求次数'+httpCount.toString()+':'+options.path);
      //加载cookie
      List<String> listCookieStr= Hive.box(HiveBoxNames.cookie).get(access.uid);
      var cookieStr='';
      listCookieStr.forEach((str) { 
        cookieStr+=str+';';
      });
      options.headers['cookie']=cookieStr;

    }
    return options;
}

}