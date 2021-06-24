import 'dart:convert';

import 'package:orm/orm.dart';

@table
class Owner {
  Owner({
    this.id,
    this.firstName,
    this.lastName,
    this.otherNames,
    this.address,
    this.district,
    this.contactEmail,
    this.mobile,
    this.otherPhone,
    this.createdAt,
  });

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      otherNames: map['otherNames'] as String,
      address: map['address'] as String,
      district: map['district'] as String,
      contactEmail: map['contactEmail'] as String,
      mobile: map['mobile'] as String,
      otherPhone: map['otherPhone'] as String,
      createdAt: map['createdAt'].toString(),
    );
  }

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    otherNames = json['otherNames'] as String;
    address = json['address'] as String;
    district = json['district'] as String;
    contactEmail = json['contactEmail'] as String;
    mobile = json['mobile'] as String;
    otherPhone = json['otherPhone'] as String;
    createdAt = json['createdAt'].toString();
  }

  factory Owner.fromJson2(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson2() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'otherNames': otherNames,
      'address': address,
      'district': district,
      'contactEmail': contactEmail,
      'mobile': mobile,
      'otherPhone': otherPhone,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['otherNames'] = otherNames;
    data['address'] = address;
    data['district'] = district;
    data['contactEmail'] = contactEmail;
    data['mobile'] = mobile;
    data['otherPhone'] = otherPhone;
    data['createdAt'] = createdAt;
    return data;
  }

  @Id()
  int id;
  String firstName;
  String lastName;
  String otherNames;
  String address;
  String district;
  String contactEmail;
  String mobile;
  String otherPhone;
  String createdAt;
}
