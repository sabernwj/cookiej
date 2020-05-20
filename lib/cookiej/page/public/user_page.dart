
import 'dart:ui';

import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/widget/custom_tabbarview.dart';
import 'package:cookiej/cookiej/page/widget/weibo/user_weibo_listview.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';
import 'dart:math' as math;

class UserPage extends StatefulWidget {
  final String userId;
  final String screenName;
  final UserLite inputUser;
  UserPage({this.userId,this.screenName,this.inputUser});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin{
  User activeUser;
  Future<bool> isFindUserComplete;
  TabController _bottomTabbarController;
  PageController _bottomPageController;
  ScrollController _scrollController;
  ///随滑动而遮挡的部分
  GlobalKey _overflowWidgetKey=GlobalKey();
  double _overflowWidgetSize;
  @override
  void initState(){
    _bottomPageController=PageController(initialPage: 2);
    _bottomTabbarController= TabController(initialIndex: 2, length: 5, vsync: this);
    _scrollController=ScrollController();
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
        return true;
      }
      return false;
      ///说明此时已经找到这个人的信息了，下面可以初始化拉取weiboList了
    }).catchError((e)=>false);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:extended.NestedScrollViewRefreshIndicator(
        onRefresh: () async{
          //暂时禁用刷新功能，因为未找到识别主页中置顶微博的特征
          //eventBus.fire(FunctionCallBack.UserPageRefresh);
        },
        child: extended.NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context,_){
            return[
              SliverPersistentHeader(
                delegate: UserPageHeaderDelegate(
                  overflowWidgetKey: _overflowWidgetKey,
                  overflowWidgetSize: _overflowWidgetSize,
                  expandedHeight: _overflowWidgetSize==null?355.9:(220.0+_overflowWidgetSize),
                  user: activeUser,
                  topPadding: MediaQuery.of(context).padding.top,
                  bottomWidget: TabBar(
                    isScrollable: true,
                    controller: _bottomTabbarController,
                    tabs: [
                      Tab(text: '关于'),
                      Tab(text: '原创'),
                      Tab(text: '微博'),
                      Tab(text: '相册'),
                      Tab(text: '视频'),
                    ],
                    onTap: (index)=>_bottomPageController.jumpToPage(index),
                  )
                ),
                pinned: true,
              ),
            ];
          },
          //body: Container(),
          body:FutureBuilder(
            future: isFindUserComplete,
            builder: (context,snaphot){
              if(snaphot.data!=true){
                return Center(child:  CircularProgressIndicator());
              }
              return CustomTabBarView(
                pageController: _bottomPageController,
                tabController: _bottomTabbarController,
                children: [
                  //关于
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab0'),
                    Container(
                      child: ListView(
                        children:[
                          (activeUser.verifiedReason==null||activeUser.verifiedReason.isEmpty)?Container():aboutItemWidget(context,activeUser.verifiedReason,title: '微博认证'),
                          aboutItemWidget(context,activeUser.location,title: '所在地'),
                          aboutItemWidget(context,(activeUser.gender==null||activeUser.gender=='n')?'未知':activeUser.gender=='m'?'男':'女',title: '性别'),
                          (activeUser.url==null||activeUser.url.isEmpty)?Container():aboutItemWidget(context,activeUser.url,title: '博客地址'),
                          (activeUser.domain==null||activeUser.domain.isEmpty)?Container():aboutItemWidget(context,activeUser.domain,title: '个性域名'),
                          aboutItemWidget(context,Utils.getDistanceFromNow(Utils.parseWeiboTimeStrToUtc(activeUser.createdAt)),title: '注册时间')
                        ]
                      ),
                    ),
                  ),
                  //引入这些Tab0,Tab1为的是解决不同tabview在切换的时候会使用同一个滑动位置
                  //看了一圈原理大概还没看懂T_T
                  //原创
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab1'),
                    UserWeiboListView(screenName: activeUser.screenName,feature: 1),
                  ),
                  //微博
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab2'),
                    UserWeiboListView(screenName: activeUser.screenName),
                  ),
                  //相册
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab3'),
                    UserWeiboListView(screenName: activeUser.screenName,feature: 2),
                  ),
                  //视频
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab4'),
                    UserWeiboListView(screenName: activeUser.screenName,feature: 3),
                  ),
                  
                ]
              );
            }
          ),
          innerScrollPositionKeyBuilder: () {
            var index = "Tab";
            index +=(_bottomTabbarController.index.toString());
            return Key(index);
          },
        ),
      ),
    );
  }
  Widget aboutItemWidget(BuildContext context,String text, {String title,Function onTap}){
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.symmetric(vertical:6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal:12),
            child: Text(title,style:Theme.of(context).textTheme.subtitle2),
          ),
          InkWell(
            onTap: onTap??(){},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
              child:Row(
                children: <Widget>[
                  Text(text,style:Theme.of(context).textTheme.bodyText2)
                ],
              ),
            ),
          )
        ],
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
                            color: showInExpand(_theme.primaryTextTheme.subtitle1.color, shrinkOffset),	
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: _theme.primaryTextTheme.subtitle1.color
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
                              style: _theme.primaryTextTheme.subtitle1,
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
                            child: Icon(Icons.email,color: _theme.primaryTextTheme.bodyText1.color),
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
                              style: _theme.primaryTextTheme.bodyText1,
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 16,),
                      //用户名和签名
                      Text(user.screenName,style: _theme.primaryTextTheme.subtitle1),
                      Container(height: 8,),
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
                            height: 48,
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
                      ),
                      Container(
                        height:24
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