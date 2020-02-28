class Insecurity {
	bool sexualContent;

	Insecurity({this.sexualContent});

	Insecurity.fromJson(Map<String, dynamic> json) {
		sexualContent = json['sexual_content'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sexual_content'] = this.sexualContent;
		return data;
	}
}
