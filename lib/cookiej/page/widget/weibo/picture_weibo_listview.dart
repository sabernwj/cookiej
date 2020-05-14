// import 'package:cookiej/cookiej/config/config.dart';
// import 'package:cookiej/cookiej/page/widget/weibo/weibo_list_mixin.dart';
// import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// ///瀑布流展示的微博图片流
// class PictureWeiboListview extends StatefulWidget {
//   @override
//   _PictureWeiboListviewState createState() => _PictureWeiboListviewState();
// }
//   RefreshController _refreshController=RefreshController(initialRefresh:false);

// class _PictureWeiboListviewState extends State<PictureWeiboListview> with WeiboListMixin,AutomaticKeepAliveClientMixin{

//   @override
//   void initState() {
//     weiboListInit(WeiboTimelineType.User,extraParams: {
//       'screen_name':widget.screenName
//     });
//     isStartLoadDataComplete=startLoadData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return FutureBuilder(
//       future: isStartLoadDataComplete,
//       builder: (context,snaphot){
//         if(snaphot.data!=WeiboListStatus.complete) return Center(child:CircularProgressIndicator());
//         return SmartRefresher(
//           controller: _refreshController,
//           enablePullDown: true,
//           enablePullUp: true,
//           footer: ClassicFooter(
//             failedText: '加载失败',
//             canLoadingText: '加载更多',
//             idleText: '加载更多',
//             loadingText: '加载中',
//             noDataText: '已无更多数据'
//           ),
//           onRefresh: (){
//             refreshData()
//               .then((isComplete){
//                 if(isComplete==WeiboListStatus.complete) setState(() {
//                   _refreshController.refreshCompleted();
//                 });
//                 else _refreshController.refreshFailed();
//               }).catchError((e)=>_refreshController.refreshFailed());
//           },
//           onLoading: (){
//             loadMoreData()
//               .then((isComplete){
//                 setState(() {
//                   if(isComplete==WeiboListStatus.nodata) _refreshController.loadNoData();
//                   if(isComplete==WeiboListStatus.complete) _refreshController.loadComplete();
//                   if(isComplete==WeiboListStatus.failed) _refreshController.loadFailed();
//                 });
//               }).catchError((e)=>_refreshController.loadFailed());
//           },
//           child:ListView.builder(
//             itemCount: weiboList.length,
//             itemBuilder: (context,index){
//               return Container(
//                 child:WeiboWidget(weiboList[index]),
//                 margin: EdgeInsets.only(bottom:12),
//               );
//             },
//             //physics: const AlwaysScrollableScrollPhysics(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }