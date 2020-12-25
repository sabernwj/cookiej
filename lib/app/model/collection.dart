import 'package:cookiej/app/model/data_object.dart';

class Collection extends DataObject {
  List<String> picIds;
  String commentId;
  Collection({this.picIds, this.commentId});

  Collection.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    picIds = json['pic_ids'].cast<String>();
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['pic_ids'] = this.picIds;
    data['comment_id'] = this.commentId;
    return data;
  }
}
