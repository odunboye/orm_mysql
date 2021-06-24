import 'dart:convert';

import 'package:oniru_server/modules/authority/models/authority.dart';
import 'package:oniru_server/modules/user/models/user.dart';

class UserInfoModel {
  UserInfoModel({
    this.user,
    this.token,
    this.authorities,
  });
  factory UserInfoModel.fromJson(String source) =>
      UserInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  final User user;
  final String token;
  final List<Authority> authorities;

  static UserInfoModel fromMap(dynamic json) => UserInfoModel(
        user: json['user'] == null
            ? null
            : User.fromMap(json['user'] as Map<String, dynamic>),
        token: json['token'] as String,
        authorities: json['authorities'] == null
            ? null
            : List<Authority>.from(
                (json['authorities'] as List<dynamic>)
                    .map((x) => Authority.fromJson(x as Map<String, dynamic>)),
              ),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'user': user.toMap(),
        'token': token,
        'authorities': authorities
            .map((Authority authority) => authority.toJson())
            .toList()
      };
}
