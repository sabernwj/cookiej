import 'package:cookiej/app/service/error/base_error.dart';
import 'package:flutter/foundation.dart';

class AppError extends BaseError {
  final AppErrorType errorType;

  /// 原始错误信息
  final rawErrorInfo;

  AppError(this.errorType, {String message, this.rawErrorInfo})
      : super(message) {
    if (errorType == AppErrorType.OtherError && message != null) {
      debugPrint(message);
    }
  }
}

enum AppErrorType {
  /// 无网络错误
  NoConnectionError,

  /// 超时错误
  TimeoutError,

  /// 接口无权限错误
  PermissionError,

  /// Token失效错误
  AuthorizationError,

  /// 解析json错误
  DecodeJsonError,

  /// 空请求结果错误
  EmptyResultError,

  /// 其他错误
  OtherError,
}
