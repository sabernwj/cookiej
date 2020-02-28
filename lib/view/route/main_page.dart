import 'package:flutter/material.dart';
import './home/home_page.dart';
import './personal_center/personal_center.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

///APP显示部分的主要框架
class _MainPageState extends State<MainPage> {
  List<Widget> _pageList;
  List<BottomNavigationBarItem> _navigationItems;
  int _currentIndex=0;
    //加载控件
  void loadWidget(){
    _pageList=<Widget>[
      new HomePage(),
      new Container(),
      new Container(),
      new PersonalCenter()
    ];
    _navigationItems=<BottomNavigationBarItem>[
      new BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: Container()
      ),
      new BottomNavigationBarItem(
        icon: new Icon(IconData(0xf14e,fontFamily: 'fontawesome')),
        title: Container()
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.message),
        title: Container()
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.person),
        title: Container()
      ),
    ];
  }
  @override
  void initState(){
    loadWidget();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:IndexedStack(
        children: _pageList,
        index: _currentIndex,
      ),
      bottomNavigationBar: SizedBox(
        height:46,
        child:BottomNavigationBar(
          items: _navigationItems,
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
    );
  }

}