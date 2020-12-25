// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class BaseListView extends StatelessWidget {
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   @override
//   Widget build(BuildContext context) {
//     return SmartRefresher(
//       enablePullDown: true,
//       enablePullUp: true,
//       header: ClassicHeader(
//         refreshingText: '刷新中',
//         failedText: '刷新失败',
//         completeText: '刷新成功',
//         releaseText: '刷新微博',
//         idleText: '下拉刷新',
//       ),
//       footer: ClassicFooter(
//           failedText: '加载失败',
//           canLoadingText: '加载更多',
//           idleText: '加载更多',
//           loadingText: '加载中',
//           noDataText: '已无更多数据'),
//       controller: _refreshController,
//       child: currentList.value.isEmpty
//           ? Center(
//               child: Text('这里是空的噢'),
//             )
//           : ListView.builder(
//               itemBuilder: (BuildContext context, int index) {
//                 return Container();
//               },
//               itemCount: currentList.value.length,
//               physics: const AlwaysScrollableScrollPhysics(),
//             ),
//       onRefresh: refresh,
//       onLoading: loadMore,
//     );
//   }
// }
