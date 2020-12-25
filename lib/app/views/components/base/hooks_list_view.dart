import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/service/repository/weibo_repository.dart';
import 'package:cookiej/app/views/components/weibo/weibo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HooksListView extends HookWidget with WeiboListState {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final currentList = useState(dataList);
    final length = useState(dataList.length);

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
      child: length.value > 0
          ? Center(
              child: Text('这里是空的噢'),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return WeiboWidget(dataList[index]);
              },
              itemCount: currentList.value.length,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
      onRefresh: () {
        refreshData();
        _refreshController.refreshCompleted();
      },
      onLoading: () {
        loadMoreData();
        _refreshController.loadComplete();
      },
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

class WeiboListWidget extends StatefulWidget {
  @override
  _WeiboListWidgetState createState() => _WeiboListWidgetState();
}

class _WeiboListWidgetState extends State<WeiboListWidget> with WeiboListState {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
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
      child: dataList.isEmpty
          ? Center(
              child: Text('这里是空的噢'),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return WeiboWidget(dataList[index]);
              },
              itemCount: dataList.length,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
      onRefresh: () async {
        await refreshData();

        setState(() {
          _refreshController.refreshCompleted();
        });
      },
      onLoading: () async {
        await loadMoreData();

        setState(() {
          _refreshController.loadComplete();
        });
      },
    );
  }
}

class WeiboListState {
  final List<WeiboWidgetVM> dataList = [];

  Future<void> startLoad() async {
    dataList.clear();
    dataList.addAll(await getData(GetDataType.StartLoad));
  }

  Future<void> refreshData() async {
    if (dataList.isEmpty) {
      startLoad();
    } else {
      dataList.insertAll(0, await getData(GetDataType.Refersh));
    }
  }

  Future<void> loadMoreData() async {
    if (dataList.isEmpty) {
      startLoad();
    } else {
      dataList.addAll(await getData(GetDataType.LoadMore));
    }
  }

  Future<List<WeiboWidgetVM>> getData(GetDataType getType) async {
    assert(getType != null);
    Weibos weibos;
    switch (getType) {
      case GetDataType.StartLoad:
        weibos = await WeiboRepository.getWeibosNet(WeibosType.Home);
        break;
      case GetDataType.Refersh:
        weibos = await WeiboRepository.getWeibosNet(WeibosType.Home,
            maxId: dataList[dataList.length - 1].id);
        break;
      case GetDataType.LoadMore:
        weibos = await WeiboRepository.getWeibosNet(WeibosType.Home,
            sinceId: dataList[0].id);
    }
    var list = weibos.statuses.map((weibo) => WeiboWidgetVM(weibo)).toList();
    return list;
  }
}
