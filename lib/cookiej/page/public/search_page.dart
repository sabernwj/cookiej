import 'dart:ui';

import 'package:cookiej/cookiej/net/search_api.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:cookiej/cookiej/page/widget/no_ink_behavior.dart';
import 'package:cookiej/cookiej/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {

  String hintText='搜点什么...';
  TabController _tabController;
  PageController _pageController;
  bool isGetResult=false;
  List<Widget> _tabs;
  Future<List<String>> getSearchRecommendTask;

  @override
  void initState() {
    super.initState();
    _tabs=[
      Text('综合'),
      Text('用户'),
      Text('实时'),
      Text('关注'),
      Text('热门'),
      Text('图片'),
      Text('视频'),
    ];
    _tabController=TabController(length: _tabs.length, vsync: this);
    _pageController=PageController();
    getSearchRecommendTask=SearchProvider.getSearchRecommend();

  }

  @override
  Widget build(BuildContext context) {
    var _theme=Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top:MediaQueryData.fromWindow(window).padding.top),
          color:_theme.primaryColor,
          child:Column(
            children:[
              Container(
                height: 42,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  maxLines: 1,
                  scrollPadding: EdgeInsets.all(0),
                  decoration:InputDecoration(
                    fillColor:_theme.dialogBackgroundColor,
                    filled:true,
                    border: OutlineInputBorder(),
                    prefixIcon: InkWell(
                      child:Icon(Icons.arrow_back),
                      onTap: () => Navigator.pop(context),
                    ),
                    suffixIcon: InkWell(
                      child:Icon(Icons.search),

                    ),
                    contentPadding: EdgeInsets.symmetric(vertical:0,horizontal:4),
                    hintText: hintText,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) async{
                    var res=await SearchApi.getSearchResult(SearchApiType.all.id, value);
                    if(res!=null){

                    }
                  },
                ),
              ),
              isGetResult
              ?Container(
                alignment:Alignment.centerLeft,
                child:TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: _tabs,
                  indicatorColor: _theme.selectedRowColor,
                  labelPadding: EdgeInsets.symmetric(vertical:6,horizontal:12),
                )
              )
              :Container()
            ]
          )
        ),
        preferredSize: Size.fromHeight(appbarHeight())
      ),
      body: isGetResult
      ?CustomTabBarView(
        tabController: _tabController,
        pageController: _pageController,
        children: _tabs,
      )
      :Container(
        color: _theme.dialogBackgroundColor,
        child:Column(
          children:[
            // _buildGridviewWidget(
            //   '搜索记录','清除',
            //   [

            //   ],
            //   _theme
            // ),
            FutureBuilder(
              future: getSearchRecommendTask,
              builder: (context,snapot){
                if(snapot.hasData){
                  if(snapot.data!=null){
                    List<String> list=snapot.data;
                    return _buildGridviewWidget(
                      '热门搜索', '',
                      list.map((str) => _buildGridItem([Expanded(child: Text(str,overflow: TextOverflow.ellipsis,))])).toList(),
                      _theme,
                      crossAxisCount: 1
                    );
                  }
                }
                return Container();
              }
            )
          ]
        )
      )
    );
  }

  double appbarHeight(){
    if(isGetResult) return 84;
    else return 48;
  }

  Widget _buildGridItem(List<Widget> children){
    return InkWell(
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
      onTap:(){}
    );
  }

  // Widget _buildNoticeString(String text){
  //   return Container(
  //     padding:EdgeInsets.symmetric(vertical: 2,horizontal: 2),
  //     margin: EdgeInsets.symmetric(horizontal:2),
  //     child:Text(text??'',style: (TextStyle(color:Colors.white,fontSize: 12))),
  //     decoration: BoxDecoration(
  //       borderRadius:BorderRadius.circular(3),
  //       color:Colors.red[400],
  //     ),
  //   );
  // }

  Widget _buildGridviewWidget(String leftTitle,String rightTitle,List<Widget> grids,ThemeData _theme,{int crossAxisCount=2}){
    return Container(
      color: _theme.dialogBackgroundColor,
      margin:EdgeInsets.only(top:16),
      padding: EdgeInsets.symmetric(horizontal:8),
      child:Material(
        color:Colors.transparent,
        child:Column(
          children: <Widget>[
            InkWell(
              onTap:(){},
              child:Padding(
              padding:EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(leftTitle,style: _theme.textTheme.subtitle2.merge(TextStyle(fontSize: 14)),),
                    Text(rightTitle,style: _theme.textTheme.subtitle2.merge(TextStyle(fontSize: 14,color:_theme.accentColor)),),
                  ],
                ),
              )
            ),
            Divider(height:1),
            Padding(
              padding: EdgeInsets.symmetric(vertical:3),
                child: Material(
                  color:Colors.transparent,
                  child:ScrollConfiguration(
                    behavior: NoInkBehavior(),
                     child: WaterfallFlow.count(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      children: grids,
                    )
                )
                ),
            )
          ],
        )
      ),
    );
  }
}