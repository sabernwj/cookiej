import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../home/home_page.dart';
import '../components/httpController.dart';


class Index extends StatefulWidget{
  @override
  State<Index> createState()=>new _IndexState();
}
class _IndexState extends State<Index> {

  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

  List<BottomNavigationBarItem> _navigationItems;
  int _currentIndex=0;

  @override
  void initState(){
    super.initState();
    HttpController.init();
  }
  //加载控件
  void loadWidget(){
    _pageList=<StatefulWidget>[
      new HomePage(),
      null,
      null
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
    _currentPage=_pageList[_currentIndex];
  }
  @override
  Widget build(BuildContext context){
    final loginPage=new LoginPage();
    loadWidget();
    final mainPage=new Scaffold(
      body: new Center(
        child: _currentPage,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: _navigationItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
            _currentIndex=index;
            print(_pageList[_currentIndex]);
            // _currentPage=_pageList[_currentIndex];
          });
        },
      ),
    );
    return new MaterialApp(
      title: '饼干酱',
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        indicatorColor: Colors.white
      ),
      home: loginPage,
    );
  }
}



