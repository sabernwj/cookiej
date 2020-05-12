
import 'dart:ui';

import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
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
  final UserLite inputUser;
  UserPage({this.userId,this.screenName,this.inputUser});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with  WeiboListMixin,TickerProviderStateMixin{
  User activeUser;
  RefreshController _refreshController=RefreshController(initialRefresh:false);
  Future<WeiboListStatus> isFindUserComplete;
  TabController _bottomTabbarController;
  ///随滑动而遮挡的部分
  GlobalKey _overflowWidgetKey=GlobalKey();
  double _overflowWidgetSize;
  @override
  void initState(){
    _bottomTabbarController= TabController(initialIndex: 1, length: 4, vsync: this);
    activeUser=User.fromUserLite(widget.inputUser??UserLite.init());
    activeUser.screenName=widget.screenName??activeUser.screenName;
    activeUser.idstr=widget.userId;
    super.initState();
    Map<String,String> exraParams=new Map();
    if(activeUser.screenName!='.用户名.'){
      exraParams['screen_name']=activeUser.screenName;
    }
    if(activeUser.idstr!=null){
      exraParams['uid']=activeUser.idstr;
    }
    isFindUserComplete=UserProvider.getUserInfoFromNet(screenName: widget.screenName??activeUser.screenName).then((result){
      if(result.success) {
        setState(() {
          activeUser=result.data;
          _overflowWidgetSize=_overflowWidgetKey.currentContext.size.height;
          print(_overflowWidgetKey.currentContext.size.height);
        });
      }
      ///说明此时已经找到这个人的信息了，下面可以初始化拉取weiboList了
      weiboListInit(WeiboTimelineType.User,extraParams: exraParams);
      return startLoadData();
    }).catchError((e)=>false);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
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
                  overflowWidgetKey: _overflowWidgetKey,
                  overflowWidgetSize: _overflowWidgetSize,
                  expandedHeight: _overflowWidgetSize==null?260.0:(190.0+_overflowWidgetSize),
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
  final GlobalKey overflowWidgetKey;
  final double overflowWidgetSize;

  UserPageHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.topPadding,
    this.bottomWidget,
    this.user,
    this.overflowWidgetKey,
    this.overflowWidgetSize
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
        //随着收缩会移动到顶部的按钮
        SafeArea(
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Container(
                padding: EdgeInsets.only(left:(10+6*_percentWithExpand),right: 16+_percentWithCollapse*32),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //头像
                  children: [
                    Row(
                      children:<Widget>[
                        SizedBox(
                          width:getIconSize(shrinkOffset,64),
                          height: getIconSize(shrinkOffset, 64),
                          child:CircleAvatar(backgroundImage: PictureProvider.getPictureFromId(user.iconId),radius: 20),
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
                              (user==null||user.followMe==null||user.following==null)?''
                              :(user.followMe&&user.following)?'互相关注'
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
              //随着滑动而被遮盖的部分
              Container(
                key: overflowWidgetKey,
                height: overflowWidgetSize==null?null:(overflowWidgetSize*_percentWithExpand),
                padding: EdgeInsets.only(left: 16,right: 16),
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //用户名和签名
                      Text(user.screenName,style: _theme.primaryTextTheme.subtitle1),
                      Text(user.description,style:_theme.primaryTextTheme.subtitle2,softWrap: true),
                      Row(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Text('关注',style: _theme.primaryTextTheme.subtitle2),
                              Container(width: 6),
                              Text(Utils.formatNumToChineseStr(user.friendsCount),style: _theme.primaryTextTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.bold))),
                            ]
                          ),
                          Container(
                            width: 12,
                            height: 36,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Text('粉丝',style: _theme.primaryTextTheme.subtitle2),
                              Container(width: 6),
                              Text(Utils.formatNumToChineseStr(user.followersCount),style: _theme.primaryTextTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.bold))),
                              
                            ]
                          ),
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
  double get maxExtent => math.max(minExtent, expandedHeight??260+(bottomWidget!=null? bottomWidget?.preferredSize?.height : 0.0));

  @override
  double get minExtent => 52 + topPadding +(bottomWidget!=null? bottomWidget?.preferredSize?.height : 0.0);


  @override
  bool shouldRebuild(covariant UserPageHeaderDelegate oldDelegate) {
    // SliverAppbar里的是属性发生了变动再rebuild
    return collapsedHeight!=oldDelegate.collapsedHeight
    || expandedHeight!=oldDelegate.expandedHeight;
    // || topPadding!=oldDelegate.topPadding
    // || user!=oldDelegate.user
    // || bottomWidget!=oldDelegate.bottomWidget;
    
  }
  
}