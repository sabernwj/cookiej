class Biz {
  String bizId;
  String containerid;

  Biz({this.bizId, this.containerid});

  Biz.fromJson(Map<String, dynamic> json) {
    bizId = json['biz_id'];
    containerid = json['containerid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biz_id'] = this.bizId;
    data['containerid'] = this.containerid;
    return data;
  }
}