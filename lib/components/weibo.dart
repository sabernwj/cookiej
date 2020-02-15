import 'dart:convert' show json;

class Weibo {

  Object geo;
  int attitudes_count;
  int biz_feature;
  int comments_count;
  int content_auth;
  int hasActionTypeCard;
  int hide_flag;
  int id;
  String idstr;
  int is_show_bulletin;
  int mblog_vip_type;
  int mblogtype;
  String mid;
  int mlevel;
  int more_info_type;
  int pending_approval_count;
  int positive_recom_flag;
  int reposts_count;
  int reward_exhibition_type;
  int show_additional_indication;
  int source_allowclick;
  int source_type;
  int textLength;
  int userType;
  bool can_edit;
  bool favorited;
  bool isLongText;
  bool is_paid;
  bool truncated;
  String bmiddle_pic;
  String cardid;
  String created_at;
  String gif_ids;
  String in_reply_to_screen_name;
  String in_reply_to_status_id;
  String in_reply_to_user_id;
  String original_pic;
  String reward_scheme;
  String rid;
  String source;
  String text;
  String thumbnail_pic;
  List<Client> annotations;
  List<dynamic> darwin_tags;
  List<dynamic> hot_weibo_tags;
  List<PicUrl> pic_urls;
  List<dynamic> text_tag_tips;
  CommentManageInfo comment_manage_info;
  User user;
  Visible visible;
  ///转发的原微博
  RetweetedWeibo retweetedWeibo;

  Weibo.fromParams({this.geo, this.attitudes_count, this.biz_feature, this.comments_count, this.content_auth, this.hasActionTypeCard, this.hide_flag, this.id, this.idstr, this.is_show_bulletin, this.mblog_vip_type, this.mblogtype, this.mid, this.mlevel, this.more_info_type, this.pending_approval_count, this.positive_recom_flag, this.reposts_count, this.reward_exhibition_type, this.show_additional_indication, this.source_allowclick, this.source_type, this.textLength, this.userType, this.can_edit, this.favorited, this.isLongText, this.is_paid, this.truncated, this.bmiddle_pic, this.cardid, this.created_at, this.gif_ids, this.in_reply_to_screen_name, this.in_reply_to_status_id, this.in_reply_to_user_id, this.original_pic, this.reward_scheme, this.rid, this.source, this.text, this.thumbnail_pic, this.annotations, this.darwin_tags, this.hot_weibo_tags, this.pic_urls, this.text_tag_tips, this.comment_manage_info, this.user, this.visible});

  factory Weibo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Weibo.fromJson(json.decode(jsonStr)) : new Weibo.fromJson(jsonStr);
  
  Weibo.fromJson(jsonRes) {
    geo = jsonRes['geo'];
    attitudes_count = jsonRes['attitudes_count'];
    biz_feature = jsonRes['biz_feature'];
    comments_count = jsonRes['comments_count'];
    content_auth = jsonRes['content_auth'];
    hasActionTypeCard = jsonRes['hasActionTypeCard'];
    hide_flag = jsonRes['hide_flag'];
    id = jsonRes['id'];
    idstr = jsonRes['idstr'];
    is_show_bulletin = jsonRes['is_show_bulletin'];
    mblog_vip_type = jsonRes['mblog_vip_type'];
    mblogtype = jsonRes['mblogtype'];
    mid = jsonRes['mid'];
    mlevel = jsonRes['mlevel'];
    more_info_type = jsonRes['more_info_type'];
    pending_approval_count = jsonRes['pending_approval_count'];
    positive_recom_flag = jsonRes['positive_recom_flag'];
    reposts_count = jsonRes['reposts_count'];
    reward_exhibition_type = jsonRes['reward_exhibition_type'];
    show_additional_indication = jsonRes['show_additional_indication'];
    source_allowclick = jsonRes['source_allowclick'];
    source_type = jsonRes['source_type'];
    textLength = jsonRes['textLength'];
    userType = jsonRes['userType'];
    can_edit = jsonRes['can_edit'];
    favorited = jsonRes['favorited'];
    isLongText = jsonRes['isLongText'];
    is_paid = jsonRes['is_paid'];
    truncated = jsonRes['truncated'];
    bmiddle_pic = jsonRes['bmiddle_pic'];
    cardid = jsonRes['cardid'];
    created_at = jsonRes['created_at'];
    gif_ids = jsonRes['gif_ids'];
    in_reply_to_screen_name = jsonRes['in_reply_to_screen_name'];
    in_reply_to_status_id = jsonRes['in_reply_to_status_id'];
    in_reply_to_user_id = jsonRes['in_reply_to_user_id'];
    original_pic = jsonRes['original_pic'];
    reward_scheme = jsonRes['reward_scheme'];
    rid = jsonRes['rid'];
    source = jsonRes['source'];
    text = jsonRes['text'];
    thumbnail_pic = jsonRes['thumbnail_pic'];
    annotations = jsonRes['annotations'] == null ? null : [];

    for (var annotationsItem in annotations == null ? [] : jsonRes['annotations']){
            annotations.add(annotationsItem == null ? null : new Client.fromJson(annotationsItem));
    }

    darwin_tags = jsonRes['darwin_tags'] == null ? null : [];

    for (var darwin_tagsItem in darwin_tags == null ? [] : jsonRes['darwin_tags']){
            darwin_tags.add(darwin_tagsItem);
    }

    hot_weibo_tags = jsonRes['hot_weibo_tags'] == null ? null : [];

    for (var hot_weibo_tagsItem in hot_weibo_tags == null ? [] : jsonRes['hot_weibo_tags']){
            hot_weibo_tags.add(hot_weibo_tagsItem);
    }

    pic_urls = jsonRes['pic_urls'] == null ? null : [];

    for (var pic_urlsItem in pic_urls == null ? [] : jsonRes['pic_urls']){
            pic_urls.add(pic_urlsItem == null ? null : new PicUrl.fromJson(pic_urlsItem));
    }

    text_tag_tips = jsonRes['text_tag_tips'] == null ? null : [];

    for (var text_tag_tipsItem in text_tag_tips == null ? [] : jsonRes['text_tag_tips']){
            text_tag_tips.add(text_tag_tipsItem);
    }

    comment_manage_info = jsonRes['comment_manage_info'] == null ? null : new CommentManageInfo.fromJson(jsonRes['comment_manage_info']);
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
    visible = jsonRes['visible'] == null ? null : new Visible.fromJson(jsonRes['visible']);
    if(jsonRes['retweeted_status']!=null){
      retweetedWeibo=new RetweetedWeibo();
      retweetedWeibo.rWeibo=Weibo.fromJson(jsonRes['retweeted_status']);
    }


  }

