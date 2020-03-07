import 'pic_urls.dart';
import 'retweeted_weibo.dart';
import 'user_lite.dart';
import 'content.dart';

class WeiboLite extends Content{
	String createdAt;
	int id;
	String text;
	UserLite user;
	String mid;
	String idstr;
	int repostsCount;
	int commentsCount;
	int attitudesCount;
  bool favorited;
  RetweetedWeibo retweetedWeibo;
  List<PicUrls> picUrls;

  WeiboLite({this.idstr,this.id,this.user,this.attitudesCount,this.commentsCount,this.createdAt,this.favorited,this.mid,this.picUrls,this.repostsCount,this.retweetedWeibo,this.text});

  WeiboLite.fromJson(Map<String, dynamic> json){
		createdAt = json['created_at'];
		id = json['id'];
		idstr = json['idstr'];
		mid = json['mid'];
		text = json['text'];
    favorited = json['favorited'];
		repostsCount = json['reposts_count'];
		commentsCount = json['comments_count'];
		attitudesCount = json['attitudes_count'];
    user = json['user'] != null ? UserLite.fromJson(json['user']) : null;
		if (json['pic_urls'] != null) {
			picUrls = List<PicUrls>();
			json['pic_urls'].forEach((v) { picUrls.add(PicUrls.fromJson(v)); });
		}
    if(json['retweeted_status']!=null){
      retweetedWeibo=new RetweetedWeibo();
      retweetedWeibo.rWeibo=WeiboLite.fromJson(json['retweeted_status']);
      retweetedWeibo.rWeibo.text='@'+retweetedWeibo.rWeibo.user.name+'\n'+retweetedWeibo.rWeibo.text;
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
    data['user']=this.user.toJson();
		if (this.picUrls != null) {
      data['pic_urls'] = this.picUrls.map((v) => v.toJson()).toList();
    }
    if(this.retweetedWeibo!=null){
      data['retweeted_status']=retweetedWeibo.rWeibo.toJson();
    }
		return data;
  }
}