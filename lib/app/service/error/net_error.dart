import 'package:cookiej/app/service/error/base_error.dart';
import 'package:flutter/material.dart';

class NetError extends BaseError {
  final NetErrorType errorType;

  NetError(this.errorType, {String message}) : super(message) {
    if (errorType == NetErrorType.OtherError && message != null) {
      debugPrint(message);
    }
  }
}

enum NetErrorType {
  /// 无网络错误
  NoConnectionError,

  /// 超时错误
  TimeoutError,

  // 接口无权限错误
  PermissionError,

  // Token失效错误
  AuthorizationError,

  // 其他错误
  OtherError,
}
