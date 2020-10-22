class Access {
  String uid;
  String accessToken;
  List<String> cookieStrs;
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
