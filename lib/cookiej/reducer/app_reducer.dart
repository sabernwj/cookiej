import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/reducer/access_reducer.dart';
import 'package:flutter/material.dart';




AppState appReducer(AppState state,action){
  return AppState(
    accessState: accessReducer(state.accessState,action)
  );
}