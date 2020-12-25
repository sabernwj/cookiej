import 'address.dart';
import 'data_object.dart';
import 'mobile.dart';
import 'uimage.dart';

class Place extends DataObject {
  String summary;
  UImage image;
  Address address;
  Mobile mobile;
  String checkinNum;
  String position;
  String keyword;

  Place.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    checkinNum = json['checkin_num'];
    position = json['position'];
    keyword = json['keyword'];
    summary = json['summary'];
    image = json['image'] != null ? new UImage.fromJson(json['image']) : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    mobile =
        json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['summary'] = this.summary;
    data['checkin_num'] = this.checkinNum;
    data['position'] = this.position;
    data['keyword'] = this.keyword;
    return data;
  }
}
