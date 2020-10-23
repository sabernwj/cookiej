import 'package:cookiej/app/model/comment.dart';
import 'package:cookiej/app/model/comments.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:cookiej/app/service/repository/url_repository.dart';
import 'package:dio/dio.dart';

class CommentRepository {
  static const Map<CommentType, String> _commentMeMap = {
    CommentType.CommentByMe: '/2/comments/by_me.json',
    CommentType.CommentAtMe: '/2/comments/mentions.json',
    CommentType.CommentToMe: '/2/comments/to_me.json',
    CommentType.CommentFromWeibo: '/2/comments/show.json'
  };

  /// 根据微博ID返回某条微博的评论列表
  static Future<Comments> getComments(CommentType type,
      [int sinceId = 0, int maxId = 0, int id]) async {
    var url = _commentMeMap[type];
    var params = {"since_id": sinceId.toString(), "max_id": maxId.toString()};
    if (type == CommentType.CommentFromWeibo) params['id'] = id.toString();
    var jsonRes = (await API.get(url, queryParameters: params)).data;
    try {
      var comments = Comments.fromJson(jsonRes);
      if (comments == null) throw (AppError(AppErrorType.EmptyResultError));
      await UrlRepository.saveUrlInfoToHive(
          UrlRepository.findUrlFromContents(comments.comments));
      return comments;
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }

  /// 向某条微博发出一条评论
  static Future<Comment> createComment(int id, String text) async {
    var url = '/2/comments/create.json';
    var params = {'id': id.toString(), 'comment': text};
    var jsonRes = (await API.post(url,
            queryParameters: params,
            data: '',
            options: Options(contentType: Headers.formUrlEncodedContentType)))
        .data;
    try {
      var comment = Comment.fromJson(jsonRes);
      if (comment == null) throw AppError(AppErrorType.EmptyResultError);
      return comment;
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }
}

enum CommentType {
  /// 从某条微博获取的评论
  CommentFromWeibo,

  /// 我发出的评论列表
  CommentByMe,

  /// 我收到的评论列表
  CommentToMe,

  /// 获取@到我的评论
  CommentAtMe
}
