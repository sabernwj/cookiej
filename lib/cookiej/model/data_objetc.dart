import 'biz.dart';

class DataObject {
  Biz biz;
  String objectType;
  String targetUrl;
  String id;
  String displayName;
  String url;

  DataObject(
      {this.biz,
      this.objectType,
      this.targetUrl,
      this.id,
      this.displayName,
      this.url});

  DataObject.fromJson(Map<String, dynamic> json) {
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