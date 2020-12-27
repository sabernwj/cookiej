import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BaseListView<ItemVM> extends StatelessWidget {
  final BaseListVM<ItemVM> vm;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  BaseListView(this.vm, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: vm,
      initState: (_) {
        vm.startLoad();
      },
      builder: (vm) {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: ClassicHeader(
            refreshingText: '刷新中',
            failedText: '刷新失败',
            completeText: '刷新成功',
            releaseText: '刷新微博',
            idleText: '下拉刷新',
          ),
          footer: ClassicFooter(
              failedText: '加载失败',
              canLoadingText: '加载更多',
              idleText: '加载更多',
              loadingText: '加载中',
              noDataText: '已无更多数据'),
          controller: _refreshController,
          child: vm.dataList.isEmpty
              ? Center(
                  child: Text('这里是空的噢'),
                )
              : ListView.builder(
                  itemBuilder: itemBuilderFunction,
                  itemCount: vm.dataList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
          onRefresh: () async {
            await vm.refreshData();
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            await vm.loadMoreData();
            _refreshController.loadComplete();
          },
        );
      },
    );
  }

  Widget itemBuilderFunction(BuildContext context, int index) {
    return Container();
  }
}

abstract class BaseListVM<ItemVM> extends GetxController {
  final List<ItemVM> dataList = [];

  Future<void> startLoad() async {
    dataList.clear();
    dataList.addAll(await getData(GetDataType.StartLoad));
    update();
  }

  Future<void> refreshData() async {
    if (dataList.isEmpty) {
      startLoad();
    } else {
      dataList.insertAll(0, await getData(GetDataType.Refersh));
      update();
    }
  }

  Future<void> loadMoreData() async {
    if (dataList.isEmpty) {
      startLoad();
    } else {
      dataList.addAll(await getData(GetDataType.LoadMore));
      update();
    }
  }

  Future<List<ItemVM>> getData(GetDataType getDataType);
}

enum GetDataType { StartLoad, Refersh, LoadMore }
