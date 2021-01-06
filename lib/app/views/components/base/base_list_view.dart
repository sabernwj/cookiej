import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BaseListView<ItemVM> extends StatelessWidget {
  final BaseListVM<ItemVM> listVM;

  BaseListView(this.listVM, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    ScrollController _scrollController;
    return GetBuilder<BaseListVM>(
      init: listVM,
      initState: (state) {
        _scrollController =
            ScrollController(initialScrollOffset: listVM.scrollPosition)
              ..addListener(() {
                listVM.scrollPosition = _scrollController.offset;
              });
      },
      didChangeDependencies: (state) {},
      global: false,
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
              : ListView.separated(
                  itemBuilder: itemBuilderFunction,
                  separatorBuilder: separatorBuilderFunction,
                  itemCount: vm.dataList.length,
                  controller: _scrollController,
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

  Widget itemBuilderFunction(BuildContext context, int index) => Container();

  Widget separatorBuilderFunction(BuildContext context, int index) =>
      Container();
}

abstract class BaseListVM<ItemVM> extends GetxController {
  final List<ItemVM> dataList = [];
  double scrollPosition = 0;

  @override
  void onInit() {
    super.onInit();
    startLoad();
  }

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
enum ResultType { Complete, Failed, NoData }
