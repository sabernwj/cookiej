import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

import 'biz.dart';

part 'data_object.g.dart';

@HiveType(typeId: HiveBoxType.urlAnnotationsDataObject)
class DataObject {
  Biz biz;
  @HiveField(0)
  String objectType;
  @HiveField(1)
  String targetUrl;
  @HiveField(2)
  String id;
  @HiveField(3)
  String displayName;
  @HiveField(4)
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
