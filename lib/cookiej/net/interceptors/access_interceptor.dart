import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:cookiej/cookiej/utils/utils.dart';

class AccessInterceptor extends InterceptorsWrapper{
  final Access access;
  AccessInterceptor(this.access);
  @override
  onRequest(RequestOptions options) async{
    if(access!=null){
      var url=options.path;
      var params= {"access_token":access.accessToken};
      options.path=Utils.formatUrlParams(url, params);
      // httpcount++;
      // print('Http已发起请求次数'+httpcount.toString()+':'+url);
      //加载cookie
    }
    return options;
}

}