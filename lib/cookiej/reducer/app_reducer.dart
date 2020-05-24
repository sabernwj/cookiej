
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/reducer/access_reducer.dart';
import 'package:cookiej/cookiej/reducer/theme_reducer.dart';
import 'package:cookiej/cookiej/reducer/user_reducer.dart';
import 'package:redux/redux.dart';




AppState appReducer(AppState state,action){
  return AppState(
    accessState: accessReducer(state.accessState,action),
    currentUser: userReducer(state.currentUser,action),
    themeState:themeDataReducer(state.themeState,action),
  );
}

final List<Middleware<AppState>> middleware=[
  AccessMiddleware()
];