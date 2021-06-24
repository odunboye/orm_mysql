import 'dart:convert';

import 'payment.dart';

class PaymentsResponse {
  PaymentsResponse({
    this.content,
    this.size,
    this.totalElements,
    this.totalPages,
    this.currentPage,
  });

  List<Payment> content;
  int size;
  int totalElements;
  int totalPages;
  int currentPage;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content.map((Payment v) => v.toMap()).toList();
    }
    data['size'] = size;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    return data;
  }
}
