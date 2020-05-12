import 'package:dio/dio.dart';
import 'package:cookiej/cookiej/config/config.dart';


class API{
  
  static const String baseUrl=Config.baseUrl;
  static const List<String> imgUrlPool=Config.imgBaseUrlPool;

  ///默认的Http发射器，用于当前使用用户，关乎的全局状态
  static Dio httpClientDefault=Dio(BaseOptions(
    connectTimeout: 3000,
    receiveTimeout: 3000,
    baseUrl: baseUrl
  ));

  ///用于发送的HTTP请求器，随时要用于切换多用户发射请求，这里只用于局部状态
  static Dio httpClientSend=Dio(BaseOptions(//当http发射器要在后台上传东西得到时候，用两个http就很有必要了
    connectTimeout: 3000,
    receiveTimeout: 3000,
    baseUrl: baseUrl
  ));


}
