import 'package:cookiej/cookiej/model/weibo_lite.dart';

import 'annotations.dart';
import 'comment_manage_info.dart';
import 'long_text.dart';
import 'number_display_strategy.dart';
import 'visible.dart';

class Weibo extends WeiboLite{
	Visible visible;
	bool canEdit;
	int showAdditionalIndication;
	int textLength;
	int sourceAllowclick;
	int sourceType;
	bool truncated;
	String inReplyToStatusId;
	String inReplyToUserId;
	String inReplyToScreenName;
	String thumbnailPic;
	String bmiddlePic;
	String originalPic;
	dynamic geo;
	bool isPaid;
	int mblogVipType;
	List<Annotations> annotations;
	int pendingApprovalCount;
	bool isLongText;
	LongText longText;
	int rewardExhibitionType;
	int hideFlag;
	int mlevel;
	int bizFeature;
	int pageType;
	int hasActionTypeCard;
	List<dynamic> darwinTags;
	List<dynamic> hotWeiboTags;
	List<dynamic> textTagTips;
	int mblogtype;
	int userType;
	int moreInfoType;
	NumberDisplayStrategy numberDisplayStrategy;
	int positiveRecomFlag;
	int contentAuth;
	String gifIds;
	int isShowBulletin;
	CommentManageInfo commentManageInfo;
	int picNum;

	Weibo({this.visible, this.canEdit, this.showAdditionalIndication, this.textLength, this.sourceAllowclick, this.sourceType, this.truncated, this.inReplyToStatusId, this.inReplyToUserId, this.inReplyToScreenName, this.thumbnailPic, this.bmiddlePic, this.originalPic, this.geo, this.isPaid, this.mblogVipType, this.annotations, this.pendingApprovalCount, this.isLongText, this.longText, this.rewardExhibitionType, this.hideFlag, this.mlevel, this.bizFeature, this.pageType, this.hasActionTypeCard, this.darwinTags, this.hotWeiboTags, this.textTagTips, this.mblogtype, this.userType, this.moreInfoType, this.numberDisplayStrategy, this.positiveRecomFlag, this.contentAuth, this.gifIds, this.isShowBulletin, this.commentManageInfo, this.picNum});

