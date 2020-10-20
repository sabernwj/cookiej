class VideoStream {
  double duration;
  String format;
  int width;
  String hdUrl;
  String url;
  int height;

  VideoStream(
      {this.duration,
      this.format,
      this.width,
      this.hdUrl,
      this.url,
      this.height});

  VideoStream.fromJson(Map<String, dynamic> json) {
    duration = (json['duration'] is int)?double.parse(json['duration'].toString()):json['duration'];
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
