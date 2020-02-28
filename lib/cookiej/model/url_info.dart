import 'annotations.dart';

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
