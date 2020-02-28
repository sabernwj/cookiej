
import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/net/interceptors/access_interceptor.dart';
import 'package:redux/redux.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';

final accessReducer=combineReducers<AccessState>([
  TypedReducer<AccessState,SetAccessState>(_setAccessState),
  TypedReducer<AccessState,UpdateCurrentAccess>(_updateCurrentAccess),
  TypedReducer<AccessState,AddNewAccess>(_addNewAccess),
  TypedReducer<AccessState,RemoveAccess>(_removeAccess)
]);

AccessState _setAccessState(AccessState accessState,SetAccessState action){
  return accessState;
}

AccessState _updateCurrentAccess(AccessState accessState,UpdateCurrentAccess action){
  accessState.currentAccess=action.access;
  //更换Dio拦截器使用的token
  API.httpClient.interceptors.removeWhere((interceptor)=>interceptor is AccessInterceptor);
  API.httpClient.interceptors.add(AccessInterceptor(accessState.currentAccess));
  return accessState;
}

AccessState _addNewAccess(AccessState accessState,AddNewAccess action){
  accessState.loginAccesses[action.access.uid]=action.access;
  //添加新用户后自动将当前用户切换为新添加的用户
  //我也不知道这里会不会触发State更改
  _updateCurrentAccess(accessState, UpdateCurrentAccess(action.access));
  AccessProvider.setAccessStateLocal(accessState);
  return accessState;
}

AccessState _removeAccess(AccessState accessState,RemoveAccess action){
  accessState.loginAccesses.remove(action.access.uid);
  if(accessState.loginAccesses.length==0){
    _updateCurrentAccess(accessState, UpdateCurrentAccess(null));
    AccessProvider.setAccessStateLocal(null);
  }else{
    _updateCurrentAccess(accessState, UpdateCurrentAccess(accessState.loginAccesses[0]));
    AccessProvider.setAccessStateLocal(accessState);
  }
  
  return accessState;
}