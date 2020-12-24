import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _tabItems = useState(<String>['全部关注', '好友圈']);
    final _tabController =
        useTabController(initialLength: _tabItems.value.length);

    final _theme = Theme.of(context);
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
                  controller: _tabController,
                  labelPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  tabs: _tabItems.value.map((str) => Text(str)).toList(),
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
                        color: _theme.primaryTextTheme.bodyText1.color),
                  ),
                  onTap: () {},
                )
              ],
            ),
            decoration: BoxDecoration(color: _theme.primaryColor, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, -3),
                  blurRadius: 5,
                  spreadRadius: 0.5)
            ]),
          ),
          preferredSize: Size.fromHeight(46)),
      body: TabBarView(
        children: [],
      ),
    );
  }
}
