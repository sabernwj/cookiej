import 'package:flutter/material.dart';
import '../components/weibo_widget.dart';
import '../components/weiboTimeline.dart';
import '../utils/httpController.dart';

class Follow extends StatefulWidget {
  @override
  _FollowState createState() => _FollowState();
}

class _FollowState extends State<Follow> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();
  WeiboTimeline homeTimeline;
  WeiboTimeline earlyHomeTimeline;
  WeiboTimeline laterHomeTimeline;
  var _weiboWidgetlist=<WeiboWidget>[];
  bool _isLoadingMoreData=false;
  Future<bool> _isStartLoad;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    _isStartLoad=startLoadData();
    _isStartLoad.then((result){
      if(result==true){
        _scrollController.addListener((){
          ///判断当前滑动位置是不是到达底部，触发加载更多回调
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent&&_isLoadingMoreData==false) {
            loadMoreData();
          }
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future:_isStartLoad,
      builder: (BuildContext context,snaphot){
        if(snaphot.data==true){
          return RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (BuildContext context,int index){
                if(index<_weiboWidgetlist.length){
                  return _weiboWidgetlist[index];
                }
                return Container(
                  child: (){
                    if(_isLoadingMoreData){return Center(child:CircularProgressIndicator());}
                    else{return Container();}
                  }(),
                  padding: EdgeInsets.only(bottom: 10),
                );
              },
              itemCount: _weiboWidgetlist.length+1,
              controller: _scrollController,
            ),
            onRefresh: refreshData,
          );
        }else{
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }
  
  Future<bool> startLoadData() async{
    var result=HttpController.getStatusesHomeTimeline().then((jsonMap){
      homeTimeline=WeiboTimeline.fromJson(jsonMap);
      laterHomeTimeline=homeTimeline;
      for(var weibo in homeTimeline.statuses){
        _weiboWidgetlist.add( new WeiboWidget(weibo));
      }
      return true;
    }).catchError((err){
      print(err);
      return false;
    });
    return result;
  }

  void loadMoreData()async{
    var weiboWidgetlist=<WeiboWidget>[];
    if(earlyHomeTimeline==null){
      earlyHomeTimeline=homeTimeline;
    }
    if(earlyHomeTimeline.maxId==0){
      return;
    }
    setState(() {
          _isLoadingMoreData=true;
    });
    HttpController.getStatusesHomeTimeline(maxId: earlyHomeTimeline.maxId??0).then((jsonMap){
      earlyHomeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in earlyHomeTimeline.statuses){
        weiboWidgetlist.add(WeiboWidget(weibo));
      }
      setState(() {
        _isLoadingMoreData=false;
        _weiboWidgetlist.addAll(weiboWidgetlist);
      });
    }).catchError((err){
    });
  }

  Future<Null> refreshData() async{
    var weiboWidgetlist=<WeiboWidget>[];
    HttpController.getStatusesHomeTimeline(sinceId: laterHomeTimeline.sinceId??0).then((jsonMap){
      laterHomeTimeline=WeiboTimeline.fromJson(jsonMap);
      for(var weibo in laterHomeTimeline.statuses){
        weiboWidgetlist.add(WeiboWidget(weibo));
      }
      setState(() {
        _weiboWidgetlist.setAll(0, weiboWidgetlist);
      });
    }).catchError((err){
      print(err);
    });
  }
}