class Visible {
	int type;
	int listId;

	Visible({this.type, this.listId});

	Visible.fromJson(Map<String, dynamic> json) {
		type = json['type'];
		listId = json['list_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['type'] = this.type;
		data['list_id'] = this.listId;
		return data;
	}
}