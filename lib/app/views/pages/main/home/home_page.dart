import 'dart:ui';
import 'package:cookiej/app/service/repository/user_repository.dart';
import 'package:cookiej/app/service/repository/weibo_repository.dart';
import 'package:cookiej/app/views/components/weibo/weibo_list_view.dart';
import 'package:flutter/material.dart';

class HomePageMixin {
  Future<Map<String, WeiboListVM>> getGroupsListVM() async {
    var groups = await UserRepository.getGroups();
    Map<String, WeiboListVM> map = {};
    groups.forEach((group) {
      map[group.name] =
          WeiboListVM(WeibosType.Group, groupId: group.id.toString());
    });
    return map;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, HomePageMixin {
  Map<String, WeiboListVM> _tabsMap = {
    '全部关注': WeiboListVM(WeibosType.Home),
    '好友圈': WeiboListVM(WeibosType.Bilateral)
  };
  @override
  void initState() {
    getGroupsListVM().then((groupMap) {
      setState(() {
        _tabsMap.addAll(groupMap);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabController = TabController(length: _tabsMap.length, vsync: this);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 8, right: 8),
            //color:_theme.primaryColor,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TabBar(
                  controller: tabController,
                  labelPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  tabs: _tabsMap.keys.map((str) => Text(str)).toList(),
                  isScrollable: true,
                  indicatorColor: Theme.of(context).selectedRowColor,
                  onTap: (index) {
                    //_pageController.jumpToPage(index);
                  },
                )),
                //搜索按钮
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 8),
                    height: 36,
                    width: 36,
                    child: Icon(Icons.search,
                        color: theme.primaryTextTheme.bodyText1.color),
                  ),
                  onTap: () {},
                )
              ],
            ),
            decoration: BoxDecoration(color: theme.primaryColor, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, -3),
                  blurRadius: 5,
                  spreadRadius: 0.5)
            ]),
          ),
          preferredSize: Size.fromHeight(46)),
      body: TabBarView(
        controller: tabController,
        children:
            _tabsMap.values.map((listVM) => WeiboListView(listVM)).toList(),
      ),
    );
  }
}
