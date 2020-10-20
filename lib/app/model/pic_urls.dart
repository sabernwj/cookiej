class PicUrls {
	String thumbnailPic;

	PicUrls({this.thumbnailPic});

	PicUrls.fromJson(Map<String, dynamic> json) {
		thumbnailPic = json['thumbnail_pic'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['thumbnail_pic'] = this.thumbnailPic;
		return data;
	}
}