  @override
  String toString() {
    return '{"geo": $geo,"attitudes_count": $attitudes_count,"biz_feature": $biz_feature,"comments_count": $comments_count,"content_auth": $content_auth,"hasActionTypeCard": $hasActionTypeCard,"hide_flag": $hide_flag,"id": $id,"idstr": $idstr,"is_show_bulletin": $is_show_bulletin,"mblog_vip_type": $mblog_vip_type,"mblogtype": $mblogtype,"mid": $mid,"mlevel": $mlevel,"more_info_type": $more_info_type,"pending_approval_count": $pending_approval_count,"positive_recom_flag": $positive_recom_flag,"reposts_count": $reposts_count,"reward_exhibition_type": $reward_exhibition_type,"show_additional_indication": $show_additional_indication,"source_allowclick": ${source != null?'${json.encode(source)}':'null'}_allowclick,"source_type": ${source != null?'${json.encode(source)}':'null'}_type,"textLength": ${text != null?'${json.encode(text)}':'null'}Length,"userType": $userType,"can_edit": $can_edit,"favorited": $favorited,"isLongText": $isLongText,"is_paid": $is_paid,"truncated": $truncated,"bmiddle_pic": ${bmiddle_pic != null?'${json.encode(bmiddle_pic)}':'null'},"cardid": ${cardid != null?'${json.encode(cardid)}':'null'},"created_at": ${created_at != null?'${json.encode(created_at)}':'null'},"gif_ids": ${gif_ids != null?'${json.encode(gif_ids)}':'null'},"in_reply_to_screen_name": ${in_reply_to_screen_name != null?'${json.encode(in_reply_to_screen_name)}':'null'},"in_reply_to_status_id": ${in_reply_to_status_id != null?'${json.encode(in_reply_to_status_id)}':'null'},"in_reply_to_user_id": ${in_reply_to_user_id != null?'${json.encode(in_reply_to_user_id)}':'null'},"original_pic": ${original_pic != null?'${json.encode(original_pic)}':'null'},"reward_scheme": ${reward_scheme != null?'${json.encode(reward_scheme)}':'null'},"rid": ${rid != null?'${json.encode(rid)}':'null'},"source": ${source != null?'${json.encode(source)}':'null'},"text": ${text != null?'${json.encode(text)}':'null'},"thumbnail_pic": ${thumbnail_pic != null?'${json.encode(thumbnail_pic)}':'null'},"annotations": $annotations,"darwin_tags": $darwin_tags,"hot_weibo_tags": $hot_weibo_tags,"pic_urls": $pic_urls,"text_tag_tips": $text_tag_tips,"comment_manage_info": $comment_manage_info,"user": $user,"visible": $visible}';
  }
}

class Visible {

  int list_id;
  int type;

  Visible.fromParams({this.list_id, this.type});
  
