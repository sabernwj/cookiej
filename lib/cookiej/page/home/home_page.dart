import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:cookiej/cookiej/page/home/edit_weibo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_redux/flutter_redux.dart';

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final _theme=Theme.of(context);
    return StoreBuilder<AppState>(
      builder:(context,store){
      Widget returnWidget= DefaultTabController(
        length:getTabItems().length,
          child: Scaffold(
            appBar: PreferredSize(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top:MediaQueryData.fromWindow(window).padding.top,left: 8,right: 8),
                color:_theme.primaryColor,
                child:Row(
                  children: <Widget>[
                    Expanded(
                      child: TabBar(
                        labelPadding: EdgeInsets.symmetric(vertical:6,horizontal:12),
                        tabs: getTabItems().values.toList(),
                        isScrollable: true,
                        indicatorColor: Theme.of(context).selectedRowColor,
                      )
                    ),
                    //搜索按钮
                    InkWell(
                      child:Container(
                        height: 36,
                        width: 36,
                        child:Icon(Icons.search,color: _theme.primaryTextTheme.bodyText1.color),
                      ),
                      onTap: (){

                      },
                    )
                  ],
                )
              ),
              preferredSize: Size.fromHeight(42)
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
          )
        );
        // returnWidget= AnnotatedRegion<SystemUiOverlayStyle>(
        //   child: returnWidget, 
        //   value: _theme.brightness==Brightness.light?SystemUiOverlayStyle.dark:SystemUiOverlayStyle.light
        // );
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: _theme.accentColor,
          statusBarBrightness: _theme.brightness,
        ));
        return returnWidget;
      },
    );
  }

  Map<WeiboTimelineType,Widget> getTabItems(){
    var tab=Map<WeiboTimelineType,Widget>();
    tab[WeiboTimelineType.Statuses]=Text(WeiboTimelineType.Statuses.text);
    tab[WeiboTimelineType.Bilateral]=Text(WeiboTimelineType.Bilateral.text);
    return tab;
  }

  List<WeiboListview> getTabViews(Map<WeiboTimelineType,Widget> tabs){
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