import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/comments.dart';
import 'package:cookiej/cookiej/net/comment_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/provider/url_provider.dart';


class CommentProvider{
  static Future<ProviderResult<Comments>> getCommentsShow(int id,[int sinceId=0,int maxId=0]) async{
    var result;
    result=CommentApi.getCommentsShow(id, sinceId, maxId)
      .then((json)=>Comments.fromJson(json))
      .then((comments) async {
        //await UrlProvider.saveUrlInfoToRAM(comments.comments);
        await UrlProvider.saveUrlInfoToHive(comments.comments);
        return ProviderResult(comments,true);
      })
      .catchError((e)=>ProviderResult(null,true));
    return result;
  }

  static Future<ProviderResult<Comments>> getCommentsAboutMe(CommentsType type,[int sinceId=0,int maxId=0]) async{
    var jsonRes=await CommentApi.getComnentsAboutMe(type, sinceId, maxId);
    var comments=Comments.fromJson(jsonRes);
    await UrlProvider.saveUrlInfoToHive(comments.comments);
    if(comments==null||comments.comments.isEmpty) return ProviderResult(null, false);
    return ProviderResult(comments, true);

  }
}