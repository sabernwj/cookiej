class VideoUrls {
  String mp4720pMp4;
  String mp4HdMp4;
  String mp4LdMp4;

  VideoUrls({this.mp4720pMp4, this.mp4HdMp4, this.mp4LdMp4});

  VideoUrls.fromJson(Map<String, dynamic> json) {
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