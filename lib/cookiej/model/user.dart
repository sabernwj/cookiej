import 'package:cookiej/cookiej/utils/utils.dart';

import 'user_lite.dart';

import 'insecurity.dart';

class User extends UserLite {
	int weiboClass;
	String province;
	String city;
	String location;
	String url;
	String profileImageUrl;
	String coverImagePhone;
	String profileUrl;
	String domain;
	String weihao;
	String gender;
	String createdAt;
	bool following;
	bool allowAllActMsg;
	bool geoEnabled;
	bool verified;
	int verifiedType;
	String remark;
	Insecurity insecurity;
	int ptype;
	bool allowAllComment;
	String avatarLarge;
	String avatarHd;
	String verifiedReason;
	String verifiedTrade;
	String verifiedReasonUrl;
	String verifiedSource;
	String verifiedSourceUrl;
	bool followMe;
	bool like;
	bool likeMe;
	int onlineStatus;
	int biFollowersCount;
	String lang;
	int star;
	int mbtype;
	int mbrank;
	int blockWord;
	int blockApp;
	int creditScore;
	int userAbility;
	int urank;
	int storyReadState;
	int vclubMember;
	int isTeenager;
	int isGuardian;
	int isTeenagerList;
	bool specialFollow;
	String tabManage;
  //头像的id
  String iconId;

	User({this.weiboClass, this.province, this.city, this.location, this.url, this.profileImageUrl, this.coverImagePhone, this.profileUrl, this.domain, this.weihao, this.gender, this.createdAt, this.following, this.allowAllActMsg, this.geoEnabled, this.verified, this.verifiedType, this.remark, this.insecurity, this.ptype, this.allowAllComment, this.avatarLarge, this.avatarHd, this.verifiedReason, this.verifiedTrade, this.verifiedReasonUrl, this.verifiedSource, this.verifiedSourceUrl, this.followMe, this.like, this.likeMe, this.onlineStatus, this.biFollowersCount, this.lang, this.star, this.mbtype, this.mbrank, this.blockWord, this.blockApp, this.creditScore, this.userAbility, this.urank, this.storyReadState, this.vclubMember, this.isTeenager, this.isGuardian, this.isTeenagerList, this.specialFollow, this.tabManage})
    :super.init();

	User.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		idstr = json['idstr'];
		weiboClass = json['class'];
		screenName = json['screen_name'];
		name = json['name'];
		province = json['province'];
		city = json['city'];
		location = json['location'];
		description = json['description'];
		url = json['url'];
		profileImageUrl = json['profile_image_url'];
		coverImagePhone = json['cover_image_phone'];
		profileUrl = json['profile_url'];
		domain = json['domain'];
		weihao = json['weihao'];
		gender = json['gender'];
		followersCount = json['followers_count'];
		friendsCount = json['friends_count'];
		pagefriendsCount = json['pagefriends_count'];
		statusesCount = json['statuses_count'];
		videoStatusCount = json['video_status_count'];
		favouritesCount = json['favourites_count'];
		createdAt = json['created_at'];
		following = json['following'];
		allowAllActMsg = json['allow_all_act_msg'];
		geoEnabled = json['geo_enabled'];
		verified = json['verified'];
		verifiedType = json['verified_type'];
		remark = json['remark'];
		insecurity = json['insecurity'] != null ? new Insecurity.fromJson(json['insecurity']) : null;
		ptype = json['ptype'];
		allowAllComment = json['allow_all_comment'];
		avatarLarge = json['avatar_large'];
		avatarHd = json['avatar_hd'];
		verifiedReason = json['verified_reason'];
		verifiedTrade = json['verified_trade'];
		verifiedReasonUrl = json['verified_reason_url'];
		verifiedSource = json['verified_source'];
		verifiedSourceUrl = json['verified_source_url'];
		followMe = json['follow_me'];
		like = json['like'];
		likeMe = json['like_me'];
		onlineStatus = json['online_status'];
		biFollowersCount = json['bi_followers_count'];
		lang = json['lang'];
		star = json['star'];
		mbtype = json['mbtype'];
		mbrank = json['mbrank'];
		blockWord = json['block_word'];
		blockApp = json['block_app'];
		creditScore = json['credit_score'];
		userAbility = json['user_ability'];
		urank = json['urank'];
		storyReadState = json['story_read_state'];
		vclubMember = json['vclub_member'];
		isTeenager = json['is_teenager'];
		isGuardian = json['is_guardian'];
		isTeenagerList = json['is_teenager_list'];
		specialFollow = json['special_follow'];
		tabManage = json['tab_manage'];
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
		data['class'] = this.weiboClass;
		data['screen_name'] = this.screenName;
		data['name'] = this.name;
		data['province'] = this.province;
		data['city'] = this.city;
		data['location'] = this.location;
		data['description'] = this.description;
		data['url'] = this.url;
		data['profile_image_url'] = this.profileImageUrl;
		data['cover_image_phone'] = this.coverImagePhone;
		data['profile_url'] = this.profileUrl;
		data['domain'] = this.domain;
		data['weihao'] = this.weihao;
		data['gender'] = this.gender;
		data['followers_count'] = this.followersCount;
		data['friends_count'] = this.friendsCount;
		data['pagefriends_count'] = this.pagefriendsCount;
		data['statuses_count'] = this.statusesCount;
		data['video_status_count'] = this.videoStatusCount;
		data['favourites_count'] = this.favouritesCount;
		data['created_at'] = this.createdAt;
		data['following'] = this.following;
		data['allow_all_act_msg'] = this.allowAllActMsg;
		data['geo_enabled'] = this.geoEnabled;
		data['verified'] = this.verified;
		data['verified_type'] = this.verifiedType;
		data['remark'] = this.remark;
		if (this.insecurity != null) {
      data['insecurity'] = this.insecurity.toJson();
    }
		data['ptype'] = this.ptype;
		data['allow_all_comment'] = this.allowAllComment;
		data['avatar_large'] = this.avatarLarge;
		data['avatar_hd'] = this.avatarHd;
		data['verified_reason'] = this.verifiedReason;
		data['verified_trade'] = this.verifiedTrade;
		data['verified_reason_url'] = this.verifiedReasonUrl;
		data['verified_source'] = this.verifiedSource;
		data['verified_source_url'] = this.verifiedSourceUrl;
		data['follow_me'] = this.followMe;
		data['like'] = this.like;
		data['like_me'] = this.likeMe;
		data['online_status'] = this.onlineStatus;
		data['bi_followers_count'] = this.biFollowersCount;
		data['lang'] = this.lang;
		data['star'] = this.star;
		data['mbtype'] = this.mbtype;
		data['mbrank'] = this.mbrank;
		data['block_word'] = this.blockWord;
		data['block_app'] = this.blockApp;
		data['credit_score'] = this.creditScore;
		data['user_ability'] = this.userAbility;
		data['urank'] = this.urank;
		data['story_read_state'] = this.storyReadState;
		data['vclub_member'] = this.vclubMember;
		data['is_teenager'] = this.isTeenager;
		data['is_guardian'] = this.isGuardian;
		data['is_teenager_list'] = this.isTeenagerList;
		data['special_follow'] = this.specialFollow;
		data['tab_manage'] = this.tabManage;
    data['icon_id']=this.iconId;
		return data;
	}
}