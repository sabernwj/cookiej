
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/public/search_page.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_listview.dart';
import 'package:cookiej/cookiej/page/home/edit_weibo_page.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_redux/flutter_redux.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {


  List<String> tabItems=[];
  List<Widget> tabViews=[];
  TabController _tabController;
  PageController _pageController=PageController();
  String localUid;

  @override
  void initState() {
    super.initState();
    changeTabeState();
  }

  @override
  Widget build(BuildContext context){
    final _theme=Theme.of(context);
    return StoreBuilder<AppState>(
      builder:(context,store){
      Widget returnWidget=AnnotatedRegion<SystemUiOverlayStyle>(
          value: _theme.primaryColorBrightness==Brightness.dark
            ?SystemUiOverlayStyle.light
            :SystemUiOverlayStyle.dark,
          child: Material(
            color: _theme.primaryColor,
            child: Semantics(
              explicitChildNodes: true,
              child: Scaffold(
                appBar: PreferredSize(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top:MediaQueryData.fromWindow(window).padding.top,left: 8,right: 8),
                    //color:_theme.primaryColor,
                    child:Row(
                      children: <Widget>[
                        Expanded(
                          child: TabBar(
                            controller: _tabController,
                            labelPadding: EdgeInsets.symmetric(vertical:8,horizontal:12),
                            tabs: tabItems.map((str) => Text(str)).toList(),
                            isScrollable: true,
                            indicatorColor: Theme.of(context).selectedRowColor,
                            onTap: (index) {
                              _pageController.jumpToPage(index);
                            },
                          )
                        ),
                        //搜索按钮
                        InkWell(
                          child:Container(
                            margin: EdgeInsets.only(top:5,left: 8),
                            height: 36,
                            width: 36,
                            child:Icon(Icons.search,color: _theme.primaryTextTheme.bodyText1.color),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder:(context)=> SearchPage()));
                          },
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: _theme.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, -3),
                          blurRadius: 5,
                          spreadRadius: 0.5
                        )
                      ]
                    ),
                  ),
                  preferredSize: Size.fromHeight(46)
                ),
                body: CustomTabBarView(
                  tabController: _tabController,
                  pageController: _pageController,
                  children: tabViews,
                ),
                floatingActionButton: FloatingActionButton(
                  tooltip: '发微博',
                  child: Icon(Icons.add,size: 36,color: _theme.primaryTextTheme.bodyText1.color,),
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> EditWeiboPage()));
                  },
                ),
              ),
            ),
          ),
        );
        return returnWidget;
      },
      onInit: (store){
        localUid=store.state.accessState.currentAccess.uid;
      },
      onWillChange: (oldStore,store){
        if(localUid!=store.state.accessState.currentAccess.uid){
           localUid=store.state.accessState.currentAccess.uid;
          changeTabeState();
        }
      },
    );
  }

  Future<void> changeTabeState() async {
    try{
      init();
      var result=await UserProvider.getGroups();
      if(result.success){
        setState(() {
          List<Widget> tempTabViews=[];
          tempTabViews.addAll(tabViews);
          tabItems.addAll(result.data.map((group) => group.name).toList());
          tempTabViews.addAll(result.data.map((group) => WeiboListview(timelineType: WeiboTimelineType.Group,group: group,)).toList());
          tabViews=tempTabViews;
          _tabController=TabController(length: tabItems.length, vsync: this);
        });
      }
    }catch(e){
      init();
    }
  }
  void init(){
    setState(() {
      tabItems=[];
      tabViews=[];
      tabItems.add(WeiboTimelineType.Statuses.text);
      tabViews.add(WeiboListview(timelineType: WeiboTimelineType.Statuses));
      tabItems.add(WeiboTimelineType.Bilateral.text);
      tabViews.add(WeiboListview(timelineType: WeiboTimelineType.Bilateral));
      _tabController = TabController(length: tabItems.length, vsync: this);
    });
  }
}