import 'package:cookiej/cookiej/provider/picture_provider.dart';

///轻量版的用户信息
class UserLite {
  int id;
  String idstr;
  String screenName;
  String name;
  //头像的id
  String iconId;
	String description;
	int followersCount;
	int friendsCount;
	int pagefriendsCount;
	int statusesCount;
	int videoStatusCount;
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