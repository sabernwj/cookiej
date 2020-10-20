class Address {
  String streetAddress;
  String country;
  String city;
  String formatted;
  String locality;
  String telephone;
  String businessDistrict;
  String cityBlock;
  String district;
  String region;
  String postalCode;
  String fax;
  String email;

  Address(
      {this.streetAddress,
      this.country,
      this.city,
      this.formatted,
      this.locality,
      this.telephone,
      this.businessDistrict,
      this.cityBlock,
      this.district,
      this.region,
      this.postalCode,
      this.fax,
      this.email});

  Address.fromJson(Map<String, dynamic> json) {
    streetAddress = json['street_address'];
    country = json['country'];
    city = json['city'];
    formatted = json['formatted'];
    locality = json['locality'];
    telephone = json['telephone'];
    businessDistrict = json['businessDistrict'];
    cityBlock = json['cityBlock'];
    district = json['district'];
    region = json['region'];
    postalCode = json['postal_code'];
    fax = json['fax'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_address'] = this.streetAddress;
    data['country'] = this.country;
    data['city'] = this.city;
    data['formatted'] = this.formatted;
    data['locality'] = this.locality;
    data['telephone'] = this.telephone;
    data['businessDistrict'] = this.businessDistrict;
    data['cityBlock'] = this.cityBlock;
    data['district'] = this.district;
    data['region'] = this.region;
    data['postal_code'] = this.postalCode;
    data['fax'] = this.fax;
    data['email'] = this.email;
    return data;
  }
}