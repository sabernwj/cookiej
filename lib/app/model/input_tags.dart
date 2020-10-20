class InputTags {
  String creationTime;
  String location;

  InputTags({this.creationTime, this.location});

  InputTags.fromJson(Map<String, dynamic> json) {
    creationTime = json['creation_time'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creation_time'] = this.creationTime;
    data['location'] = this.location;
    return data;
  }
}