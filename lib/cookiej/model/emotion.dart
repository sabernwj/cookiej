class Emotion {
  String phrase;
  String type;
  String url;
  bool hot;
  bool common;
  String category;
  String icon;
  String value;
  String picid;

  Emotion(
      {this.phrase,
      this.type,
      this.url,
      this.hot,
      this.common,
      this.category,
      this.icon,
      this.value,
      this.picid});

  Emotion.fromJson(Map<String, dynamic> json) {
    phrase = json['phrase'];
    type = json['type'];
    url = json['url'];
    hot = json['hot'];
    common = json['common'];
    category = json['category'];
    icon = json['icon'];
    value = json['value'];
    picid = json['picid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phrase'] = this.phrase;
    data['type'] = this.type;
    data['url'] = this.url;
    data['hot'] = this.hot;
    data['common'] = this.common;
    data['category'] = this.category;
    data['icon'] = this.icon;
    data['value'] = this.value;
    data['picid'] = this.picid;
    return data;
  }
}