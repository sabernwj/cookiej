import 'data_objetc.dart';
import 'author.dart';
import 'biz.dart';
import 'compressed_file_meta.dart';
import 'custom_data.dart';
import 'links.dart';
import 'uimage.dart';
import 'video_ext_info.dart';
import 'video_stream.dart';
import 'video_urls.dart';
import 'input_tags.dart';
import 'raw_file_meta.dart';
import 'screen_hosts.dart';
import 'video_extensions.dart';

class Video extends DataObject{
  int fid;
  String storageType;
  String videoCover;
  int copyright;
  VideoExtensions extensions;
  String targetUrl;
  InputTags inputTags;
  String videoOrientation;
  String createdAt;
  Screenshots screenshots;
  double duration;
  RawFileMeta rawFileMeta;
  VideoUrls urls;
  String protocol;
  Biz biz;
  String fileMonitorType;
  String updatedAt;
  VideoStream stream;
  String client;
  Links links;
  String definition;
  String clientIp;
  String id;
  bool coverUImage;
  String authorMid;
  String summary;
  String embedCode;
  UImage image;
  String objectType;
  Author author;
  String bizType;
  int infringementStatus;
  String displayName;
  VideoExtInfo extInfo;
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
      this.extensions,
      this.targetUrl,
      this.inputTags,
      this.videoOrientation,
      this.createdAt,
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
      this.coverUImage,
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
    extensions = json['extension'] != null
        ? new VideoExtensions.fromJson(json['extension'])
        : null;
    targetUrl = json['target_url'];
    inputTags = json['input_tags'] != null
        ? new InputTags.fromJson(json['input_tags'])
        : null;
    videoOrientation = json['video_orientation'];
    createdAt = json['created_at'];
    screenshots = json['screenshots'] != null
        ? new Screenshots.fromJson(json['screenshots'])
        : null;
    duration = (json['duration'] is int)?(json['duration'] as int).toDouble():json['duration'];
    rawFileMeta = json['raw_file_meta'] != null
        ? new RawFileMeta.fromJson(json['raw_file_meta'])
        : null;
    urls = json['urls'] != null ? new VideoUrls.fromJson(json['urls']) : null;
    protocol = json['protocol'];
    biz = json['biz'] != null ? new Biz.fromJson(json['biz']) : null;
    fileMonitorType = json['file_monitor_type'];
    updatedAt = json['updated_at'];
    stream =
        json['stream'] != null ? new VideoStream.fromJson(json['stream']) : null;
    client = json['client'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    definition = json['definition'];
    clientIp = json['client_ip'];
    id = json['id'];
    coverUImage = json['cover_image'];
    authorMid = json['author_mid'];
    summary = json['summary'];
    embedCode = json['embed_code'];
    image = json['image'] != null ? new UImage.fromJson(json['image']) : null;
    objectType = json['object_type'];
    author =
        (json['author'] != null && json['author'] is Map) ? new Author.fromJson(json['author']) : null;
    bizType = json['biz_type'];
    infringementStatus = json['infringement_status'];
    displayName = json['display_name'];
    extInfo = json['ext_info'] != null
        ? new VideoExtInfo.fromJson(json['ext_info'])
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
    if (this.extensions != null) {
      data['extension'] = this.extensions.toJson();
    }
    data['target_url'] = this.targetUrl;
    if (this.inputTags != null) {
      data['input_tags'] = this.inputTags.toJson();
    }
    data['video_orientation'] = this.videoOrientation;
    data['created_at'] = this.createdAt;
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
    data['cover_image'] = this.coverUImage;
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
