import 'package:connectivity/connectivity.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:dio/dio.dart';

class API {
  static const baseUrl = '';

  static Dio _dioSend;
  static Dio _dioReceive;

  static Dio get httpClientReceive {
    _dioReceive = _dioReceive ??
        Dio(BaseOptions(
            connectTimeout: 6000, receiveTimeout: 6000, baseUrl: baseUrl));
    return _dioReceive;
  }

  static Dio get httpClientSend {
    _dioSend = _dioSend ??
        Dio(BaseOptions(
            connectTimeout: 6000, receiveTimeout: 6000, baseUrl: baseUrl));
    return _dioSend;
  }

  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // 无网络情况下直接抛出无网络异常
      throw (AppErrorType.NoConnectionError);
    }
    var dio = httpClientReceive;
    try {
      return await dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
    } on DioError catch (e) {
      throw (appErrorHandle(e));
    }
  }

  static Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    var dio = httpClientSend;
    try {
      return await dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } on DioError catch (e) {
      throw appErrorHandle(e);
    }
  }
}

/// 统一处理Dio错误
AppError appErrorHandle(DioError e) {
  // 超时异常
  if (e.type == DioErrorType.CONNECT_TIMEOUT) {
    throw AppError(AppErrorType.TimeoutError);
  }
  // 其他异常
  else if (e.type == DioErrorType.DEFAULT) {
    throw AppError(AppErrorType.OtherError);
  }
  // 可细分的Response异常
  switch (e.response.statusCode) {
    case 400:
      throw AppError(AppErrorType.OtherError);
      break;
    // 应该是接口权限不足
    case 403:
      throw AppError(AppErrorType.PermissionError);
      break;
    default:
      throw AppError(AppErrorType.OtherError,
          message: e.response.data.toString());
      break;
  }
}
