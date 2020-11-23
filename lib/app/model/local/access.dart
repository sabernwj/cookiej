import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

part 'access.g.dart';

@HiveType(typeId: HiveBoxType.accessBox)
class Access {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String accessToken;
  @HiveField(2)
  List<String> cookieStrs;

  @HiveField(3)
  List<Map<String, String>> groupIdNames;
  @HiveField(4)
  bool accessInvalid;

  Access({this.uid, this.accessToken, this.cookieStrs});
  Access.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['access_token'] = this.accessToken;
    return data;
  }
}
