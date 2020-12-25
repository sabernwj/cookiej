import 'package:cookiej/app/model/local/weibos.dart';
import 'package:cookiej/app/model/weibo.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/service/repository/url_repository.dart';

class WeiboRepository {
  static final _weibosBox = HiveService.weibosBox;

  static const Map<WeibosType, String> _weibosUrlMap = {
    WeibosType.Public: '/2/statuses/public_timeline.json',
    WeibosType.Home: '/2/statuses/home_timeline.json',
    WeibosType.Bilateral: '/2/statuses/bilateral_timeline.json',
    WeibosType.User: '/2/statuses/user_timeline.json',
    WeibosType.Reposts: '/2/statuses/repost_timeline.json',
    WeibosType.Mentions: '/2/statuses/mentions.json',
    WeibosType.Group: '/2/friendships/groups/timeline.json'
  };

  /// 从本地获取weibos
  static Future<Weibos> getWeibosLocal(String boxKey) async {
    var weibos = await _weibosBox.get(boxKey);
    if (weibos == null) throw AppError(AppErrorType.EmptyResultError);
    return weibos;
  }

  /// 从网络获取weibos
  static Future<Weibos> getWeibosNet(WeibosType type,
      {String localUid,
      int sinceId = 0,
      int maxId = 0,
      String groupId,
      Map<String, String> extraParams}) async {
    if (type == WeibosType.Group) {
      assert(groupId != null);
    }

    var url = _weibosUrlMap[type];
    var params = {
      "since_id": sinceId.toString(),
      "max_id": maxId.toString(),
      'list_id': groupId
    };
    if (extraParams != null) {
      params.addAll(extraParams);
    }
    Weibos returnWeibos;
    try {
      var jsonRes = (await API.get(url, queryParameters: params)).data;
      returnWeibos = Weibos.fromJson(jsonRes);
      // 特殊处理，刷新模式
      if (maxId == 0 && sinceId != 0) {
        // 保存sinceId，此模式目的是sinceId时间之后的微博,即最老的时间点微博的id
        var firstSinceId = sinceId;
        // 当从sinceId时间之后有超过20条微博时，[jsonRes]得到的[weibos]是最新时间开始的微博20条
        int requestCount = 0;
        // 经过多次测试，最多获取最近数量150条以内微博,添加多条限制防止无限请求
        while (returnWeibos.sinceId != null &&
            returnWeibos.sinceId > firstSinceId &&
            returnWeibos.maxId > 0 &&
            requestCount <= 10 &&
            returnWeibos.statuses.length <= 150) {
          params['since_id'] = firstSinceId.toString();
          params['max_id'] = returnWeibos.maxId.toString();
          var json = (await API.get(url, queryParameters: params)).data;
          requestCount = requestCount + 1;
          var weibos = Weibos.fromJson(json);
          returnWeibos
            ..sinceId = weibos.sinceId
            ..previousCursor = weibos.previousCursor
            ..maxId = weibos.maxId
            ..nextCursor = weibos.nextCursor
            ..statuses.addAll(weibos.statuses);
        }
      }
    } catch (e) {
      if (e is AppError)
        throw e;
      else
        throw (AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e));
    }

    if (returnWeibos != null && returnWeibos.statuses.isEmpty)
      throw AppError(AppErrorType.EmptyResultError);

    await UrlRepository.saveUrlInfoToHiveByContents(returnWeibos.statuses);
    // 带有localUid则为当前用户浏览主页的微博，需缓存
    if (localUid != null)
      await _weibosBox.put(
          generateHiveWeibosKey(type, localUid, groupId: groupId),
          returnWeibos);
    return returnWeibos;
  }

  /// 根据id获取单挑微博详情
  static Future<Weibo> getSingleWeibo(int id) async {
    var url = '/2/statuses/show.json';
    var params = {'id': id.toString(), 'isGetLongText': '1'};
    var jsonRes = (await API.get(url, queryParameters: params)).data;
    try {
      return Weibo.fromJson(jsonRes);
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError);
    }
  }

  /// 生成存储微博到hive的key
  static String generateHiveWeibosKey(WeibosType type, String uid,
          {String groupId}) =>
      '$uid.${type.toStringNew()}.${groupId ?? 'NoGroupId'}';
}

enum WeibosType {
  /// 公共
  Public,

  /// 全部关注
  Home,

  /// 好友圈(双向关注)
  Bilateral,

  /// 转发
  Reposts,

  /// 某用户的微博
  User,

  /// 自定义分组的微博
  Group,

  /// @我的微博
  Mentions
}

extension WeibosTypeExtension on WeibosType {
  String toStringNew() {
    return this.toString().split('.').last;
  }

  String get text =>
      ['公共', '全部关注', '好友圈', '转发', '用户', '自定义分组', '@我的微博'][this.index];
}
