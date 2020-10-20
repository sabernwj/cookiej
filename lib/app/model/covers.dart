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