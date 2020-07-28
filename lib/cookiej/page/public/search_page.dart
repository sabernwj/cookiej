import 'dart:ui';
import 'package:cookiej/cookiej/net/search_api.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:cookiej/cookiej/page/widget/no_ink_behavior.dart';
import 'package:cookiej/cookiej/page/widget/search_listview.dart';
import 'package:cookiej/cookiej/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {

  String hintText='搜点什么...';
  TabController _tabController;
  PageController _pageController;
  TextEditingController _editingController;
  bool isGetResult=false;
  List<Widget> _tabs;
  Future<List<String>> getSearchRecommendTask;
  FocusNode _focusNode;
  List<Widget> _tabChildrens;

  @override
  void initState() {
    super.initState();
    _tabs=SearchApiType.allType.map((e) => Text(e.text)).toList();
    _tabChildrens=SearchApiType.allType.map((e) => SearchListView(
      getSearchResult:getSearchResultFunction,
      searchApiType:e
    )).toList();
    _editingController=TextEditingController();
    _tabController=TabController(length: _tabs.length, vsync: this);
    _pageController=PageController();
    _focusNode=FocusNode();
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
                  controller: _editingController,
                  maxLines: 1,
                  focusNode: _focusNode,
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
                      //点击右上角搜索按钮时
                      onTap: (){
                        var value=_editingController.text;
                        if(value==null||value.isEmpty) return;
                        isGetResult=true;
                        setState(() {
                          _tabChildrens=SearchApiType.allType.map((e) => SearchListView(
                            key: Key(_editingController.text+e.text),
                            getSearchResult:getSearchResultFunction,
                            searchApiType:e
                          )).toList();
                          _focusNode.unfocus();
                        });
                      },

                    ),
                    contentPadding: EdgeInsets.symmetric(vertical:0,horizontal:4),
                    hintText: hintText,
                  ),
                  textInputAction: TextInputAction.search,
                  //按下键盘搜索按钮时
                  onSubmitted: (value) async{
                    if(value==null||value.isEmpty) return;
                    isGetResult=true;
                    setState(() {
                      _tabChildrens=SearchApiType.allType.map((e) => SearchListView(
                        key: Key(_editingController.text+e.text),
                        getSearchResult:getSearchResultFunction,
                        searchApiType:e
                      )).toList();
                    });
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
                  onTap: (value) => _pageController.jumpToPage(value),
                )
              )
              :Container()
            ]
          )
        ),
        preferredSize: Size.fromHeight(appbarHeight())
      ),
      //下面主体部分，上面代码是顶部固定的
      body: isGetResult
      ?CustomTabBarView(
        tabController: _tabController,
        pageController: _pageController,
        children: _tabChildrens,
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
                      list.map((str) => _buildGridItem([Expanded(child: Text(str,overflow: TextOverflow.ellipsis,))],onTap: (){
                        _editingController.text=str;
                        isGetResult=true;
                        setState(() {
                          _focusNode.unfocus();
                        });
                      })).toList(),
                      _theme,
                      crossAxisCount: 1,
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

  Future<List<dynamic>> getSearchResultFunction(SearchApiType searchType,int pageIndex) async {
    var result;
    if(searchType==SearchApiType.user){
      result=await SearchProvider.getSearchUserResult(_editingController.text,sType: searchType,pageIndex: pageIndex);
    }
    else result=await SearchProvider.getSearchResult(_editingController.text,sType: searchType,pageIndex: pageIndex);
    return result;
  }


  double appbarHeight(){
    if(isGetResult) return 84;
    else return 48;
  }

  Widget _buildGridItem(List<Widget> children,{Function onTap}){
    return InkWell(
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
      onTap:onTap
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

  Widget _buildGridviewWidget(String leftTitle,String rightTitle,List<Widget> grids,ThemeData _theme,{int crossAxisCount=2,Function onTap}){
    return Container(
      color: _theme.dialogBackgroundColor,
      margin:EdgeInsets.only(top:16),
      padding: EdgeInsets.symmetric(horizontal:8),
      child:Material(
        color:Colors.transparent,
        child:Column(
          children: <Widget>[
            InkWell(
              onTap:onTap,
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