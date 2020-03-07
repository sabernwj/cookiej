import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/action/user_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateCurrentUserAction 与 reducers 关联起来
/// 其实就等于定义一个函数，传入参数是(User,Action),然后判断action的class，调用不同的方法。
final userReducer =combineReducers<User>([

  TypedReducer<User,UpdateCurrentUser>((user,action){
    return(action.user);
  })
  
]);
