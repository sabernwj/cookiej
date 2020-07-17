import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/page/home/home_page.dart';
import 'package:cookiej/cookiej/page/discovery/discovery_page.dart';
import 'package:cookiej/cookiej/page/message/message_page.dart';
import 'package:cookiej/cookiej/page/login/login_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cookiej/cookiej/page/personal_center/personal_center.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return StoreBuilder<AppState>(
      builder: (context,store){
        return WillPopScope(
          child: Scaffold(
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
                  DiscoveryPage(),
                  MessagePage(),
                  PersonalCenter()
                ],
              index: _currentIndex,
            ),
            bottomNavigationBar: SafeArea(
              child: SizedBox(
                height:46,
                child:Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 5.0),
                        blurRadius: 5,
                        spreadRadius: 0.5
                      )
                    ]
                  ),
                  child:BottomNavigationBar(
                    //backgroundColor: _theme.dialogBackgroundColor,
                    elevation: 0,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(IconData(0xf2da,fontFamily: CookieJTextStyle.iconFontFamily),size: 27,),
                        title: Container()
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.solidCompass,size: 26.3,),
                        title: Container()
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.facebookMessenger,size: 26,),
                        title: Container()
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.userAlt,size: 24,),
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
                  )
                ),
              )
            )
          ),
          onWillPop: () async{
            final platform = MethodChannel('android/back/desktop');
            //通知安卓返回,到手机桌面
            try {
                final bool out = await platform.invokeMethod('backDesktop');
                if (out) debugPrint('返回到桌面');
            } on PlatformException catch (e) {
                debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
                print(e.toString());
            }
            return false;
          }
        );
        
      },
    );
  }

}