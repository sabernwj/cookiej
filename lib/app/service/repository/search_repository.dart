import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/model/local/weibo_lite.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/service/repository/url_repository.dart';

class SearchRepository {
  static const String _baseUrl = 'https://m.weibo.cn/api/container/getIndex';

  static const List<SearchType> _types = [
    SearchType.All,
    SearchType.User,
    SearchType.Now,
    SearchType.Hot,
    SearchType.Picture,
    SearchType.Video,
    SearchType.Follow,
  ];

  /// 需要展示的搜索类别
  static List<SearchType> get searchTypes => _types;

  /// 获取推荐关键词
  static Future<List<String>> getSearchRecommend() async {
    var url = _baseUrl;
    var params = {
      'containerid': '231583',
      'page_type': 'searchall',
    };
    var jsonRes = (await API.get(url, queryParameters: params)).data;
    try {
      if (jsonRes['ok'] != 1) throw AppError(AppErrorType.EmptyResultError);
      List rawList = jsonRes['data']['cards'][0]['group'];
      return rawList.map((element) => element['title_sub'].toString());
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }

  /// 获取搜索结果
  static Future<List<WeiboLite>> getSearchResult(String keyword,
      {SearchType sType = SearchType.All, int pageIndex = 0}) async {
    var res =
        await _getSearchResultMap(sType.id, keyword, pageIndex.toString());
    List rawList = res['data']['cards'];
    List<WeiboLite> weiboList = [];
    _dfsMap(rawList, weiboList);
    await UrlRepository.saveUrlInfoToHiveByContents(weiboList);
    return weiboList;
  }

  /// 获取搜索用户结果
  static Future<List<UserLite>> getSearchUserResult(String keyword,
      {SearchType sType = SearchType.All, int pageIndex = 0}) async {
    var res =
        await _getSearchResultMap(sType.id, keyword, pageIndex.toString());
    List rawList = [];
    res['data']['cards'].forEach((e) {
      if (e['card_type'] == 11) {
        rawList.addAll(e['card_group']);
      }
    });
    List<UserLite> userList = [];
    rawList.forEach((element) {
      if (element['card_type'] == 10) {
        if (element['desc1'].toString().contains('粉丝：')) element['desc1'] = '';
        element['user']['description'] = element['desc1'];
        var userLite = UserLite.fromJson(element['user']);
        userList.add(userLite);
      }
    });
    return userList;
  }

  static Future<Map> _getSearchResultMap(
      String typeId, String str, String pageIndex) async {
    var url = _baseUrl;
    var firstParam = '100103type=$typeId&q=$str&t=0';
    firstParam = Uri.encodeComponent(firstParam);
    var params = {
      'containerid': firstParam,
      'page_type': 'searchall',
      'page': pageIndex
    };
    var jsonRes = (await API.get(url, queryParameters: params)).data;
    if (jsonRes['ok'] != 1) throw AppError(AppErrorType.EmptyResultError);
    return jsonRes;
  }

  static void _dfsMap(dynamic jsonMap, List list) {
    if (jsonMap == null) return;
    if (jsonMap is List) {
      jsonMap.forEach((element) {
        _dfsMap(element, list);
      });
    } else if (jsonMap is Map) {
      if (!jsonMap.containsKey('card_type')) return;
      if (jsonMap['card_type'] == 9) {
        var weiboLite = WeiboLite.fromJson(jsonMap['mblog']);
        list.add(weiboLite);
        return;
      } else {
        jsonMap.values.forEach((element) {
          _dfsMap(element, list);
        });
      }
    } else {
      return;
    }
  }
}

enum SearchType {
  User,
  All,
  Follow,
  Now,
  Video,
  Question,
  Article,
  Picture,
  SameCity,
  Hot,
  Topic,
  SuperTopic,
  Main
}

extension SearchTypeExtension on SearchType {
  static Map<String, String> map = {
    '3': '用户',
    '1': '综合',
    '62': '关注',
    '61': '实时',
    '64': '视频',
    '58': '问答',
    '21': '文章',
    '63': '图片',
    '97': '同城',
    '60': '热门',
    '38': '话题',
    '98': '超话',
    '32': '主页'
  };

  String get id => SearchTypeExtension.map.keys.toList()[this.index];
  String get text => SearchTypeExtension.map.values.toList()[this.index];
}
