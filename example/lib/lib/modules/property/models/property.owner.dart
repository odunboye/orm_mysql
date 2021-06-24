import 'package:oniru_server/modules/owner/models/owner.dart';
import 'package:oniru_server/modules/property/models/property.dart';

class PropertyOwner {
  PropertyOwner({
    this.property,
    this.owner,
  });

  final Property property;
  final Owner owner;

  static PropertyOwner fromJson(dynamic json) => PropertyOwner(
        property: json['property'] == null
            ? null
            : Property.fromMap(json['property'] as Map<String, dynamic>),
        owner: json['owner'] == null
            ? null
            : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'property': property.toJson(),
        'owner': owner.toJson(),
      };
}
