import 'card.dart';
import 'url.dart';

class Mobile {
  String pageId;
  Url url;
  Card card;

  Mobile({this.pageId, this.url, this.card});

  Mobile.fromJson(Map<String, dynamic> json) {
    pageId = json['page_id'];
    url = json['url'] != null ? new Url.fromJson(json['url']) : null;
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_id'] = this.pageId;
    if (this.url != null) {
      data['url'] = this.url.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}