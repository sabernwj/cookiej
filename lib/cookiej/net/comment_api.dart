import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:dio/dio.dart';

class CommentApi{
  ///根据微博ID返回某条微博的评论列表
  static const String _commentsById='/2/comments/show.json';
  static const String _attitudesId='/2/attitudes/show.json';
  ///我发出的评论列表
  static const String _commentsByMe='/2/comments/by_me.json';
  ///我收到的评论列表
  static const String _commentsToMe='/2/comments/to_me.json';
  ///获取@到我的评论
  static const String _commentsMentions='/2/comments/mentions.json';

  ///评论一条微博
  static const String _commentCreate='/2/comments/create.json';
  ///回复一条评论
  //static const String _commentReply='/2/comments/reply.json';

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
  
  static Future<Map> getComnentsAboutMe(CommentsType type, int sinceId,int maxId) async{
    var url=API.baseUrl;
    switch (type){
      case CommentsType.ByMe:
        url+=_commentsByMe;
        break;
      case CommentsType.ToMe:
        url+=_commentsToMe;
        break;
      case CommentsType.Mentions:
        url+=_commentsMentions;
        break;
      default:
        return null;
    }
    var params={
      "since_id":sinceId.toString(),
      "max_id":maxId.toString()
    };
     return (await API.get(Utils.formatUrlParams(url, params))).data;
  }

  ///获取点赞列表(暂时无权限)
  static Future<Map> getAttitudesShow(int id,int page,int count) async {
    var url=API.baseUrl+_attitudesId;
    var params={
      'id':id.toString(),
      'page':page.toString(),
      'count':count.toString()
    };
    return (await API.get(Utils.formatUrlParams(url, params))).data;
  }

  static Future<Map> createComment(int id,String text) async{
    var url=_commentCreate;
    var params={
      'id':id.toString(),
      'comment':text
    };
    return (await API.post(
      Utils.formatUrlParams(url, params),
      data: '',
      options: Options(contentType:Headers.formUrlEncodedContentType)
    )).data;
  }
}
