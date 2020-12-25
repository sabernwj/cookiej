import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

import 'annotations.dart';
part 'url_info.g.dart';

@HiveType(typeId: HiveBoxType.urlInfoBox)
class UrlInfo {
  @HiveField(0)
  bool result;
  @HiveField(1)
  String urlShort;
  @HiveField(2)
  String urlLong;
  int transcode;
  @HiveField(3)
  String description;
  @HiveField(4)
  List<Annotations> annotations;
  @HiveField(5)
  int type;
  @HiveField(6)
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
        if (v is! Map<String, dynamic>) {
          print(v.runtimeType);
        }
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
