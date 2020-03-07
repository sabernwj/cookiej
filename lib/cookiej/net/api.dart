import 'package:dio/dio.dart';

class API{
  
  static const String baseUrl='https://api.weibo.com';
  static final List<String> imgUrlPool=[
    'http://wx1.sinaimg.cn/',
    'http://wx2.sinaimg.cn/',
    'http://wx3.sinaimg.cn/',
    'http://ww1.sinaimg.cn/',
    'http://ww2.sinaimg.cn/',
    'http://ww3.sinaimg.cn/',
    'http://tva2.sinaimg.cn/',
    'http://tvax3.sinaimg.cn/',
  ];
  static Dio httpClient=Dio(BaseOptions(
    baseUrl: baseUrl
  ));
}
