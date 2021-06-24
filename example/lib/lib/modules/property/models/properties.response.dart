import 'dart:convert';

import 'package:oniru_lib/oniru_lib.dart';

class PropertiesResponse {
  PropertiesResponse({
    this.content,
    this.size,
    this.totalElements,
    this.totalPages,
    this.currentPage,
  });

  List<PropertyDTO> content;
  int size;
  int totalElements;
  int totalPages;
  int currentPage;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content.map((PropertyDTO v) => v.toMap()).toList();
    }
    data['size'] = size;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    return data;
  }
}
