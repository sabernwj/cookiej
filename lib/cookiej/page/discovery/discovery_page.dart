import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/page/discovery/hot_page.dart';
import 'package:cookiej/cookiej/page/discovery/trend_page.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:cookiej/cookiej/page/widget/no_ink_behavior.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'dart:math'
    as math;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> with SingleTickerProviderStateMixin{


  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    _tabController=TabController(initialIndex: 0, length: 2, vsync: this);
    _pageController=PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return Scaffold(
      body: extended.NestedScrollView(
        headerSliverBuilder: (context,innerBoxIsScrolled){
          return <Widget>[
            SliverPersistentHeader(
              delegate: DiscoveryPageHeaderDelegate(
                minHeight: MediaQuery.of(context).padding.top+46,
                maxHeight: MediaQuery.of(context).padding.top+46,
                child: Container(
                  child:
                    SafeArea(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal:16),
                            alignment: Alignment.centerLeft,
                            child:Text(
                              '发现',
                              style: Theme.of(context).primaryTextTheme.subtitle1.merge(TextStyle(fontSize: 20)),
                            ),
                          ),
                          //搜索按钮
                          InkWell(
                            child:Container(
                              height: 36,
                              width: 36,
                              margin: EdgeInsets.only(left:8 ,right: 8),
                              child:Icon(Icons.search,color: _theme.primaryTextTheme.bodyText1.color),
                            ),
                            onTap: (){

                            },
                          )
                        ]
                      ),
                    ),
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                )
              )
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: DiscoveryPageHeaderDelegate(
                minHeight: 46,
                maxHeight: 46,
                child: Container(
                  color:_theme.primaryColor,
                  alignment:Alignment.center,
                  child:TabBar(
                    labelPadding: EdgeInsets.symmetric(vertical:8,horizontal:12),
                    isScrollable: true,
                    indicatorColor: Theme.of(context).selectedRowColor,
                    controller: _tabController,
                    tabs: [
                      Text('趋势'),
                      Text('热门')
                    ],
                    onTap: (index)=>_pageController.jumpToPage(index)
                  )
                )
              )
            )
          ];
        },
        body: CustomTabBarView(
          tabController: _tabController,
          pageController: _pageController,
          children: <Widget>[
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key('Tab0'),
              TrendPage(),
            ),
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key('Tab1'),
              HotPgae(),
            ),
          ],
        ),
          innerScrollPositionKeyBuilder: () {
            var index = "Tab";
            index +=(_tabController.index.toString());
            return Key(index);
          },
      ),
    );
  }
}

class DiscoveryPageHeaderDelegate extends SliverPersistentHeaderDelegate{

  final double minHeight;
  final double maxHeight;
  final Widget child;
  DiscoveryPageHeaderDelegate({@required this.minHeight,@required this.maxHeight,this.child,});
  @override
  Widget build(BuildContext context,double shrinkOffset, bool overlapsContent) {
    return FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: math.max(minExtent,maxExtent),
      child: child,
    );
  }
  //PictureProvider.getPictureFromUrl('https://www.bing.com/th?id=OHR.PoppyDeer_ZH-CN8317016056_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=HpEdgeAn')
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant DiscoveryPageHeaderDelegate oldDelegate) {
    return true;
  }
  
  
}