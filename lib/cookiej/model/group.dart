import 'user.dart';

class Group {
	int id;
	String idstr;
	String name;
	String mode;
	int visible;
	int likeCount;
	int memberCount;
	String description;
	List<String> tags;
	String profileImageUrl;
	User user;
	String createdAt;

	Group({this.id, this.idstr, this.name, this.mode, this.visible, this.likeCount, this.memberCount, this.description, this.tags, this.profileImageUrl, this.user, this.createdAt});

	Group.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		idstr = json['idstr'];
		name = json['name'];
		mode = json['mode'];
		visible = json['visible'];
		likeCount = json['like_count'];
		memberCount = json['member_count'];
		description = json['description'];
		if (json['tags'] != null) {
			tags = new List<String>();
			json['tags'].forEach((v) { tags.add(v.toString()); });
		}
		profileImageUrl = json['profile_image_url'];
		user = json['user'] != null ? new User.fromJson(json['user']) : null;
		createdAt = json['created_at'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['idstr'] = this.idstr;
		data['name'] = this.name;
		data['mode'] = this.mode;
		data['visible'] = this.visible;
		data['like_count'] = this.likeCount;
		data['member_count'] = this.memberCount;
		data['description'] = this.description;
		if (this.tags != null) {
      data['tags'] = this.tags.toList();
    }
		data['profile_image_url'] = this.profileImageUrl;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		data['created_at'] = this.createdAt;
		return data;
	}
}