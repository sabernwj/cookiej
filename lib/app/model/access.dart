class Access {
  String uid;
  String accessToken;
  Access({this.uid, this.accessToken});
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