  Visible.fromJson(jsonRes) {
    list_id = jsonRes['list_id'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"list_id": $list_id,"type": $type}';
  }
}

class User {

  int bi_followers_count;
  int block_app;
  int block_word;
  int user_class;
  int credit_score;
  int favourites_count;
  int followers_count;
  int friends_count;
  int id;
  int mbrank;
  int mbtype;
  int online_status;
  int pagefriends_count;
  int ptype;
  int star;
  int statuses_count;
  int story_read_state;
  int urank;
  int user_ability;
  int vclub_member;
  int verified_type;
  int video_status_count;
  bool allow_all_act_msg;
  bool allow_all_comment;
  bool follow_me;
  bool following;
  bool geo_enabled;
  bool like;
  bool like_me;
  bool verified;
  String avatar_hd;
  String avatar_large;
  String cardid;
  String city;
  String cover_image;
  String cover_image_phone;
  String created_at;
  String description;
  String domain;
  String gender;
  String idstr;
  String lang;
  String location;
  String name;
  String profile_image_url;
  String profile_url;
  String province;
  String remark;
  String screen_name;
  String url;
  String verified_reason;
  String verified_reason_url;
  String verified_source;
  String verified_source_url;
  String verified_trade;
  String weihao;
  Insecurity insecurity;

  User.fromParams({this.bi_followers_count, this.block_app, this.block_word, this.user_class, this.credit_score, this.favourites_count, this.followers_count, this.friends_count, this.id, this.mbrank, this.mbtype, this.online_status, this.pagefriends_count, this.ptype, this.star, this.statuses_count, this.story_read_state, this.urank, this.user_ability, this.vclub_member, this.verified_type, this.video_status_count, this.allow_all_act_msg, this.allow_all_comment, this.follow_me, this.following, this.geo_enabled, this.like, this.like_me, this.verified, this.avatar_hd, this.avatar_large, this.cardid, this.city, this.cover_image, this.cover_image_phone, this.created_at, this.description, this.domain, this.gender, this.idstr, this.lang, this.location, this.name, this.profile_image_url, this.profile_url, this.province, this.remark, this.screen_name, this.url, this.verified_reason, this.verified_reason_url, this.verified_source, this.verified_source_url, this.verified_trade, this.weihao, this.insecurity});
  
  User.fromJson(jsonRes) {
    bi_followers_count = jsonRes['bi_followers_count'];
    block_app = jsonRes['block_app'];
    block_word = jsonRes['block_word'];
    user_class = jsonRes['class'];
    credit_score = jsonRes['credit_score'];
    favourites_count = jsonRes['favourites_count'];
    followers_count = jsonRes['followers_count'];
    friends_count = jsonRes['friends_count'];
    id = jsonRes['id'];
    mbrank = jsonRes['mbrank'];
    mbtype = jsonRes['mbtype'];
    online_status = jsonRes['online_status'];
    pagefriends_count = jsonRes['pagefriends_count'];
    ptype = jsonRes['ptype'];
    star = jsonRes['star'];
    statuses_count = jsonRes['statuses_count'];
    story_read_state = jsonRes['story_read_state'];
    urank = jsonRes['urank'];
    user_ability = jsonRes['user_ability'];
    vclub_member = jsonRes['vclub_member'];
    verified_type = jsonRes['verified_type'];
    video_status_count = jsonRes['video_status_count'];
    allow_all_act_msg = jsonRes['allow_all_act_msg'];
    allow_all_comment = jsonRes['allow_all_comment'];
    follow_me = jsonRes['follow_me'];
    following = jsonRes['following'];
    geo_enabled = jsonRes['geo_enabled'];
    like = jsonRes['like'];
    like_me = jsonRes['like_me'];
    verified = jsonRes['verified'];
    avatar_hd = jsonRes['avatar_hd'];
    avatar_large = jsonRes['avatar_large'];
    cardid = jsonRes['cardid'];
    city = jsonRes['city'];
    cover_image = jsonRes['cover_image'];
    cover_image_phone = jsonRes['cover_image_phone'];
    created_at = jsonRes['created_at'];
    description = jsonRes['description'];
    domain = jsonRes['domain'];
    gender = jsonRes['gender'];
    idstr = jsonRes['idstr'];
    lang = jsonRes['lang'];
    location = jsonRes['location'];
    name = jsonRes['name'];
    profile_image_url = jsonRes['profile_image_url'];
    profile_url = jsonRes['profile_url'];
    province = jsonRes['province'];
    remark = jsonRes['remark'];
    screen_name = jsonRes['screen_name'];
    url = jsonRes['url'];
    verified_reason = jsonRes['verified_reason'];
    verified_reason_url = jsonRes['verified_reason_url'];
    verified_source = jsonRes['verified_source'];
    verified_source_url = jsonRes['verified_source_url'];
    verified_trade = jsonRes['verified_trade'];
    weihao = jsonRes['weihao'];
    insecurity = jsonRes['insecurity'] == null ? null : new Insecurity.fromJson(jsonRes['insecurity']);
  }

