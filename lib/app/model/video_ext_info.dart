class VideoExtInfo {
  String videoOrientation;

  VideoExtInfo({this.videoOrientation});

  VideoExtInfo.fromJson(Map<String, dynamic> json) {
    videoOrientation = json['video_orientation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_orientation'] = this.videoOrientation;
    return data;
  }
}