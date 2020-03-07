class Card {
  String scheme;
  List<String> contents;
  int isAsyn;
  String pic;
  int type;
  String highScheme;
  int status;

  Card(
      {this.scheme,
      this.contents,
      this.isAsyn,
      this.pic,
      this.type,
      this.highScheme,
      this.status});

  Card.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    contents = json['contents'].cast<String>();
    isAsyn = json['is_asyn'];
    pic = json['pic'];
    type = json['type'];
    highScheme = json['high_scheme'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['contents'] = this.contents;
    data['is_asyn'] = this.isAsyn;
    data['pic'] = this.pic;
    data['type'] = this.type;
    data['high_scheme'] = this.highScheme;
    data['status'] = this.status;
    return data;
  }
}
