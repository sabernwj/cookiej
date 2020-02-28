import 'covers.dart';

class VideoExtensions {
  List<Covers> covers;

  VideoExtensions({this.covers});

  VideoExtensions.fromJson(Map<String, dynamic> json) {
    if (json['covers'] != null) {
      covers = new List<Covers>();
      json['covers'].forEach((v) {
        covers.add(new Covers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.covers != null) {
      data['covers'] = this.covers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}