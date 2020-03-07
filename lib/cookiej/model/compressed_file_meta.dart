import 'video_media_info.dart';

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