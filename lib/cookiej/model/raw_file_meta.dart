class RawFileMeta {
  String md5;

  RawFileMeta({this.md5});

  RawFileMeta.fromJson(Map<String, dynamic> json) {
    md5 = json['md5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md5'] = this.md5;
    return data;
  }
}