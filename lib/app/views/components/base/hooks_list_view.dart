import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HooksListView extends HookWidget with ListStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      startLoad();
      return () {};
    }, []);

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
      child: currentList.value.isEmpty
          ? Center(
              child: Text('这里是空的噢'),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container();
              },
              itemCount: currentList.value.length,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
      onRefresh: refresh,
      onLoading: loadMore,
    );
  }
}

class ListState<Item> {
  final ValueNotifier<List<Item>> currentList;

  final Function startLoadData;

  final Function refreshData;

  final Function loadMoreData;

  ListState(this.currentList, this.startLoadData, this.refreshData,
      this.loadMoreData);
}

ValueNotifier<ListState> useListState<Item, Info>(
    {@required List<Item> Function(GetDataType type, {Info info}) getData}) {
  final currentList = useState<List<Item>>([]);

  void startLoad() {
    currentList.value.clear();
    var list = getData(GetDataType.StartLoad);
    currentList.value.addAll(list);
  }

  void refresh() {
    var list = getData(GetDataType.Refersh);
    currentList.value.insertAll(0, list);
  }

  void loadMore() {
    var list = getData(GetDataType.LoadMore);
    currentList.value.addAll(list);
  }

  return useState(ListState<Item>(currentList, startLoad, refresh, loadMore));
}

class ListStateMixin<Item, Info> {
  final currentList = useState<List<Item>>([]);

  void startLoad() {
    currentList.value.clear();
    var list = getData(GetDataType.StartLoad);
    currentList.value.addAll(list);
  }

  void refresh() {
    var list = getData(GetDataType.Refersh);
    currentList.value.insertAll(0, list);
  }

  void loadMore() {
    var list = getData(GetDataType.LoadMore);
    currentList.value.addAll(list);
  }

  List<Item> Function(GetDataType type, {Info info}) getData;
}

enum GetDataType { StartLoad, Refersh, LoadMore }
