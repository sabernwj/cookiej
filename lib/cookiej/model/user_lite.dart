import 'package:cookiej/cookiej/utils/utils.dart';

///轻量版的用户信息
class UserLite {
  int id;
  String idstr;
  String screenName;
  String name;
  //头像的id
  String iconId;
  UserLite({this.id,this.idstr,this.screenName,this.name,this.iconId});
  UserLite.fromJson(Map<String, dynamic> json){
		id = json['id'];
		idstr = json['idstr'];
		screenName = json['screen_name'];
		name = json['name'];
    if(json['icon_id']!=null){
      iconId=json['icon_id'];
    }else{
      iconId=Utils.getImgIdFromUrl(json['profile_image_url']);
    }
    
  }

  Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['idstr'] = this.idstr;
		data['screen_name'] = this.screenName;
		data['name'] = this.name;
    data['icon_id']=this.iconId;
		return data;
	}
}