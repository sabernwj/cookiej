import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
class SwitchTheme extends StatelessWidget {

  final themeColors=CookieJColors.themeColors;
  
  @override
  Widget build(BuildContext context) {
    final store=StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text('主题切换')
      ),
      body: Container(
        margin: EdgeInsets.only(top:16),
        child: ListView.builder(
          itemBuilder: (context,index){
            return Container(
              child: ListTile(
                leading:Container(height: 40,width:40,color:themeColors[index],),
                onTap: (){
                  CookieJColors.pushTheme(store, index);
                },
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