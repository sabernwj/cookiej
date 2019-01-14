import 'package:flutter/material.dart';
import '../home/home_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _pageList;
  List<BottomNavigationBarItem> _navigationItems;
  int _currentIndex=0;
    //加载控件
  void loadWidget(){
    _pageList=<Widget>[
      new HomePage(),
      new Container(),
      new Container()
    ];
    _navigationItems=<BottomNavigationBarItem>[
      new BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: new Text('主页')
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.search),
        title: new Text('发现')
      ),
      new BottomNavigationBarItem(
        icon: new Icon(Icons.perm_identity),
        title: new Text('我的')
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
      bottomNavigationBar: new BottomNavigationBar(
        items: _navigationItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }

}