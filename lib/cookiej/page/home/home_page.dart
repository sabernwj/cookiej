import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  List<Tab> _tabs;
  List<Widget> _pageList;
  //int _currentIndex=0;
  //Widget _currentPage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    _tabs=<Tab>[
      new Tab(text: '全部关注',),
      new Tab(text: '好友圈',),
      new Tab(text: '特别关注',),
    ];
    _pageList=<Widget>[
      new WeiboListview(timelineType: WeiboTimelineType.Statuses),
      new WeiboListview(timelineType: WeiboTimelineType.Bilateral),
      new Container()
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    super.build(context);
    return new DefaultTabController(
      length:_tabs.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: new TabBar(
            tabs: _tabs,
            isScrollable: true,
            indicatorColor: Theme.of(context).selectedRowColor,
          ),
        ),
        body: TabBarView(
          children: _pageList,
        )
      ),
    );
  }
}