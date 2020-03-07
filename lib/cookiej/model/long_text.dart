class LongText {
	String longTextContent;
	List<dynamic> urlObjects;

	LongText({this.longTextContent, this.urlObjects});

	LongText.fromJson(Map<String, dynamic> json) {
		longTextContent = json['longTextContent'];
		if (json['url_objects'] != null) {
			urlObjects = new List<dynamic>();
			json['url_objects'].forEach((v) { urlObjects.add(v); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['longTextContent'] = this.longTextContent;
		if (this.urlObjects != null) {
      data['url_objects'] = this.urlObjects.map((v) => v.toJson()).toList();
    }
		return data;
	}
}