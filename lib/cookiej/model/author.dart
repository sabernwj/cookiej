class Author {
  int verifiedLevel;
  String avatarLarge;
  String objectType;
  int followersCount;
  bool verified;
  String verifiedReason;
  String id;
  String displayName;
  int verifiedType;
  int verifiedTypeExt;

  Author(
      {this.verifiedLevel,
      this.avatarLarge,
      this.objectType,
      this.followersCount,
      this.verified,
      this.verifiedReason,
      this.id,
      this.displayName,
      this.verifiedType,
      this.verifiedTypeExt});

  Author.fromJson(Map<String, dynamic> json) {
    verifiedLevel = json['verified_level'];
    avatarLarge = json['avatar_large'];
    objectType = json['object_type'];
    followersCount = json['followers_count'];
    verified = json['verified'];
    verifiedReason = json['verified_reason'];
    id = json['id'];
    displayName = json['display_name'];
    verifiedType = json['verified_type'];
    verifiedTypeExt = json['verified_type_ext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verified_level'] = this.verifiedLevel;
    data['avatar_large'] = this.avatarLarge;
    data['object_type'] = this.objectType;
    data['followers_count'] = this.followersCount;
    data['verified'] = this.verified;
    data['verified_reason'] = this.verifiedReason;
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['verified_type'] = this.verifiedType;
    data['verified_type_ext'] = this.verifiedTypeExt;
    return data;
  }
}