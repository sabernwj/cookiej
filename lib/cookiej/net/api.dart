import 'package:cookiej/cookiej/event/string_msg_event.dart';
import 'package:cookiej/cookiej/net/interceptors/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';


class API{
  
  static const String baseUrl=Config.baseUrl;
  static const List<String> imgUrlPool=Config.imgBaseUrlPool;

  ///默认的Http发射器，用于当前使用用户，关乎的全局状态
  static Dio httpClientDefault=Dio(BaseOptions(
    connectTimeout: 6000,
    receiveTimeout: 6000,
    baseUrl: baseUrl
  ));

  ///用于发送的HTTP请求器，随时要用于切换多用户发射请求，这里只用于局部状态
  static Dio httpClientSend=Dio(BaseOptions(//当http发射器要在后台上传东西得到时候，用两个http就很有必要了
    connectTimeout: 6000,
    receiveTimeout: 6000,
    baseUrl: baseUrl,
  ));

  ///封装get用于异常处理
  static Future<Response<T>> get<T>(
    String path, {
    Dio dio,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    dio=dio??httpClientDefault;
    try{
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress
      );
    }on DioError catch (e){
      dioErrorHandle(e);
      return null;
    }
  }

  ///封装post用于异常处理
  static Future<Response<T>> post<T>(
    String path, {
    Dio dio,
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    dio=dio??httpClientSend;
    try{
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options:options,
        cancelToken: cancelToken,
        onSendProgress:onSendProgress,
        onReceiveProgress: onReceiveProgress
      );
    }on DioError catch (e){
      dioErrorHandle(e);
      return null;
    }
  }

  static void dioErrorHandle(DioError e){
    var msg='未知HttpErrorMsg';
    switch(e.response.statusCode){
      case 400:
        switch((e.response.data as Map)['error_code']){
          case 10016:
            msg='错误:缺失必选参数';
            break;
          default:
            msg=(e.response.data as Map)['error'].toString();
        }
        break;
      default:
        
        break;
    }
    eventBus.fire(StringMsgEvent(msg));
  }

  static void init(){
    httpClientDefault.interceptors.add(ErrorInterceptor());
    httpClientSend.interceptors.add(ErrorInterceptor());
  }
}

