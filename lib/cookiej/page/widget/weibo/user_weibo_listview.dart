import 'dart:ui';

import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:cookiej/cookiej/model/local/display_content.dart';
import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';

import 'package:cookiej/cookiej/page/widget/weibo/weibo_video_widget.dart';

import 'package:cookiej/cookiej/page/widget/weibo/weibo_list_mixin.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class UserWeiboListView extends StatefulWidget {

  final String screenName;
  ///过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
  final int feature;

  final WeiboTimelineType type;

  const UserWeiboListView({
    Key key,
    @required
    this.screenName,
    this.feature=0,
    this.type=WeiboTimelineType.User
  }) : super(key: key);

  @override
  _UserWeiboListViewState createState() => _UserWeiboListViewState();
}

class _UserWeiboListViewState extends State<UserWeiboListView> with WeiboListMixin,AutomaticKeepAliveClientMixin {

  RefreshController _refreshController=RefreshController(initialRefresh:false);
  @override
  void initState() {
    weiboListInit(widget.type,extraParams: {
      'screen_name':widget.screenName,
      'feature':widget.feature.toString()
    });
    isStartLoadDataComplete=startLoadData();
    eventBus.on<FunctionCallBack>().listen((event) {
      if(event==FunctionCallBack.UserPageRefresh){
        onRefreshCallBack();
        print('刷新成功');
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: isStartLoadDataComplete,
      builder: (context,snaphot){
          if(snaphot.hasError){
            return Container(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  SizedBox(height: 16),
                  Text(snaphot.error.toString()),
                  SizedBox(height: 16),
                  RaisedButton(
                    child: Text('刷新试试'),
                    onPressed: (){
                      isStartLoadDataComplete=startLoadData();
                    }
                  ),
                  SizedBox(height: 16),
                ]
              )
            );
          }
      if(snaphot.data!=WeiboListStatus.complete) return Center(child:CircularProgressIndicator());
        return RefreshConfiguration(
          child:SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              failedText: '加载失败',
              canLoadingText: '加载更多',
              idleText: '加载更多',
              loadingText: '加载中',
              noDataText: '已无更多数据'
            ),
            onRefresh: onRefreshCallBack,
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
            child:(){
              switch (widget.feature) {
                case 2:
                  return pictureWaterfall();
                  break;
                case 3:
                  return videoWaterFall();
                  break;
                default:
                  return listViewWidget();
                  break;
              }
            }()
          )
        );
      },
    );
  }

  Widget listViewWidget(){
    if(weiboList.isEmpty){
      return Center(
        child:Text('没有找到微博')
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: weiboList.length,
      itemBuilder: (context,index){
        return Container(
          //child: Container(height:100,color:Colors.green),
          child:WeiboWidget(weiboList[index]),
          margin: EdgeInsets.only(bottom:12),
        );
      },
      //physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget pictureWaterfall(){
    if(weiboList.isEmpty){
      return Center(
        child:Text('没有找到照片')
      );
    }
    return WaterfallFlow.builder(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverWaterfallFlowDelegate(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8
      ),
      itemCount: weiboList.length,
      itemBuilder: (context,index){
        String imgUrl;
        try{
          imgUrl=weiboList[index].picUrls[0];
        }catch(e){
          try{
            imgUrl=weiboList[index].retweetedWeibo.picUrls[0];
          }catch(e){
            return Container();
          }
        }
        return GestureDetector(
          child:Container(
            constraints: BoxConstraints(
              maxHeight:300
            ),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                fit: BoxFit.cover,
                image: PictureProvider.getPictureFromUrl(imgUrl,sinaImgSize: SinaImgSize.bmiddle)
              ),
            )
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weiboList[index].id)));
          },
        );
      }
    );
  }

  Widget videoWaterFall(){
    var videoElementList=<VideoElement>[];
    weiboList.forEach((weibo){
      bool hasVideo=false;
      String text='';
      Video video;
      DisplayContent.analysisContent(weibo).forEach((content) {
        if(content.type==ContentType.Text
        ||content.type==ContentType.Topic
        ||content.type==ContentType.User) text+=content.text;
        if(content.type==ContentType.Video&&!hasVideo){
          video=(content.info.annotations[0].object as Video);
          hasVideo=true;
        }
      });
      if(hasVideo){
        videoElementList.add(VideoElement(text,video,onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.id)));
        }));
      }
    });
    //print(videoElementList.length);
    if(videoElementList.isEmpty){
      return Center(
        child:Text('没有找到视频')
      );
    }
    Widget returnWidget;
    returnWidget=ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 24),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: videoElementList.length,
      itemBuilder:(context,index){
        return WeiboVideoWidget(videoElement: videoElementList[index]);
      },
    );
    return returnWidget;
  }
  void onRefreshCallBack (){
    refreshData()
      .then((isComplete){
        if(isComplete==WeiboListStatus.complete) setState(() {
          _refreshController.refreshCompleted();
        });
        else _refreshController.refreshFailed();
      }).catchError((e)=>_refreshController.refreshFailed());
  }
  @override
  bool get wantKeepAlive => true;
}
