import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/utils/utils.dart';

import 'user_lite.dart';
import 'content.dart';
import 'package:hive/hive.dart';

part 'weibo_lite.g.dart';

@HiveType(typeId: CookieJHiveType.WeiboLite)
class WeiboLite extends Content{
  @HiveField(0)
	int id;
  @HiveField(1)
  DateTime createdAt;
  @HiveField(2)
	String text;
  @HiveField(3)
	UserLite user;
  @HiveField(4)
	String mid;
  @HiveField(5)
	String idstr;
  @HiveField(6)
  String source;
  @HiveField(7)
	int repostsCount;
  @HiveField(8)
	int commentsCount;
  @HiveField(9)
	int attitudesCount;
  @HiveField(10)
  bool favorited;
  @HiveField(11)
  WeiboLite retweetedWeibo;
  @HiveField(12)
  List<String> picUrls;

  ///这个新增的成员是因为使用了网页微博API 时间格式变化
  String createdAtStr;

  WeiboLite({this.idstr,this.id,this.user,this.attitudesCount,this.commentsCount,this.createdAt,this.favorited,this.mid,this.picUrls,this.repostsCount,this.retweetedWeibo,this.text,this.source,this.createdAtStr});

  WeiboLite.fromJson(Map<String, dynamic> json){
    try{
      createdAt = Utils.parseWeiboTimeStrToUtc(json['created_at']);
    }catch(e){
      createdAtStr=json['created_at'];
    }
		
		id = (json['id'] is String)?int.parse(json['id']):json['id'];
		idstr = json['idstr'];
		mid = json['mid'];
		text = json['raw_text']??json['text'];
    favorited = json['favorited'];
		repostsCount = (json['reposts_count'] is String)?int.parse(json['reposts_count']):json['reposts_count'];
		commentsCount = (json['comments_count'] is String)?int.parse(json['comments_count']):json['comments_count'];
		attitudesCount = (json['attitudes_count'] is String)?int.parse(json['attitudes_count']):json['attitudes_count'];
    //此处对来源进行了格式化
    source = json['source']?.replaceAll(RegExp('<(S*?)[^>]*>.*?|<.*? />'),'');
    user = json['user'] != null ? UserLite.fromJson(json['user']) : null;
		if (json['pic_urls'] != null) {
			picUrls = List<String>();
			json['pic_urls'].forEach((v) { picUrls.add(v['thumbnail_pic']); });
		}
    if(json['retweeted_status']!=null){
      retweetedWeibo=WeiboLite.fromJson(json['retweeted_status']);
      retweetedWeibo.text=retweetedWeibo?.user?.name==null?
        retweetedWeibo.text
        :'@'+retweetedWeibo.user.screenName+'\n'+retweetedWeibo.text;
    }
  }

  Map<String, dynamic> toJson(){
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['created_at'] = this.createdAt;
		data['id'] = this.id;
		data['idstr'] = this.idstr;
		data['mid'] = this.mid;
		data['text'] = this.text;
		data['favorited'] = this.favorited;
		data['reposts_count'] = this.repostsCount;
		data['comments_count'] = this.commentsCount;
		data['attitudes_count'] = this.attitudesCount;
    data['source'] = this.source;
    data['user']=this.user.toJson();
		if (this.picUrls != null) {
      data['pic_urls'] = this.picUrls.map((v) => v).toList();
    }
    if(this.retweetedWeibo!=null){
      data['retweeted_status']=retweetedWeibo.toJson();
    }
		return data;
  }
}