	Weibo.fromJson(Map<String, dynamic> json) :super.fromJson(json) {
		visible = json['visible'] != null ? new Visible.fromJson(json['visible']) : null;
		canEdit = json['can_edit'];
		showAdditionalIndication = json['show_additional_indication'];
		textLength = json['textLength'];
		sourceAllowclick = json['source_allowclick'];
		sourceType = json['source_type'];
		truncated = json['truncated'];
		inReplyToStatusId = json['in_reply_to_status_id'];
		inReplyToUserId = json['in_reply_to_user_id'];
		inReplyToScreenName = json['in_reply_to_screen_name'];
		thumbnailPic = json['thumbnail_pic'];
		bmiddlePic = json['bmiddle_pic'];
		originalPic = json['original_pic'];
		geo = json['geo'];
		isPaid = json['is_paid'];
		mblogVipType = json['mblog_vip_type'];
		if (json['annotations'] != null) {
			annotations = new List<Annotations>();
			json['annotations'].forEach((v) { annotations.add(new Annotations.fromJson(v)); });
		}
		pendingApprovalCount = json['pending_approval_count'];
		isLongText = json['isLongText'];
		longText = json['longText'] != null ? new LongText.fromJson(json['longText']) : null;
		rewardExhibitionType = json['reward_exhibition_type'];
		hideFlag = json['hide_flag'];
		mlevel = json['mlevel'];
		bizFeature = json['biz_feature'];
		pageType = json['page_type'];
		hasActionTypeCard = json['hasActionTypeCard'];
		if (json['darwin_tags'] != null) {
			darwinTags = new List<dynamic>();
			json['darwin_tags'].forEach((v) { darwinTags.add(v); });
		}
		if (json['hot_weibo_tags'] != null) {
			hotWeiboTags = new List<dynamic>();
			json['hot_weibo_tags'].forEach((v) { hotWeiboTags.add(v); });
		}
		if (json['text_tag_tips'] != null) {
			textTagTips = new List<dynamic>();
			json['text_tag_tips'].forEach((v) { textTagTips.add(v); });
		}
		mblogtype = json['mblogtype'];
		userType = json['userType'];
		moreInfoType = json['more_info_type'];
		numberDisplayStrategy = json['number_display_strategy'] != null ? new NumberDisplayStrategy.fromJson(json['number_display_strategy']) : null;
		positiveRecomFlag = json['positive_recom_flag'];
		contentAuth = json['content_auth'];
		gifIds = json['gif_ids'];
		isShowBulletin = json['is_show_bulletin'];
		commentManageInfo = json['comment_manage_info'] != null ? new CommentManageInfo.fromJson(json['comment_manage_info']) : null;
		picNum = json['pic_num'];

	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.visible != null) {
      data['visible'] = this.visible.toJson();
    }
		data['created_at'] = this.createdAt;
		data['id'] = this.id;
		data['idstr'] = this.idstr;
		data['mid'] = this.mid;
		data['can_edit'] = this.canEdit;
		data['show_additional_indication'] = this.showAdditionalIndication;
		data['text'] = this.text;
		data['textLength'] = this.textLength;
		data['source_allowclick'] = this.sourceAllowclick;
		data['source_type'] = this.sourceType;
		data['source'] = this.source;
		data['favorited'] = this.favorited;
		data['truncated'] = this.truncated;
		data['in_reply_to_status_id'] = this.inReplyToStatusId;
		data['in_reply_to_user_id'] = this.inReplyToUserId;
		data['in_reply_to_screen_name'] = this.inReplyToScreenName;
		if (this.picUrls != null) {
      data['pic_urls'] = this.picUrls.map((v) => v).toList();
    }
		data['thumbnail_pic'] = this.thumbnailPic;
		data['bmiddle_pic'] = this.bmiddlePic;
		data['original_pic'] = this.originalPic;
		data['geo'] = this.geo;
		data['is_paid'] = this.isPaid;
		data['mblog_vip_type'] = this.mblogVipType;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		if (this.annotations != null) {
      data['annotations'] = this.annotations.map((v) => v.toJson()).toList();
    }
		data['reposts_count'] = this.repostsCount;
		data['comments_count'] = this.commentsCount;
		data['attitudes_count'] = this.attitudesCount;
		data['pending_approval_count'] = this.pendingApprovalCount;
		data['isLongText'] = this.isLongText;
		if (this.longText != null) {
      data['longText'] = this.longText.toJson();
    }
		data['reward_exhibition_type'] = this.rewardExhibitionType;
		data['hide_flag'] = this.hideFlag;
		data['mlevel'] = this.mlevel;
		data['biz_feature'] = this.bizFeature;
		data['page_type'] = this.pageType;
		data['hasActionTypeCard'] = this.hasActionTypeCard;
		if (this.darwinTags != null) {
      data['darwin_tags'] = this.darwinTags.map((v) => v.toJson()).toList();
    }
		if (this.hotWeiboTags != null) {
      data['hot_weibo_tags'] = this.hotWeiboTags.map((v) => v.toJson()).toList();
    }
		if (this.textTagTips != null) {
      data['text_tag_tips'] = this.textTagTips.map((v) => v.toJson()).toList();
    }
		data['mblogtype'] = this.mblogtype;
		data['userType'] = this.userType;
		data['more_info_type'] = this.moreInfoType;
		if (this.numberDisplayStrategy != null) {
      data['number_display_strategy'] = this.numberDisplayStrategy.toJson();
    }
		data['positive_recom_flag'] = this.positiveRecomFlag;
		data['content_auth'] = this.contentAuth;
		data['gif_ids'] = this.gifIds;
		data['is_show_bulletin'] = this.isShowBulletin;
		if (this.commentManageInfo != null) {
      data['comment_manage_info'] = this.commentManageInfo.toJson();
    }
		data['pic_num'] = this.picNum;
		return data;
	}
}