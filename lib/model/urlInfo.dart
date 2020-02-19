class UrlInfo {
  bool result;
  String urlShort;
  String urlLong;
  int transcode;
  String description;
  List<Annotations> annotations;
  int type;
  String title;
  int lastModified;

  UrlInfo(
      {this.result,
      this.urlShort,
      this.urlLong,
      this.transcode,
      this.description,
      this.annotations,
      this.type,
      this.title,
      this.lastModified});

  UrlInfo.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    urlShort = json['url_short'];
    urlLong = json['url_long'];
    transcode = json['transcode'];
    description = json['description'];
    if (json['annotations'] != null) {
      annotations = new List<Annotations>();
      json['annotations'].forEach((v) {
        annotations.add(new Annotations.fromJson(v));
      });
    }
    type = json['type'];
    title = json['title'];
    lastModified = json['last_modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['url_short'] = this.urlShort;
    data['url_long'] = this.urlLong;
    data['transcode'] = this.transcode;
    data['description'] = this.description;
    if (this.annotations != null) {
      data['annotations'] = this.annotations.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['title'] = this.title;
    data['last_modified'] = this.lastModified;
    return data;
  }
}

class Annotations {
  String uuidstr;
  String objectType;
  String activateStatus;
  int safeStatus;
  String objectId;
  int uuid;
  String actStatus;
  String objectDomainId;
  String containerid;
  String showStatus;
  String lastModified;
  int timestamp;
  Object object;

  Annotations(
      {this.uuidstr,
      this.objectType,
      this.activateStatus,
      this.safeStatus,
      this.objectId,
      this.uuid,
      this.actStatus,
      this.objectDomainId,
      this.containerid,
      this.showStatus,
      this.lastModified,
      this.timestamp,
      this.object});

  Annotations.fromJson(Map<String, dynamic> json) {
    uuidstr = json['uuidstr'];
    objectType = json['object_type'];
    activateStatus = json['activate_status'];
    safeStatus = json['safe_status'];
    objectId = json['object_id'];
    uuid = json['uuid'];
    actStatus = json['act_status'];
    objectDomainId = json['object_domain_id'];
    containerid = json['containerid'];
    showStatus = json['show_status'];
    lastModified = json['last_modified'];
    timestamp = json['timestamp'];
    object =
        json['object'] != null ? (){
          switch (objectType){
            case 'place':
              return Place.fromJson(json['object']);
            case 'collection':
              return Collection.fromJson(json['object']);
            // case 'video':
            //   return Video.fromJson(json['object']);
            default:
              return Object.fromJson(json['object']);
          }
        }() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuidstr'] = this.uuidstr;
    data['object_type'] = this.objectType;
    data['activate_status'] = this.activateStatus;
    data['safe_status'] = this.safeStatus;
    data['object_id'] = this.objectId;
    data['uuid'] = this.uuid;
    data['act_status'] = this.actStatus;
    data['object_domain_id'] = this.objectDomainId;
    data['containerid'] = this.containerid;
    data['show_status'] = this.showStatus;
    data['last_modified'] = this.lastModified;
    data['timestamp'] = this.timestamp;
    if (this.object != null) {
      data['object'] = this.object.toJson();
    }
    return data;
  }
}

class Object {
  Biz biz;
  String objectType;
  String targetUrl;
  String id;
  String displayName;
  String url;

  Object(
      {this.biz,
      this.objectType,
      this.targetUrl,
      this.id,
      this.displayName,
      this.url});

  Object.fromJson(Map<String, dynamic> json) {
    biz = json['biz'] != null ? new Biz.fromJson(json['biz']) : null;
    objectType = json['object_type'];
    targetUrl = json['target_url'];
    id = json['id'];
    displayName = json['display_name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.biz != null) {
      data['biz'] = this.biz.toJson();
    }
    data['object_type'] = this.objectType;
    data['target_url'] = this.targetUrl;
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['url'] = this.url;
    return data;
  }
}
class Biz {
  String bizId;
  String containerid;

  Biz({this.bizId, this.containerid});

  Biz.fromJson(Map<String, dynamic> json) {
    bizId = json['biz_id'];
    containerid = json['containerid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biz_id'] = this.bizId;
    data['containerid'] = this.containerid;
    return data;
  }
}
class Image {
  String width;
  String url;
  String height;

  Image({this.width, this.url, this.height});

  Image.fromJson(Map<String, dynamic> json) {
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
class Address {
  String streetAddress;
  String country;
  String city;
  String formatted;
  String locality;
  String telephone;
  String businessDistrict;
  String cityBlock;
  String district;
  String region;
  String postalCode;
  String fax;
  String email;

  Address(
      {this.streetAddress,
      this.country,
      this.city,
      this.formatted,
      this.locality,
      this.telephone,
      this.businessDistrict,
      this.cityBlock,
      this.district,
      this.region,
      this.postalCode,
      this.fax,
      this.email});

  Address.fromJson(Map<String, dynamic> json) {
    streetAddress = json['street_address'];
    country = json['country'];
    city = json['city'];
    formatted = json['formatted'];
    locality = json['locality'];
    telephone = json['telephone'];
    businessDistrict = json['businessDistrict'];
    cityBlock = json['cityBlock'];
    district = json['district'];
    region = json['region'];
    postalCode = json['postal_code'];
    fax = json['fax'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_address'] = this.streetAddress;
    data['country'] = this.country;
    data['city'] = this.city;
    data['formatted'] = this.formatted;
    data['locality'] = this.locality;
    data['telephone'] = this.telephone;
    data['businessDistrict'] = this.businessDistrict;
    data['cityBlock'] = this.cityBlock;
    data['district'] = this.district;
    data['region'] = this.region;
    data['postal_code'] = this.postalCode;
    data['fax'] = this.fax;
    data['email'] = this.email;
    return data;
  }
}
class Mobile {
  String pageId;
  Url url;
  Card card;

  Mobile({this.pageId, this.url, this.card});

  Mobile.fromJson(Map<String, dynamic> json) {
    pageId = json['page_id'];
    url = json['url'] != null ? new Url.fromJson(json['url']) : null;
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_id'] = this.pageId;
    if (this.url != null) {
      data['url'] = this.url.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}
class Url {
  String scheme;
  String name;
  int status;

  Url({this.scheme, this.name, this.status});

  Url.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
class Card {
  String scheme;
  List<String> contents;
  int isAsyn;
  String pic;
  int type;
  String highScheme;
  int status;

  Card(
      {this.scheme,
      this.contents,
      this.isAsyn,
      this.pic,
      this.type,
      this.highScheme,
      this.status});

  Card.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    contents = json['contents'].cast<String>();
    isAsyn = json['is_asyn'];
    pic = json['pic'];
    type = json['type'];
    highScheme = json['high_scheme'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['contents'] = this.contents;
    data['is_asyn'] = this.isAsyn;
    data['pic'] = this.pic;
    data['type'] = this.type;
    data['high_scheme'] = this.highScheme;
    data['status'] = this.status;
    return data;
  }
}


class Collection extends Object{

  List<String> picIds;
  String commentId;
  Collection({
    this.picIds,
    this.commentId});

  Collection.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    picIds = json['pic_ids'].cast<String>();
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['pic_ids'] = this.picIds;
    data['comment_id'] = this.commentId;
    return data;
  }
}

class Place extends Object{
  String summary;
  Image image;
  Address address;
  Mobile mobile;
  String checkinNum;
  String position;
  String keyword;

  Place.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    checkinNum=json['checkin_num'];
    position=json['position'];
    keyword=json['keyword'];
    summary = json['summary'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    mobile = json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['summary'] = this.summary;
    data['checkin_num'] = this.checkinNum;
    data['position'] = this.position;
    data['keyword'] = this.keyword;
    return data;
  }
}

class Video extends Object{
  int fid;
  String storageType;
  String videoCover;
  int copyright;
  Extension extension;
  String targetUrl;
  InputTags inputTags;
  String videoOrientation;
  String createdAt;
  List<String> logos;
  Screenshots screenshots;
  double duration;
  RawFileMeta rawFileMeta;
  Urls urls;
  String protocol;
  Biz biz;
  String fileMonitorType;
  String updatedAt;
  Stream stream;
  String client;
  Links links;
  String definition;
  String clientIp;
  String id;
  bool coverImage;
  String authorMid;
  String summary;
  String embedCode;
  Image image;
  String objectType;
  Author author;
  String bizType;
  int infringementStatus;
  String displayName;
  ExtInfo extInfo;
  String url;
  String videoType;
  String objectTypeDetail;
  String originalUrl;
  String originalFileMd5;
  CompressedFileMeta compressedFileMeta;
  int appid;
  bool domesticOnly;
  String fileCreateType;
  CustomData customData;

  Video(
      {this.fid,
      this.storageType,
      this.videoCover,
      this.copyright,
      this.extension,
      this.targetUrl,
      this.inputTags,
      this.videoOrientation,
      this.createdAt,
      this.logos,
      this.screenshots,
      this.duration,
      this.rawFileMeta,
      this.urls,
      this.protocol,
      this.biz,
      this.fileMonitorType,
      this.updatedAt,
      this.stream,
      this.client,
      this.links,
      this.definition,
      this.clientIp,
      this.id,
      this.coverImage,
      this.authorMid,
      this.summary,
      this.embedCode,
      this.image,
      this.objectType,
      this.author,
      this.bizType,
      this.infringementStatus,
      this.displayName,
      this.extInfo,
      this.url,
      this.videoType,
      this.objectTypeDetail,
      this.originalUrl,
      this.originalFileMd5,
      this.compressedFileMeta,
      this.appid,
      this.domesticOnly,
      this.fileCreateType,
      this.customData});

  Video.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    storageType = json['storage_type'];
    videoCover = json['video_cover'];
    copyright = json['copyright'];
    extension = json['extension'] != null
        ? new Extension.fromJson(json['extension'])
        : null;
    targetUrl = json['target_url'];
    inputTags = json['input_tags'] != null
        ? new InputTags.fromJson(json['input_tags'])
        : null;
    videoOrientation = json['video_orientation'];
    createdAt = json['created_at'];
    logos = json['logos'].cast<String>();
    screenshots = json['screenshots'] != null
        ? new Screenshots.fromJson(json['screenshots'])
        : null;
    duration = json['duration'];
    rawFileMeta = json['raw_file_meta'] != null
        ? new RawFileMeta.fromJson(json['raw_file_meta'])
        : null;
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
    protocol = json['protocol'];
    biz = json['biz'] != null ? new Biz.fromJson(json['biz']) : null;
    fileMonitorType = json['file_monitor_type'];
    updatedAt = json['updated_at'];
    stream =
        json['stream'] != null ? new Stream.fromJson(json['stream']) : null;
    client = json['client'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    definition = json['definition'];
    clientIp = json['client_ip'];
    id = json['id'];
    coverImage = json['cover_image'];
    authorMid = json['author_mid'];
    summary = json['summary'];
    embedCode = json['embed_code'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    objectType = json['object_type'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    bizType = json['biz_type'];
    infringementStatus = json['infringement_status'];
    displayName = json['display_name'];
    extInfo = json['ext_info'] != null
        ? new ExtInfo.fromJson(json['ext_info'])
        : null;
    url = json['url'];
    videoType = json['video_type'];
    objectTypeDetail = json['object_type_detail'];
    originalUrl = json['original_url'];
    originalFileMd5 = json['original_file_md5'];
    compressedFileMeta = json['compressed_file_meta'] != null
        ? new CompressedFileMeta.fromJson(json['compressed_file_meta'])
        : null;
    appid = json['appid'];
    domesticOnly = json['domesticOnly'];
    fileCreateType = json['file_create_type'];
    customData = json['custom_data'] != null
        ? new CustomData.fromJson(json['custom_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fid'] = this.fid;
    data['storage_type'] = this.storageType;
    data['video_cover'] = this.videoCover;
    data['copyright'] = this.copyright;
    if (this.extension != null) {
      data['extension'] = this.extension.toJson();
    }
    data['target_url'] = this.targetUrl;
    if (this.inputTags != null) {
      data['input_tags'] = this.inputTags.toJson();
    }
    data['video_orientation'] = this.videoOrientation;
    data['created_at'] = this.createdAt;
    data['logos'] = this.logos;
    if (this.screenshots != null) {
      data['screenshots'] = this.screenshots.toJson();
    }
    data['duration'] = this.duration;
    if (this.rawFileMeta != null) {
      data['raw_file_meta'] = this.rawFileMeta.toJson();
    }
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    data['protocol'] = this.protocol;
    if (this.biz != null) {
      data['biz'] = this.biz.toJson();
    }
    data['file_monitor_type'] = this.fileMonitorType;
    data['updated_at'] = this.updatedAt;
    if (this.stream != null) {
      data['stream'] = this.stream.toJson();
    }
    data['client'] = this.client;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    data['definition'] = this.definition;
    data['client_ip'] = this.clientIp;
    data['id'] = this.id;
    data['cover_image'] = this.coverImage;
    data['author_mid'] = this.authorMid;
    data['summary'] = this.summary;
    data['embed_code'] = this.embedCode;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['object_type'] = this.objectType;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['biz_type'] = this.bizType;
    data['infringement_status'] = this.infringementStatus;
    data['display_name'] = this.displayName;
    if (this.extInfo != null) {
      data['ext_info'] = this.extInfo.toJson();
    }
    data['url'] = this.url;
    data['video_type'] = this.videoType;
    data['object_type_detail'] = this.objectTypeDetail;
    data['original_url'] = this.originalUrl;
    data['original_file_md5'] = this.originalFileMd5;
    if (this.compressedFileMeta != null) {
      data['compressed_file_meta'] = this.compressedFileMeta.toJson();
    }
    data['appid'] = this.appid;
    data['domesticOnly'] = this.domesticOnly;
    data['file_create_type'] = this.fileCreateType;
    if (this.customData != null) {
      data['custom_data'] = this.customData.toJson();
    }
    return data;
  }
}

class Extension {
  List<Covers> covers;

  Extension({this.covers});

  Extension.fromJson(Map<String, dynamic> json) {
    if (json['covers'] != null) {
      covers = new List<Covers>();
      json['covers'].forEach((v) {
        covers.add(new Covers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.covers != null) {
      data['covers'] = this.covers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Covers {
  int width;
  String pid;
  int source;
  int isSelfCover;
  int type;
  String url;
  int height;

  Covers(
      {this.width,
      this.pid,
      this.source,
      this.isSelfCover,
      this.type,
      this.url,
      this.height});

  Covers.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    pid = json['pid'];
    source = json['source'];
    isSelfCover = json['is_self_cover'];
    type = json['type'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['pid'] = this.pid;
    data['source'] = this.source;
    data['is_self_cover'] = this.isSelfCover;
    data['type'] = this.type;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}

class InputTags {
  String creationTime;
  String location;

  InputTags({this.creationTime, this.location});

  InputTags.fromJson(Map<String, dynamic> json) {
    creationTime = json['creation_time'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creation_time'] = this.creationTime;
    data['location'] = this.location;
    return data;
  }
}

class Screenshots {
  String s1;
  String s2;
  String s3;
  String s4;
  String s5;

  Screenshots({this.s1, this.s2, this.s3, this.s4, this.s5});

  Screenshots.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    return data;
  }
}

class RawFileMeta {
  String md5;

  RawFileMeta({this.md5});

  RawFileMeta.fromJson(Map<String, dynamic> json) {
    md5 = json['md5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md5'] = this.md5;
    return data;
  }
}

class Urls {
  String mp4720pMp4;
  String mp4HdMp4;
  String mp4LdMp4;

  Urls({this.mp4720pMp4, this.mp4HdMp4, this.mp4LdMp4});

  Urls.fromJson(Map<String, dynamic> json) {
    mp4720pMp4 = json['mp4_720p_mp4'];
    mp4HdMp4 = json['mp4_hd_mp4'];
    mp4LdMp4 = json['mp4_ld_mp4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mp4_720p_mp4'] = this.mp4720pMp4;
    data['mp4_hd_mp4'] = this.mp4HdMp4;
    data['mp4_ld_mp4'] = this.mp4LdMp4;
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

class Links {
  String url;

  Links({this.url});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}


class Author {
  int verifiedLevel;
  String avatarLarge;
  String objectType;
  int followersCount;
  bool verified;
  String verifiedReason;
  String id;
  String displayName;
  int verifiedType;
  int verifiedTypeExt;

  Author(
      {this.verifiedLevel,
      this.avatarLarge,
      this.objectType,
      this.followersCount,
      this.verified,
      this.verifiedReason,
      this.id,
      this.displayName,
      this.verifiedType,
      this.verifiedTypeExt});

  Author.fromJson(Map<String, dynamic> json) {
    verifiedLevel = json['verified_level'];
    avatarLarge = json['avatar_large'];
    objectType = json['object_type'];
    followersCount = json['followers_count'];
    verified = json['verified'];
    verifiedReason = json['verified_reason'];
    id = json['id'];
    displayName = json['display_name'];
    verifiedType = json['verified_type'];
    verifiedTypeExt = json['verified_type_ext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verified_level'] = this.verifiedLevel;
    data['avatar_large'] = this.avatarLarge;
    data['object_type'] = this.objectType;
    data['followers_count'] = this.followersCount;
    data['verified'] = this.verified;
    data['verified_reason'] = this.verifiedReason;
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['verified_type'] = this.verifiedType;
    data['verified_type_ext'] = this.verifiedTypeExt;
    return data;
  }
}

class ExtInfo {
  String videoOrientation;

  ExtInfo({this.videoOrientation});

  ExtInfo.fromJson(Map<String, dynamic> json) {
    videoOrientation = json['video_orientation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_orientation'] = this.videoOrientation;
    return data;
  }
}

class CompressedFileMeta {
  VideoMediaInfo videoMediaInfo;
  String md5;

  CompressedFileMeta({this.videoMediaInfo, this.md5});

  CompressedFileMeta.fromJson(Map<String, dynamic> json) {
    videoMediaInfo = json['video_media_info'] != null
        ? new VideoMediaInfo.fromJson(json['video_media_info'])
        : null;
    md5 = json['md5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videoMediaInfo != null) {
      data['video_media_info'] = this.videoMediaInfo.toJson();
    }
    data['md5'] = this.md5;
    return data;
  }
}

class VideoMediaInfo {
  int width;
  int height;

  VideoMediaInfo({this.width, this.height});

  VideoMediaInfo.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class CustomData {
  String source;

  CustomData({this.source});

  CustomData.fromJson(Map<String, dynamic> json) {
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    return data;
  }
}