import 'collection.dart';
import 'data_objetc.dart';
import 'place.dart';
import 'video.dart';

class Annotations {
  String uuidstr;
  String objectType;
  String activateStatus;
  int safeStatus;
  String objectId;
  int uuid;
  String actStatus;
  String objectDomainId;
  String containerid;
  String showStatus;
  String lastModified;
  int timestamp;
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
    uuid = (json['uuid'] is String)?int.parse(json['uuid']):json['uuid'];
    actStatus = json['act_status'];
    objectDomainId = json['object_domain_id'];
    containerid = json['containerid'];
    showStatus = json['show_status'];
    lastModified = json['last_modified'];
    timestamp = json['timestamp'];
    object =
        json['object'] != null ? (){
          switch (objectType){
            case 'place':
              return Place.fromJson(json['object']);
            case 'collection':
              return Collection.fromJson(json['object']);
            case 'video':
              return Video.fromJson(json['object']);
            default:
              return DataObject.fromJson(json['object']);
          }
        }() : null;
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
