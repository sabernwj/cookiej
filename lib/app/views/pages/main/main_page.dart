import 'package:cookiej/app/app.dart';
import 'package:cookiej/app/service/repository/style_repository.dart';
import 'package:cookiej/app/views/pages/login/login_page.dart';
import 'package:cookiej/app/views/pages/main/personal/personal_page.dart';
import 'package:cookiej/app/views/pages/main/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<AppViewModel>();
    return Scaffold(
        appBar: vm.isLogin
            ? null
            : AppBar(
                title: Text('登录获取授权'),
              ),
        body: vm.isLogin
            ? IndexedStack(
                children: <Widget>[
                  HomePage(),
                  Container(),
                  Container(),
                  PersonalPage()
                ],
                index: _currentIndex,
              )
            : Center(
                child: RaisedButton.icon(
                icon: Icon(
                    const IconData(0xf18a,
                        fontFamily: StyleFonts.iconFontFamily),
                    size: 24),
                label: Text(
                  '去登录',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )),
        bottomNavigationBar: SizedOverflowBox(
          size: Size(double.infinity, 46),
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 5.0),
                    blurRadius: 5,
                    spreadRadius: 0.5)
              ]),
              child: BottomNavigationBar(
                //backgroundColor: _theme.dialogBackgroundColor,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    label: '主页',
                    icon: Icon(
                      const IconData(0xf2da,
                          fontFamily: StyleFonts.iconFontFamily),
                      size: 27,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '发现',
                    icon: Icon(
                      FontAwesomeIcons.solidCompass,
                      size: 26.3,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '消息',
                    icon: Icon(
                      FontAwesomeIcons.facebookMessenger,
                      size: 26,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '个人中心',
                    icon: Icon(
                      FontAwesomeIcons.userAlt,
                      size: 24,
                    ),
                  ),
                ],
                currentIndex: _currentIndex,
                iconSize: 30,
                onTap: (int index) {
                  setState(() {
                    if (index == _currentIndex) return;
                    _currentIndex = index;
                  });
                },
              )),
        ));
  }
}
