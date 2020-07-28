import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/discovery/discovery_page.dart';
import 'package:cookiej/cookiej/page/widget/comments/comment_listview_me.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:cookiej/cookiej/page/widget/weibo/user_weibo_listview.dart';

import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;


class ShowMessagePage extends StatefulWidget {
  final int initialIndex;

  const ShowMessagePage({Key key, this.initialIndex=0}) : super(key: key);

  @override
  _ShowMessagePageState createState() => _ShowMessagePageState();
}

class _ShowMessagePageState extends State<ShowMessagePage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    _tabController=TabController(initialIndex: widget.initialIndex, length: 4, vsync: this);
    _pageController=PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return Scaffold(
      body:extended.NestedScrollView(
        headerSliverBuilder: (context,innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              title:Text('我的通知')
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: DiscoveryPageHeaderDelegate(
                minHeight: 36+MediaQuery.of(context).padding.top,
                maxHeight: 36+MediaQuery.of(context).padding.top,
                child: Container(
                  padding: EdgeInsets.only(bottom:4,left: 8,right: 8),
                  color:_theme.primaryColor,
                  alignment:Alignment.bottomCenter,
                  child:TabBar(
                    labelPadding: EdgeInsets.symmetric(vertical:4,horizontal:12),
                    isScrollable: true,
                    indicatorColor: Theme.of(context).selectedRowColor,
                    controller: _tabController,
                    tabs: [
                      Text('@我的微博'),
                      Text('@我的评论'),
                      Text('收到的评论'),
                      Text('发出的评论')
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
            //WeiboListview(timelineType:WeiboTimelineType.Mentions),
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key('Tab0'),
              UserWeiboListView(screenName: null,type: WeiboTimelineType.Mentions,),
            ),
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key('Tab1'),
              CommentListviewMe(type: CommentsType.Mentions),
            ),
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key('Tab2'),
              CommentListviewMe(type: CommentsType.ToMe),
            ),
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key('Tab3'),
              CommentListviewMe(type: CommentsType.ByMe),
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

