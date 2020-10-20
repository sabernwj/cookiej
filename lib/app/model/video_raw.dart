import 'package:cookiej/app/model/video_urls.dart';

class VideoRaw {
  int ok;
  Data data;
  VideoUrls urls;

  VideoRaw({this.ok, this.data});

  VideoRaw.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String objectId;
  String objectType;
  Object object;

  Data({this.objectId, this.objectType, this.object});

  Data.fromJson(Map<String, dynamic> json) {
    objectId = json['object_id'];
    objectType = json['object_type'];
    object =
        json['object'] != null ? new Object.fromJson(json['object']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object_id'] = this.objectId;
    data['object_type'] = this.objectType;
    if (this.object != null) {
      data['object'] = this.object.toJson();
    }
    return data;
  }
}

class Object {
  String summary;
  Author author;
  Stream stream;
  String createdAt;
  ImageVideo image;

  Object({this.summary, this.author, this.stream, this.createdAt, this.image});

  Object.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    stream =
        json['stream'] != null ? new Stream.fromJson(json['stream']) : null;
    createdAt = json['created_at'];
    image =
        json['image'] != null ? new ImageVideo.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.stream != null) {
      data['stream'] = this.stream.toJson();
    }
    data['created_at'] = this.createdAt;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    return data;
  }
}

class Author {
  int id;
  String screenName;
  String profileImageUrl;
  String profileUrl;
  int statusesCount;
  bool verified;
  int verifiedType;
  bool closeBlueV;
  String description;
  String gender;
  int mbtype;
  int urank;
  int mbrank;
  bool followMe;
  bool following;
  int followersCount;
  int followCount;
  String coverImagePhone;
  String avatarHd;
  bool like;
  bool likeMe;

  Author(
      {this.id,
      this.screenName,
      this.profileImageUrl,
      this.profileUrl,
      this.statusesCount,
      this.verified,
      this.verifiedType,
      this.closeBlueV,
      this.description,
      this.gender,
      this.mbtype,
      this.urank,
      this.mbrank,
      this.followMe,
      this.following,
      this.followersCount,
      this.followCount,
      this.coverImagePhone,
      this.avatarHd,
      this.like,
      this.likeMe});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenName = json['screen_name'];
    profileImageUrl = json['profile_image_url'];
    profileUrl = json['profile_url'];
    statusesCount = json['statuses_count'];
    verified = json['verified'];
    verifiedType = json['verified_type'];
    closeBlueV = json['close_blue_v'];
    description = json['description'];
    gender = json['gender'];
    mbtype = json['mbtype'];
    urank = json['urank'];
    mbrank = json['mbrank'];
    followMe = json['follow_me'];
    following = json['following'];
    followersCount = json['followers_count'];
    followCount = json['follow_count'];
    coverImagePhone = json['cover_image_phone'];
    avatarHd = json['avatar_hd'];
    like = json['like'];
    likeMe = json['like_me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screen_name'] = this.screenName;
    data['profile_image_url'] = this.profileImageUrl;
    data['profile_url'] = this.profileUrl;
    data['statuses_count'] = this.statusesCount;
    data['verified'] = this.verified;
    data['verified_type'] = this.verifiedType;
    data['close_blue_v'] = this.closeBlueV;
    data['description'] = this.description;
    data['gender'] = this.gender;
    data['mbtype'] = this.mbtype;
    data['urank'] = this.urank;
    data['mbrank'] = this.mbrank;
    data['follow_me'] = this.followMe;
    data['following'] = this.following;
    data['followers_count'] = this.followersCount;
    data['follow_count'] = this.followCount;
    data['cover_image_phone'] = this.coverImagePhone;
    data['avatar_hd'] = this.avatarHd;
    data['like'] = this.like;
    data['like_me'] = this.likeMe;
    return data;
  }
}

class Stream {
  double duration;
  String format;
  int width;
  String hdUrl;
  String url;
  int height;

  Stream(
      {this.duration,
      this.format,
      this.width,
      this.hdUrl,
      this.url,
      this.height});

  Stream.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    format = json['format'];
    width = json['width'];
    hdUrl = json['hd_url'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['format'] = this.format;
    data['width'] = this.width;
    data['hd_url'] = this.hdUrl;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}

class ImageVideo {
  int width;
  String url;
  int height;

  ImageVideo({this.width, this.url, this.height});

  ImageVideo.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}
