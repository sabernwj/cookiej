import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
class SwitchTheme extends StatelessWidget {

  final themeColors=CookieJColors.themeColors;

  @override
  Widget build(BuildContext context) {
    final store=StoreProvider.of<AppState>(context);
    final bool isDarkMode= store.state.themeState.themeData.brightness==Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title:Text('主题切换')
      ),
      body: Container(
        margin: EdgeInsets.only(top:16),
        child: ListView.builder(
          itemBuilder: (context,index){
            final names=themeColors.keys.toList();
            return Container(
              child: ListTile(
                leading:Container(height: 40,width:40,color:themeColors[names[index]],),
                title: Text(names[index]),
                onTap: (){
                  // CookieJColors.pushTheme(store, names[index]);
                  store.dispatch(RefreshThemeState(ThemeState(names[index],CookieJColors.getThemeData(names[index],isDarkMode: isDarkMode))));
                  LocalStorage.save(Config.themeNameStorageKey, names[index]);
                },
                selected: store.state.themeState.themeName==names[index],
              ),
              decoration:BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
            );
          },
          itemCount: themeColors.length,
        )
      ),
    );
  }
}