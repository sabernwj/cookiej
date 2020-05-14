import 'dart:ui';

import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/local/display_content.dart';
import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/page/public/video_page.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
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

  const UserWeiboListView({
    Key key,
    @required
    this.screenName,
    this.feature=0
  }) : super(key: key);

  @override
  _UserWeiboListViewState createState() => _UserWeiboListViewState();
}

class _UserWeiboListViewState extends State<UserWeiboListView> with WeiboListMixin,AutomaticKeepAliveClientMixin {

  RefreshController _refreshController=RefreshController(initialRefresh:false);

  @override
  void initState() {
    weiboListInit(WeiboTimelineType.User,extraParams: {
      'screen_name':widget.screenName,
      'feature':widget.feature.toString()
    });
    isStartLoadDataComplete=startLoadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: isStartLoadDataComplete,
      builder: (context,snaphot){
        if(snaphot.data!=WeiboListStatus.complete) return Center(child:CircularProgressIndicator());
        return SmartRefresher(
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
        );
      },
    );
  }

  Widget listViewWidget(){
    return ListView.builder(
      itemCount: weiboList.length,
      itemBuilder: (context,index){
        return Container(
          child:WeiboWidget(weiboList[index]),
          margin: EdgeInsets.only(bottom:12),
        );
      },
      //physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget pictureWaterfall(){
    return Container(
      padding: EdgeInsets.all(8),
      child:WaterfallFlow.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverWaterfallFlowDelegate(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8
        ),
        itemBuilder: (context,index){
          String imgUrl;
          try{
            imgUrl=weiboList[index].picUrls[0];
          }catch(e){
            try{
              imgUrl=weiboList[index].retweetedWeibo.picUrls[0];
            }catch(e){
              return null;
            }
          }
          return GestureDetector(
            child:Container(
              constraints: BoxConstraints(
                maxHeight:300
              ),
              child:ClipRRect(
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
      )
    );
  }

  Widget videoWaterFall(){
    print(weiboList.length);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 24),
      child:WaterfallFlow.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverWaterfallFlowDelegate(
          crossAxisCount: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 24
        ),
        itemBuilder:(context,index){
          try{
            var displayContentList=DisplayContent.analysisContent(weiboList[index]);
            bool hasVideo=false;
            var returnWidget;
            displayContentList.forEach((displayContent){
              if(displayContent.type==ContentType.Video&&!hasVideo){
                hasVideo=true;
                var video=(displayContent.info.annotations[0].object as Video);
                returnWidget=Container(
                  height: MediaQuery.of(context).size.width*2/3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image(
                        width: double.infinity,
                        height: double.infinity,
                        image: PictureProvider.getPictureFromUrl(video.image.url),
                        fit: BoxFit.cover,
                      ),
                      Column(
                        children:[
                          Expanded(
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width/5,
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        color: Colors.black26
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child:Text(
                                    (){
                                      var text='';
                                      displayContentList.forEach((element) => text+=element.text);
                                      return text;
                                    }(),
                                    style: TextStyle(color: Colors.white,fontFamilyFallback: ['fontawesome']),
                                  ),
                                  padding:EdgeInsets.all(8)
                                )
                              ],
                            ),
                          )
                        ],
                        mainAxisAlignment:MainAxisAlignment.end
                      ),
                      Positioned.fill(
                        child: Material(
                          color:Colors.transparent,
                          child:InkWell(
                            onTap:() async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weiboList[index].id)));
                            }
                          )
                        )
                      )
                    ],
                  ),
                );
              }
            });
            if(returnWidget!=null) returnWidget=ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: returnWidget,
            );
            return returnWidget;
          }catch(e){
            return null;
          }
        },
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}