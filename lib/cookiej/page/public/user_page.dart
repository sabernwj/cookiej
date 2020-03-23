
import 'dart:ui';

import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_list_mixin.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class UserPage extends StatefulWidget {
  final String userId;
  final String screenName;
  final User inputUser;
  UserPage({this.userId,this.screenName,this.inputUser});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with  WeiboListMixin,TickerProviderStateMixin{
  User activeUser;
  RefreshController _refreshController=RefreshController(initialRefresh:false);
  Future<WeiboListStatus> isFindUserComplete;
  @override
  void initState(){
    activeUser=User.fromUserLite(widget.inputUser??UserLite.init());
    activeUser.screenName=widget.screenName??null;
    activeUser.idstr=widget.userId;
    super.initState();
    Map<String,String> exraParams=new Map();
    if(activeUser.screenName!='.用户名.'){
      exraParams['screen_name']=activeUser.screenName;
    }
    if(activeUser.idstr!=null){
      exraParams['uid']=activeUser.idstr;
    }
    isFindUserComplete=UserProvider.getUserInfoFromNet(screenName: widget.screenName).then((result){
      if(result.success) {
        setState(() {
          activeUser=result.data;
        });
      }
      ///说明此时已经找到这个人的信息了，下面可以初始化拉取weiboList了
      weiboListInit(WeiboTimelineType.User,extraParams: exraParams);
      return startLoadData();
    }).catchError((e)=>false);
  }

  @override
  Widget build(BuildContext context) {
    final TabController _bottomTabbarController= TabController(initialIndex: 1, length: 4, vsync: this);
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        // header: ClassicHeader(
        //   refreshingText: '刷新中',
        //   failedText: '刷新失败',
        //   completeText:'刷新成功' ,
        //   releaseText: '刷新微博',
        //   idleText: '下拉刷新',
        // ),
        footer: ClassicFooter(
          failedText: '加载失败',
          canLoadingText: '加载更多',
          idleText: '加载更多',
          loadingText: '加载中',
          noDataText: '已无更多数据'
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context,_){
            return[
              SliverPersistentHeader(
                delegate: UserPageHeaderDelegate(
                  expandedHeight: 200,
                  user: activeUser,
                  topPadding: MediaQuery.of(context).padding.top,
                  bottomWidget: TabBar(
                    isScrollable: true,
                    controller: _bottomTabbarController,
                    tabs: [
                      Tab(text: '关于'),
                      Tab(text: '微博'),
                      Tab(text: '相册'),
                      Tab(text: '视频'),
                    ]
                  )
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _bottomTabbarController,
            children: [
              Container(),
              FutureBuilder(
                future: isFindUserComplete,
                builder: (context,snaphot){
                  if(snaphot.data!=WeiboListStatus.complete){
                    return Center(child:  CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: weiboList.length,
                    itemBuilder: (context,index){
                      return Container(
                        child:WeiboWidget(weiboList[index]),
                        margin: EdgeInsets.only(bottom:12),
                      );
                    }
                  );
                }
              ),
              Container(),
              Container()
            ]
          ),
        ),
        onRefresh: (){
          refreshData()
            .then((isComplete){
              if(isComplete==WeiboListStatus.complete) setState(() {
                _refreshController.refreshCompleted();
              });
              else _refreshController.refreshFailed();
            }).catchError((e)=>_refreshController.refreshFailed());
        },
        onLoading: (){
          loadMoreData()
            .then((isComplete){
              setState(() {
                if(isComplete==WeiboListStatus.nodata) _refreshController.loadNoData();
                if(isComplete==WeiboListStatus.complete) _refreshController.loadComplete();
                if(isComplete==WeiboListStatus.failed) _refreshController.loadFailed();
              });
            }).catchError((e)=>_refreshController.loadFailed());
        },
      ),
    );
  }
}

class UserPageHeaderDelegate extends SliverPersistentHeaderDelegate{

  final double collapsedHeight;
  final double expandedHeight;
  final double topPadding;
  final User user;

  final PreferredSizeWidget bottomWidget;

  UserPageHeaderDelegate({
    this.collapsedHeight,
    @required
    this.expandedHeight,
    this.topPadding,
    this.bottomWidget,
    this.user
  });

  ///展开时渐渐显示，适用于输入不带透明度的颜色
  Color showInExpand(Color color,double shrinkOffset){
    final int alpha = (percentWithExpand(shrinkOffset) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, color.red, color.green, color.blue);
  }
  ///收缩时渐渐显示，适用于输入不带透明度的颜色
  Color showInCollapse(Color color,double shrinkOffset){
    final int alpha = (percentWithCollapse(shrinkOffset) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, color.red, color.green, color.blue);
  }

  double getBlurValue(double shrinkOffset){
    return percentWithCollapse(shrinkOffset)*10 ;
  }

  ///扩张时0->1
  double percentWithExpand(double shrinkOffset){
    return (this.maxExtent - this.minExtent-shrinkOffset)/(this.maxExtent - this.minExtent);
  }

  ///收缩时0->1
  double percentWithCollapse(double shrinkOffset){
    return shrinkOffset/(this.maxExtent - this.minExtent);
  }

  double getIconSize(double shrinkOffset,double iconSize){
    return (percentWithExpand(shrinkOffset)*0.5+0.5)*iconSize;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final store=StoreProvider.of<AppState>(context);
    shrinkOffset=shrinkOffset.clamp(0, maxExtent-minExtent);
    final _theme=Theme.of(context);
    final _percentWithCollapse=percentWithCollapse(shrinkOffset);
    final _percentWithExpand=percentWithExpand(shrinkOffset);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //背景图
        Image(
          image: PictureProvider.getPictureFromUrl(user.coverImagePhone),
          fit: BoxFit.cover,
        ),
        //模糊遮罩
        Positioned(
          left: 0,right: 0,top: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: getBlurValue(shrinkOffset),
              sigmaY: getBlurValue(shrinkOffset)
            ),
            child: Container(
              height:maxExtent,
              width: MediaQuery.of(context).size.width,
              color: Colors.black12,
            ),
          )
        ),
        //顶栏
         SafeArea(
            bottom: false,
            child: Stack(
              children:<Widget>[
                Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Offstage(
                        offstage: percentWithCollapse(shrinkOffset)==1,
                        child:IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: showInExpand(_theme.primaryTextTheme.subhead.color, shrinkOffset),	
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: _theme.primaryTextTheme.subhead.color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ]
            )
          ),
        SafeArea(
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Container(
                padding: EdgeInsets.only(left:(10+16*_percentWithExpand),right: 32),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //头像
                  children: [
                    Row(
                      children:<Widget>[
                        SizedBox(
                          width:getIconSize(shrinkOffset,64),
                          height: getIconSize(shrinkOffset, 64),
                          child: CircleAvatar(backgroundImage: PictureProvider.getPictureFromId(user.iconId),radius: 20),
                        ),
                        Offstage(
                          offstage: _percentWithCollapse!=1,
                          child:Container(
                            margin: EdgeInsets.only(left:20),
                            child: Text(
                              user.screenName,
                              style: _theme.primaryTextTheme.subhead,
                            ),
                          )
                        ),
                      ],
                    ),
                    //私信和关注按钮
                    Offstage(
                      offstage: user.idstr==store.state.accessState.currentAccess.uid,
                      child: Row(
                        children: <Widget>[
                          CustomButton(
                            child: Icon(Icons.email,color: _theme.primaryTextTheme.body2.color),
                            color: showInExpand(_theme.primaryColor, shrinkOffset),
                            onTap: (){},
                          ),
                          CustomButton(
                            color: showInExpand(_theme.primaryColor, shrinkOffset),
                            child: Text(
                              (user.followMe&&user.following)?'互相关注'
                              :(user.following)?'已关注'
                              :(user.followMe)?'粉丝'
                              :'关注',
                              style: _theme.primaryTextTheme.body2,
                            ),
                            onTap: (){},
                          ),
                        ],
                      ),
                    ),
                    
                  ]
                ),
              ),
              Container(
                height: 64*_percentWithExpand,
                padding: EdgeInsets.only(left: 20,right: 20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(user.screenName,style: _theme.primaryTextTheme.subhead),
                        Text(user.description,style:_theme.primaryTextTheme.subtitle)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        FlatButton(onPressed: (){}, child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text(user.friendsCount.toString(),style: _theme.primaryTextTheme.subhead),
                            Text('关注',style: _theme.primaryTextTheme.subtitle)
                          ]
                        )),
                        FlatButton(onPressed: (){}, child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text(user.followersCount.toString(),style: _theme.primaryTextTheme.subhead),
                            Text('粉丝',style: _theme.primaryTextTheme.subtitle)
                          ]
                        )),
                      ],
                    )
                  ],
                )
              ),
              bottomWidget??Container()
            ]
          )
        )
      ],
    );
    
  }

  @override
  double get maxExtent => math.max(minExtent, expandedHeight+(bottomWidget!=null? bottomWidget?.preferredSize?.height : 0.0));

  @override
  double get minExtent => 48 + topPadding +(bottomWidget!=null? bottomWidget?.preferredSize?.height : 0.0);


  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // SliverAppbar里的是属性发生了变动再rebuild
    return true;
  }
  
}