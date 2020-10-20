class Url {
  String scheme;
  String name;
  int status;

  Url({this.scheme, this.name, this.status});

  Url.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}