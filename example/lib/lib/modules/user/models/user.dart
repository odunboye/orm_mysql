import 'dart:convert';

import 'package:orm/orm.dart';

enum UserStatus { active, blocked, exceeded, change_password }

UserStatus userStatusFromString(String treatment) {
  UserStatus status;
  for (var _status in UserStatus.values) {
    if (treatment == _status.toString()) {
      status = _status;
      break;
    }
  }
  return status;
}

@table
class User {
  // User({this.id, this.name, this.age, this.email, this.isActive});
  // TODO: this should be map
  User.fromMap(Map<String, dynamic> json) {
    id = json['id'] as int;
    fullName = json['fullName'] as String;
    email = json['email'] as String;
    status = json['status'] as String;
    loginAttempt = json['loginAttempt'] as int;
    lastLogin = json['lastLogin'] as DateTime;
    dateAdded = json['dateAdded'] as DateTime;
  }

  User({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.status,
    this.loginAttempt,
    this.lastLogin,
    this.dateAdded,
  });

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['status'] = status;
    data['loginAttempt'] = loginAttempt;
    data['lastLogin'] = lastLogin.toString();
    data['dateAdded'] = dateAdded.toString();
    return data;
  }

  static User fromJson2(dynamic json) => User(
        id: json['id'] as int,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        status: json['status'] as String,
        loginAttempt: json['login_attempt'] as int,
        lastLogin: DateTime.tryParse(json['last_login'] as String),
        dateAdded: DateTime.tryParse(json['date_added'] as String),
      );

  static List<User> listfromJson(dynamic json) => json == null
      ? null
      : List<User>.from(
          (json as List<dynamic>)
              .map((x) => User.fromJson2(x as Map<String, dynamic>)),
        );

  @Id()
  int id;
  String fullName;
  String email;
  String password;
  String status;
  int loginAttempt;
  DateTime lastLogin;
  DateTime dateAdded;
}
