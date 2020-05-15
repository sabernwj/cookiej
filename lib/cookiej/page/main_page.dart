import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/page/home/home_page.dart';
import 'package:cookiej/cookiej/page/discovery/discovery_page.dart';
import 'package:cookiej/cookiej/page/message/message_page.dart';
import 'package:cookiej/cookiej/page/login/login_page.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cookiej/cookiej/page/personal_center/personal_center.dart';

class MainPage extends StatefulWidget {
  static final String routePath = "main";  
  @override
  _MainPageState createState() => _MainPageState();
}

///APP显示部分的主要框架
class _MainPageState extends State<MainPage> {
  int _currentIndex=0;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final _theme=Theme.of(context);
    return StoreBuilder<AppState>(
      builder: (context,store){
        return Scaffold(
          appBar:store.state.accessState.currentAccess==null?AppBar(
            title: Text('登录获取授权'),
          ):null,
          body:store.state.accessState.currentAccess==null?
            Center(
                child:RaisedButton.icon(
                  icon: Icon(IconData(0xf18a,fontFamily: CookieJTextStyle.iconFontFamily),size: 24),
                  label: Text('去登录',style: TextStyle(fontSize:18),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  },
                )
                // child: CustomButton(
                //   shape: Border(),
                //   child: Text('去登录',style: _theme.textTheme.bodyText1.merge(TextStyle(fontSize:18)) ),
                //   onTap: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                //   },
                // )
            )
            :IndexedStack(
            children: <Widget>[
              HomePage(),
              //DiscoveryPage(),
              MessagePage(),
              PersonalCenter()
            ],
            index: _currentIndex,
          ),
          bottomNavigationBar: SafeArea(
            child: SizedBox(
              height:46,
              child:BottomNavigationBar(
                elevation: 0,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Container()
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(IconData(0xf14e,fontFamily: CookieJTextStyle.iconFontFamily)),
                  //   title: Container()
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_post_office),
                    title: Container()
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Container()
                  ),
                ],
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                iconSize: 30,
                onTap: (int index){
                  setState(() {
                    _currentIndex=index;
                  });
                },
              ),
            )
          )
        );
        
      },
    );
  }

}