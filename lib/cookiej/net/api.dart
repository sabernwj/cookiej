import 'package:dio/dio.dart';
import 'package:cookiej/cookiej/config/config.dart';


class API{
  
  static const String baseUrl=Config.baseUrl;
  static const List<String> imgUrlPool=Config.imgBaseUrlPool;

  static Dio httpClient=Dio(BaseOptions(
    baseUrl: baseUrl
  ));
}
