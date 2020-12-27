import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/service/repository/weibo_repository.dart';
import 'package:cookiej/app/views/components/base/base_list_view.dart';
import 'package:cookiej/app/views/components/weibo/weibo_widget.dart';
import 'package:flutter/cupertino.dart';

class WeiboListView extends BaseListView<WeiboWidgetVM> {
  WeiboListView(BaseListVM<WeiboWidgetVM> vm) : super(vm);

  @override
  itemBuilderFunction(context, index) {
    return WeiboWidget(vm.dataList[index],
        key: Key(vm.dataList[index].id.toString()));
  }
}

class WeiboListVM extends BaseListVM<WeiboWidgetVM> {
  @override
  getData(GetDataType getType) async {
    assert(getType != null);
    Weibos weibos;
    switch (getType) {
      case GetDataType.StartLoad:
        weibos = await WeiboRepository.getWeibosNet(WeibosType.Home);
        break;
      case GetDataType.LoadMore:
        weibos = await WeiboRepository.getWeibosNet(WeibosType.Home,
            maxId: dataList[dataList.length - 1].id);
        break;
      case GetDataType.Refersh:
        weibos = await WeiboRepository.getWeibosNet(WeibosType.Home,
            sinceId: dataList[0].id);
    }
    var list = weibos.statuses.map((weibo) => WeiboWidgetVM(weibo)).toList();
    return list;
  }
}
