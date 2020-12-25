import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/service/repository/weibo_repository.dart';
import 'package:cookiej/app/views/components/weibo/weibo_widget.dart';

class WeiboListState {
  List<WeiboWidgetVM> dataList = [];

  void startLoad() async {
    dataList.clear();
    dataList.addAll(await getData(GetDataType.StartLoad));
  }

  void refreshData() async {
    dataList.insertAll(0, await getData(GetDataType.Refersh));
  }

  void loadMoreData() async {
    dataList.addAll(await getData(GetDataType.LoadMore));
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
    var list = weibos.statuses.map((weibo) => WeiboWidgetVM(weibo));
    return list;
  }
}

enum GetDataType { StartLoad, Refersh, LoadMore }
