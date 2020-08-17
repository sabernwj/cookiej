import 'package:connectivity/connectivity.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/event/string_msg_event.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends InterceptorsWrapper{

  @override
  onRequest(RequestOptions options) async{
    //当没有网络时
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if(connectivityResult==ConnectivityResult.none){
      //无网络情况下直接进行异常处
      eventBus.fire(StringMsgEvent('没有网络'));
      throw DioError();
    }
    return super.onRequest(options);
  }

  @override
  onError(DioError err) async{
    if(err.type==DioErrorType.CONNECT_TIMEOUT){
      return null;
    }
    return super.onError(err);
  }
  @override
  onResponse(Response response) async{

    return super.onResponse(response);
  }
}