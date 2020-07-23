
import 'package:cookiej/cookiej/page/discovery/hot_page.dart';
import 'package:cookiej/cookiej/page/discovery/trend_page.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'dart:math'
    as math;

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
    //final _theme=Theme.of(context);
    return Scaffold(
      body: extended.NestedScrollView(
        headerSliverBuilder: (context,innerBoxIsScrolled){
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: CustomSliverPersistentHeaderDelegate(
                floatHeight:34,
                fixedHeight: 36+MediaQuery.of(context).padding.top,
                topWidget: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:16),
                      child:Text(
                        '发现',
                        style: Theme.of(context).primaryTextTheme.subtitle1.merge(TextStyle(fontSize: 20)),
                      )
                    ),
                    // InkWell(
                    //   child:Container(
                    //     height: 36,
                    //     width: 36,
                    //     margin: EdgeInsets.only(left:8 ,right: 8),
                    //     child:Icon(Icons.search,color: _theme.primaryTextTheme.bodyText1.color),
                    //   ),
                    //   onTap: (){

                    //   },
                    // )
                  ],
                ),
                bottomWidgte: Container(
                  padding: EdgeInsets.only(bottom:2),
                  alignment:Alignment.center,
                  child:TabBar(
                    labelPadding: EdgeInsets.symmetric(vertical:4,horizontal:12),
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

class CustomSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate{

  final double floatHeight;
  final double fixedHeight;
  final Widget topWidget;
  final Widget bottomWidgte;

  CustomSliverPersistentHeaderDelegate({
    this.floatHeight,
    this.fixedHeight,
    this.topWidget,
    this.bottomWidgte
  });
  ///扩张时0->1
  double percentWithExpand(double shrinkOffset){
    return (this.maxExtent - this.minExtent-shrinkOffset)/(this.maxExtent - this.minExtent);
  }

  ///收缩时0->1
  double percentWithCollapse(double shrinkOffset){
    return shrinkOffset/(this.maxExtent - this.minExtent);
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Stack(
        overflow: Overflow.clip,
        fit:StackFit.expand,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, -shrinkOffset),
                  child: Opacity(
                    opacity: percentWithExpand(shrinkOffset).clamp(0.0, 1.0),
                    child: topWidget,
                  )
                )
              ],
            ),
          ),
          Padding(
            padding:EdgeInsets.only( top:MediaQuery.of(context).padding.top),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                bottomWidgte
              ]
            )
          )
          
        ],
      )
    );
    
  }
  
    @override
    double get maxExtent => fixedHeight+floatHeight;
  
    @override
    double get minExtent => fixedHeight;
  

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
  
}