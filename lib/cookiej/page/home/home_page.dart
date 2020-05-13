import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:cookiej/cookiej/page/home/edit_weibo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final _theme=Theme.of(context);
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
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: '发微博',
              child: Icon(Icons.add,size: 36,color: _theme.primaryTextTheme.bodyText1.color,),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder:(context)=> EditWeiboPage()));
              },
            ),
          ),
        );
      },
    );
  }

  Map<WeiboTimelineType,Tab> getTabItems(){
    var tab=Map<WeiboTimelineType,Tab>();
    tab[WeiboTimelineType.Statuses]=Tab(text:WeiboTimelineType.Statuses.text);
    tab[WeiboTimelineType.Bilateral]=Tab(text:WeiboTimelineType.Bilateral.text);
    return tab;
  }

  List<WeiboListview> getTabViews(Map<WeiboTimelineType,Tab> tabs){
    var views=<WeiboListview>[];
    tabs.keys.forEach((timelineType){
      //备用添加groupId
      if(timelineType==WeiboTimelineType.Group){
        views.add(new WeiboListview(timelineType: timelineType,groupId: null,));
      }else{
        views.add(new WeiboListview(timelineType: timelineType));
      }
      
    });
    return views;
  }
  
}