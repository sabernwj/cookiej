//下拉重新搜索，上拉加载更多搜索内容


import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/net/search_api.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef GetSearchResCallBack= Future<List<WeiboLite>> Function(SearchApiType searchType,int pageIndex);

class SearchListView extends StatefulWidget {

  final GetSearchResCallBack getSearchResult;
  final SearchApiType searchApiType;

  const SearchListView({Key key,this.getSearchResult, this.searchApiType}) : super(key: key);
  
  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> with AutomaticKeepAliveClientMixin {

  Map<String,WeiboLite> weiboList={};
  RefreshController _refreshController=RefreshController(initialRefresh:true);
  int pageIndex=1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        // header: ClassicHeader(
        //   refreshingText: '刷新中',
        //   failedText: '刷新失败',
        //   completeText:'刷新成功' ,
        //   releaseText: '刷新微博',
        //   idleText: '下拉刷新',
        // ),
        footer: ClassicFooter(
          failedText: '加载失败',
          canLoadingText: '加载更多',
          idleText: '加载更多',
          loadingText: '加载中',
          noDataText: '已无更多数据'
        ),
        controller: _refreshController,
        child: weiboList.isEmpty
        ?Container()
        :ListView.builder(
          itemBuilder: (BuildContext context,int index){
            var _keyId=weiboList.keys.toList()[index];
            return Container(
              key: ValueKey(_keyId),
              child:WeiboWidget(weiboList[_keyId]),
              margin: EdgeInsets.only(bottom:12),
            );
          },
          itemCount: weiboList.length,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
        onRefresh: ()async{
          pageIndex=1;
          weiboList={};
          var receiveList=(await widget.getSearchResult(widget.searchApiType,pageIndex))??[];
          receiveList.forEach((element) {
            if(!weiboList.containsKey(element.idstr)){
              weiboList[element.idstr]=element;
            }
          });
          setState(() {
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          });
        },
        onLoading: ()async{
          pageIndex++;
          var moreList=(await widget.getSearchResult(widget.searchApiType,pageIndex))??[];
          moreList.forEach((element) {
            if(!weiboList.containsKey(element.idstr)){
              weiboList[element.idstr]=element;
            }
          });
          setState(() {
            if(moreList==null||moreList.isEmpty) _refreshController.loadNoData();
            else _refreshController.loadComplete();
          });
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => weiboList.isNotEmpty;
}