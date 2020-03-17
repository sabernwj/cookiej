import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

class AccessInterceptor extends InterceptorsWrapper{
  final Access access;
  int httpCount=0;
  AccessInterceptor(this.access);
  @override
  onRequest(RequestOptions options) async{
    if(access!=null){
      var url=options.path;
      var params= {"access_token":access.accessToken};
      options.path=Utils.formatUrlParams(url, params);
      httpCount++;
      print('${access.uid} 已发起请求次数'+httpCount.toString()+':'+url);
      //加载cookie
    }
    return options;
}

}