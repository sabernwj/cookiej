class Actionlog {
	String actCode;
	String ext;

	Actionlog({this.actCode, this.ext});

	Actionlog.fromJson(Map<String, dynamic> json) {
		actCode = json['act_code'];
		ext = json['ext'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['act_code'] = this.actCode;
		data['ext'] = this.ext;
		return data;
	}
}