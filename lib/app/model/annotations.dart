import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

import 'collection.dart';
import 'data_object.dart';
import 'place.dart';
import 'video.dart';

part 'annotations.g.dart';

@HiveType(typeId: HiveBoxType.urlAnnotations)
class Annotations {
  @HiveField(0)
  String uuidstr;
  @HiveField(1)
  String objectType;
  @HiveField(2)
  String activateStatus;
  @HiveField(3)
  int safeStatus;
  @HiveField(4)
  String objectId;
  @HiveField(5)
  int uuid;
  @HiveField(6)
  String actStatus;
  @HiveField(7)
  String objectDomainId;
  @HiveField(8)
  String containerid;
  @HiveField(9)
  String showStatus;
  @HiveField(10)
  String lastModified;
  @HiveField(11)
  int timestamp;
  @HiveField(12)
  DataObject object;

  Annotations(
      {this.uuidstr,
      this.objectType,
      this.activateStatus,
      this.safeStatus,
      this.objectId,
      this.uuid,
      this.actStatus,
      this.objectDomainId,
      this.containerid,
      this.showStatus,
      this.lastModified,
      this.timestamp,
      this.object});

  Annotations.fromJson(Map<String, dynamic> json) {
    uuidstr = json['uuidstr'];
    objectType = json['object_type'];
    activateStatus = json['activate_status'];
    safeStatus = json['safe_status'];
    objectId = json['object_id'];
    uuid = (json['uuid'] is String) ? int.parse(json['uuid']) : json['uuid'];
    actStatus = json['act_status'];
    objectDomainId = json['object_domain_id'];
    containerid = json['containerid'];
    showStatus = json['show_status'];
    lastModified = json['last_modified'];
    timestamp = json['timestamp'];
    object = json['object'] != null
        ? () {
            switch (objectType) {
              case 'place':
                return Place.fromJson(json['object']);
              case 'collection':
                return Collection.fromJson(json['object']);
              case 'video':
                return Video.fromJson(json['object']);
              default:
                return DataObject.fromJson(json['object']);
            }
          }()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuidstr'] = this.uuidstr;
    data['object_type'] = this.objectType;
    data['activate_status'] = this.activateStatus;
    data['safe_status'] = this.safeStatus;
    data['object_id'] = this.objectId;
    data['uuid'] = this.uuid;
    data['act_status'] = this.actStatus;
    data['object_domain_id'] = this.objectDomainId;
    data['containerid'] = this.containerid;
    data['show_status'] = this.showStatus;
    data['last_modified'] = this.lastModified;
    data['timestamp'] = this.timestamp;
    if (this.object != null) {
      data['object'] = this.object.toJson();
    }
    return data;
  }
}
