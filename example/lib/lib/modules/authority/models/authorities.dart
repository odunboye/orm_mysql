import 'authority.dart';

class Authorities {
  Authorities({this.authorities});
  List<Authority> authorities;

  static Authorities fromJson(dynamic json) => Authorities(
        authorities: json == null
            ? null
            : List<Authority>.from(
                (json as List<dynamic>)
                    .map((x) => Authority.fromJson(x as Map<String, dynamic>)),
              ),
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data;
    if (authorities != null) {
      data['authorities'] = authorities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
