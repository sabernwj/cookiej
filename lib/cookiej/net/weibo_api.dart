import 'dart:async';
import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http_parser/http_parser.dart';

class WeiboApi{
  ///公共微博
  static const String _public='/2/statuses/public_timeline.json';
  ///关注用户的微博
  static const String _home='/2/statuses/home_timeline.json';
  ///好友圈(双向关注)微博
  static const String _bilateral='/2/statuses/bilateral_timeline.json';
  ///某个用户的全部微博
  static const String _user='/2/statuses/user_timeline.json';
  ///转发的微博
  static const String _repost='/2/statuses/repost_timeline.json';
  ///单条微博内容
  static const String _weibo='/2/statuses/show.json';

  ///	获取@当前用户的最新微博
  static const String _mentions='/2/statuses/mentions.json';

  /// 获取当前登录用户某一好友分组的微博列表
  static const String _groupsTimeline='/2/friendships/groups/timeline.json';


  ///发布一条新微博
  static const String _update='/2/statuses/update.json';

  ///上传一张图片并发布一条新微博
  //static const String _upload='/2/statuses/upload.json';
  ///上传图片，返回图片picid,urls(3个url)
  static const String _upload_pic='/2/statuses/upload_pic.json';
  ///指定图片URL地址抓取后上传并同时发布一条新微博（用于发多图微博）
  static const String _upload_url_text='/2/statuses/upload_url_text.json';

  ///转发一条微博
  //static const String _repostCreate='/2/statuses/repost.json';

  //点赞，取消赞的web接口
  // static const String _create_attitudes='https://m.weibo.cn/api/attitudes/create';
  // static const String _destroy_attitudes='https://m.weibo.cn/api/attitudes/destroy';




  ///获取微博列表
  static Future<Map> getTimeLine(int sinceId,int maxId,WeiboTimelineType timelineType,Map<String,String> extraParams) async {
    // Future<Weibos> returnTimeline;
    var url;
    switch (timelineType){
      case WeiboTimelineType.Public:
        url=_public;
        break;
      case WeiboTimelineType.Statuses:
        url=_home;
        break;
      case WeiboTimelineType.Bilateral:
        url=_bilateral;
        break;
      case WeiboTimelineType.User:
        url=_user;
        break;
      case WeiboTimelineType.Mentions:
        url=_mentions;
        break;
      case WeiboTimelineType.Group:
        url=_groupsTimeline;
        break;
      default:
        return null;
    }
    var params={
      "since_id":sinceId.toString(),
      "max_id":maxId.toString()
    };
    if(extraParams!=null){
      params.addAll(extraParams);
    }
    final result=await API.get(Utils.formatUrlParams(url, params));
    return result.data;
  }
  
  ///获取转发的微博
  static Future<Map> getReposts(int id,int sinceId,int maxId) async {
    var url=_repost;
    var params={
      "since_id":sinceId.toString(),
      "max_id":maxId.toString(),
      'id':id.toString()
    };
    final result=await API.get(Utils.formatUrlParams(url, params));
    //if(!(result is Map)) return null;
    return result?.data;
  }

  ///根据微博ID获取单条微博内容
  static Future<Map> getStatusesShow(int id) async{
    var url=_weibo;
    var params={
      'id':id.toString(),
      'isGetLongText':'1'
    };

    return (await API.get(Utils.formatUrlParams(url, params))).data;

  }

  ///* `weiboRawText` 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字
  ///* `visible` 微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0
  ///* `listId` 微博的保护投递指定分组ID，只有当visible参数为3时生效且必选
  static Future<bool> postWeibo(String weiboRawText,{
    int visible,
    String listId,
    double lat,
    double long,
    List<Asset> picList
  }) async{
    if(weiboRawText==null||weiboRawText.isEmpty) return false;
    var url=(picList==null||picList.length==0)?_update:_upload_url_text;
    var params=<String,String>{
      'status':Uri.encodeComponent(weiboRawText),
    };
    if(visible!=null) params['visible']=visible.toString();
    if(listId!=null) params['list_id']=listId;
    if(lat!=null) params['lat']=lat.toString();
    if(long!=null) params['long']=long.toString();
    //添加图片
    //FormData formData;
    if(picList!=null&&picList.length!=0){
      var picTask=List<Future<Response<dynamic>>>();
      for (Asset asset in picList) { 
        var file=MultipartFile.fromBytes(
          (await asset.getByteData()).buffer.asUint8List(),
          filename: asset.name,
          contentType:MediaType("image", "jpg") 
        );
        var formData=FormData();
        formData.files.add(MapEntry('pic',file));
        picTask.add(API.post(
          Utils.formatUrlParams(_upload_pic, {}),
          data: formData==null?'':formData,
          options: Options(contentType:Headers.formUrlEncodedContentType)
        ));
      }
      String picIds='';
      //这里是预先调用上传图片接口返回图片id
      await Future.wait(picTask).then((results) {
        results.forEach((element) {
          picIds+=element.data['pic_id'].toString()+',';
        });
      }).catchError((e){
        print(e);
      });
      params['pic_id']=picIds;
    }
    return (await API.post(
      Utils.formatUrlParams(url, params),
      data: '',
      options: Options(contentType:Headers.formUrlEncodedContentType)
    ))==null?false:true;
  }

  //暂时放弃，因为缺少xsrf-token的获取方式
  // static Future<bool> createAttitudes(String weiboId) async{
  //   var url=_create_attitudes;
  //   var opt=Options(contentType:Headers.formUrlEncodedContentType);
  //   opt.headers['referer']=url;
  //   var res=await API.post(
  //     url,
  //     options: opt,
  //     data: FormData.fromMap({
  //       'id':weiboId,
  //       'attitude':'heart'
  //     })
  //   );
  //   return false;
  // }
}