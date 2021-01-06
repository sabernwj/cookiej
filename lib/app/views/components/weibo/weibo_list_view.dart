import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/service/repository/weibo_repository.dart';
import 'package:cookiej/app/views/components/base/base_list_view.dart';
import 'package:cookiej/app/views/components/weibo/weibo_widget.dart';
import 'package:flutter/cupertino.dart';

class WeiboListView extends BaseListView<WeiboWidgetVM> {
  WeiboListView(BaseListVM<WeiboWidgetVM> listVM) : super(listVM);

  @override
  itemBuilderFunction(context, index) {
    return WeiboWidget(listVM.dataList[index],
        key: Key(listVM.dataList[index].id.toString()));
  }
}

class WeiboListVM extends BaseListVM<WeiboWidgetVM> {
  final WeibosType weibosType;
  final String groupId;
  Weibos lastResponseWeibos;

  WeiboListVM(this.weibosType, {this.groupId});

  @override
  getData(GetDataType getType) async {
    assert(getType != null);
    if (weibosType == WeibosType.Group) {
      assert(groupId != null);
    }

    if (lastResponseWeibos != null) {
      // 上一次获取微博数据的maxId为0，表示后面不再有数据
      if (lastResponseWeibos.maxId == 0)
        return Future.delayed(Duration(seconds: 1), () => []);
    }
    Weibos weibos;
    switch (getType) {
      case GetDataType.StartLoad:
        weibos =
            await WeiboRepository.getWeibosNet(weibosType, groupId: groupId);
        break;
      case GetDataType.LoadMore:
        weibos = await WeiboRepository.getWeibosNet(weibosType,
            maxId: dataList[dataList.length - 1].id, groupId: groupId);
        break;
      case GetDataType.Refersh:
        weibos = await WeiboRepository.getWeibosNet(weibosType,
            sinceId: dataList[0].id, groupId: groupId);
    }
    lastResponseWeibos = weibos;
    var list = weibos.statuses.map((weibo) => WeiboWidgetVM(weibo)).toList();
    return list;
  }
}
