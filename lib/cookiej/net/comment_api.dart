import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/utils/utils.dart';

class CommentApi{
  ///根据微博ID返回某条微博的评论列表
  static const String _commentsById='/2/comments/show.json';

  ///根据微博ID获取该微博评论列表
  static Future<Map> getCommentsShow(int id,int sinceId,int maxId) async{
    var url=API.baseUrl+_commentsById;
    var params={
      'id':id.toString(),
      "since_id":sinceId.toString(),
      "max_id":maxId.toString()
    };
    return (await API.get(Utils.formatUrlParams(url, params))).data;
  }
}