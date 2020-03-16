import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:hive/hive.dart';
part 'user_lite.g.dart';

///轻量版的用户信息
@HiveType(typeId: 1)
class UserLite {
  @HiveField(0)
  int id;
  @HiveField(1)
  String idstr;
  @HiveField(2)
  String screenName;
  @HiveField(3)
  String name;
  @HiveField(4)
  //头像的id
  String iconId;
  @HiveField(5)
	String description;
  @HiveField(6)
	int followersCount;
  @HiveField(7)
	int friendsCount;
  @HiveField(8)
	int pagefriendsCount;
  @HiveField(9)
	int statusesCount;
  @HiveField(10)
	int videoStatusCount;
  @HiveField(11)
	int favouritesCount;

  UserLite({this.id,this.idstr,this.screenName,this.name,this.iconId,this.description,this.favouritesCount,this.followersCount,this.friendsCount,this.pagefriendsCount,this.statusesCount,this.videoStatusCount});
  UserLite.fromJson(Map<String, dynamic> json){
		id = json['id'];
		idstr = json['idstr'];
		screenName = json['screen_name'];
		name = json['name'];
    description = json['description'];
		followersCount = json['followers_count'];
		friendsCount = json['friends_count'];
		pagefriendsCount = json['pagefriends_count'];
		statusesCount = json['statuses_count'];
		videoStatusCount = json['video_status_count'];
		favouritesCount = json['favourites_count'];
    if(json['icon_id']!=null){
      iconId=json['icon_id'];
    }else{
      iconId=PictureProvider.getImgIdFromUrl(json['profile_image_url']);
    }
    
  }
  UserLite.init(){
    screenName='用户名';
    description='个人简介';
    followersCount=7;
    friendsCount=7;
    statusesCount=7;
  }

  Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['idstr'] = this.idstr;
		data['screen_name'] = this.screenName;
		data['name'] = this.name;
    data['icon_id']=this.iconId;
    data['description'] = this.description;
		data['followers_count'] = this.followersCount;
		data['friends_count'] = this.friendsCount;
		data['pagefriends_count'] = this.pagefriendsCount;
		data['statuses_count'] = this.statusesCount;
		data['video_status_count'] = this.videoStatusCount;
		data['favourites_count'] = this.favouritesCount;
		return data;
	}
}