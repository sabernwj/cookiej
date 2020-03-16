import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return StoreBuilder<AppState>(
      builder:(context,store){
        return DefaultTabController(
          length:getTabItems().length,
          child: new Scaffold(
            appBar: new AppBar(
              title: new TabBar(
                tabs: getTabItems().values.toList(),
                isScrollable: true,
                indicatorColor: Theme.of(context).selectedRowColor,
              ),
            ),
            body: TabBarView(
              children: getTabViews(getTabItems()),
            )
          ),
        );
      },
    );
  }

  Map<WeiboTimelineType,Tab> getTabItems(){
    var tab=Map<WeiboTimelineType,Tab>();
    tab[WeiboTimelineType.Statuses]=Tab(text:'全部关注');
    tab[WeiboTimelineType.Bilateral]=Tab(text:'朋友圈');
    return tab;
  }

  List<WeiboListview> getTabViews(Map<WeiboTimelineType,Tab> tabs){
    var views=<WeiboListview>[];
    tabs.keys.forEach((timelineType){
      views.add(new WeiboListview(timelineType: timelineType));
    });
    return views;
  }
  
}