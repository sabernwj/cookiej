
import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/net/interceptors/access_interceptor.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:redux/redux.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:cookiej/cookiej/action/user_state.dart';

final accessReducer=combineReducers<AccessState>([
  TypedReducer<AccessState,SetAccessState>(_setAccessState),
  TypedReducer<AccessState,UpdateCurrentAccess>(_updateCurrentAccess),
  TypedReducer<AccessState,AddNewAccess>(_addNewAccess),
  TypedReducer<AccessState,RemoveAccess>(_removeAccess)
]);

AccessState _setAccessState(AccessState accessState,SetAccessState action){
  return action.accessState;
}

AccessState _updateCurrentAccess(AccessState accessState,UpdateCurrentAccess action){
  if(accessState.loginAccesses.length==0){
    accessState.currentAccess=null;
    return accessState;
  }
  accessState.currentAccess=action.access;
  //如果像下面注释里一样换掉accessState的引用，通过addNewAccess调用的此函数，就等于没有更新到上一层函数里的accessState
  //accessState=AccessState(currentAccess: action.access,loginAccesses: accessState.loginAccesses);
  //更换Dio拦截器使用的token
  API.httpClient.interceptors.removeWhere((interceptor)=>interceptor is AccessInterceptor);
  API.httpClient.interceptors.add(AccessInterceptor(accessState.currentAccess));
  return accessState;
}

AccessState _addNewAccess(AccessState accessState,AddNewAccess action){
  accessState.loginAccesses[action.access.uid]=action.access;
  //添加新用户后自动将当前用户切换为新添加的用户
  //我也不知道这里会不会触发State更改(会触发的，因为这里直到return 都还属于dispatch的范围内，如果是异步的话，异步内的可能就执行不到了)
  //下面update中的accessState和最终本函数返回大的accessState是一个引用
  
  return accessState;
}

AccessState _removeAccess(AccessState accessState,RemoveAccess action){
  accessState.loginAccesses.remove(action.access.uid);
  if(accessState.loginAccesses.length==0){
    accessState.currentAccess=null;
    return accessState;
  }
  if(accessState.currentAccess.uid==action.access.uid){
    accessState.currentAccess=accessState.loginAccesses.values.toList()[0];
  }
  return accessState;
}

// AccessState _initAccessState(AccessState accessState,InitAccessState action){
//   AccessProvider.getAccessStateLocal();
//   //获取accessState成功

//   //更换显示的用户信息
// }
class AccessMiddleware implements MiddlewareClass<AppState>{
  @override
  call(Store<AppState> store, action, next) {
    if(action is InitAccessState){
      AccessProvider.getAccessStateLocal().then((res){
        //读取本地access成功，通过setAccess使用AccessState
        if(res.success){
          store.dispatch(SetAccessState(res.data));
          store.dispatch(UpdateCurrentAccess(res.data.currentAccess));
          
        }
      });
    }
    else if(action is AddNewAccess){
      next(action);
      store.dispatch(UpdateCurrentAccess(action.access));
      AccessProvider.saveAccessStateLocal(store.state.accessState);
    }else if(action is RemoveAccess){
      next(action);
      store.dispatch(UpdateCurrentAccess(store.state.accessState.currentAccess));
      AccessProvider.saveAccessStateLocal(store.state.accessState);
    }
    else if(action is UpdateCurrentAccess){
      next(action);
      if(action.access!=null){
        UserProvider.getUserInfo(store.state.accessState.currentAccess.uid).then((res){
          if(res.success){
            store.dispatch(UpdateCurrentUser(res.data));
          }
        });
      }else{
        store.dispatch(UpdateCurrentUser(User()));
      }
    }else{
      next(action);
    }
    
  } 
  
}