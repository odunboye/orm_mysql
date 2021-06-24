import 'package:orm/orm.dart';

@table
class Authority {
  Authority({this.name, this.description, this.id});

  @Id()
  int id;
  String name;
  String description;

  static Authority fromJson(dynamic json) => Authority(
        name: json['name'] as String,
        description: json['description'] as String,
        id: json['id'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
      };
}