  @override
  String toString() {
    return '{"bi_followers_count": $bi_followers_count,"block_app": $block_app,"block_word": $block_word,"class": $user_class,"credit_score": $credit_score,"favourites_count": $favourites_count,"followers_count": $followers_count,"friends_count": $friends_count,"id": $id,"mbrank": $mbrank,"mbtype": $mbtype,"online_status": $online_status,"pagefriends_count": $pagefriends_count,"ptype": $ptype,"star": $star,"statuses_count": $statuses_count,"story_read_state": $story_read_state,"urank": $urank,"user_ability": $user_ability,"vclub_member": $vclub_member,"verified_type": $verified_type,"video_status_count": $video_status_count,"allow_all_act_msg": $allow_all_act_msg,"allow_all_comment": $allow_all_comment,"follow_me": $follow_me,"following": $following,"geo_enabled": $geo_enabled,"like": $like,"like_me": $like_me,"verified": $verified,"avatar_hd": ${avatar_hd != null?'${json.encode(avatar_hd)}':'null'},"avatar_large": ${avatar_large != null?'${json.encode(avatar_large)}':'null'},"cardid": ${cardid != null?'${json.encode(cardid)}':'null'},"city": ${city != null?'${json.encode(city)}':'null'},"cover_image": ${cover_image != null?'${json.encode(cover_image)}':'null'},"cover_image_phone": ${cover_image_phone != null?'${json.encode(cover_image_phone)}':'null'},"created_at": ${created_at != null?'${json.encode(created_at)}':'null'},"description": ${description != null?'${json.encode(description)}':'null'},"domain": ${domain != null?'${json.encode(domain)}':'null'},"gender": ${gender != null?'${json.encode(gender)}':'null'},"idstr": ${idstr != null?'${json.encode(idstr)}':'null'},"lang": ${lang != null?'${json.encode(lang)}':'null'},"location": ${location != null?'${json.encode(location)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"profile_image_url": ${profile_image_url != null?'${json.encode(profile_image_url)}':'null'},"profile_url": ${profile_url != null?'${json.encode(profile_url)}':'null'},"province": ${province != null?'${json.encode(province)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"screen_name": ${screen_name != null?'${json.encode(screen_name)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'},"verified_reason": ${verified_reason != null?'${json.encode(verified_reason)}':'null'},"verified_reason_url": ${verified_reason_url != null?'${json.encode(verified_reason_url)}':'null'},"verified_source": ${verified_source != null?'${json.encode(verified_source)}':'null'},"verified_source_url": ${verified_source_url != null?'${json.encode(verified_source_url)}':'null'},"verified_trade": ${verified_trade != null?'${json.encode(verified_trade)}':'null'},"weihao": ${weihao != null?'${json.encode(weihao)}':'null'},"insecurity": $insecurity}';
  }
}

class Insecurity {

  bool sexual_content;

  Insecurity.fromParams({this.sexual_content});
  
  Insecurity.fromJson(jsonRes) {
    sexual_content = jsonRes['sexual_content'];
  }

  @override
  String toString() {
    return '{"sexual_content": $sexual_content}';
  }
}

class CommentManageInfo {

  int approval_comment_type;
  int comment_permission_type;

  CommentManageInfo.fromParams({this.approval_comment_type, this.comment_permission_type});
  
  CommentManageInfo.fromJson(jsonRes) {
    approval_comment_type = jsonRes['approval_comment_type'];
    comment_permission_type = jsonRes['comment_permission_type'];
  }

  @override
  String toString() {
    return '{"approval_comment_type": $approval_comment_type,"comment_permission_type": $comment_permission_type}';
  }
}

class PicUrl {

  String thumbnail_pic;

  PicUrl.fromParams({this.thumbnail_pic});
  
  PicUrl.fromJson(jsonRes) {
    thumbnail_pic = jsonRes['thumbnail_pic'];
  }

  @override
  String toString() {
    return '{"thumbnail_pic": ${thumbnail_pic != null?'${json.encode(thumbnail_pic)}':'null'}}';
  }
}

class Client {

  String client_mblogid;

  Client.fromParams({this.client_mblogid});
  
  Client.fromJson(jsonRes) {
    client_mblogid = jsonRes['client_mblogid'];
  }

  @override
  String toString() {
    return '{"client_mblogid": ${client_mblogid != null?'${json.encode(client_mblogid)}':'null'}}';
  }
}

class RetweetedWeibo{

  Weibo rWeibo;
}