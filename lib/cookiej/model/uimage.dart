class UImage {
  String width;
  String url;
  String height;

  UImage({this.width, this.url, this.height});

  UImage.fromJson(Map<String, dynamic> json) {
    width = json['width'].toString();
    url = json['url'];
    height = json['height'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}