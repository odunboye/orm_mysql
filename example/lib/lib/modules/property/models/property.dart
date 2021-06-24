import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:oniru_server/shared/util/dateUtil.dart';
import 'package:orm/orm.dart';

@table
class Property {
  Property({
    this.id,
    this.refNum,
    this.area,
    this.block,
    this.plot,
    this.landSize,
    this.typeId,
    this.usageId,
    this.statusId,
    this.createdAt,
    this.initiatorId,
    this.verifierId,
    this.approverId,
    this.dateInitiated,
    this.dateVerified,
    this.dateApproved,
    this.status,
    this.rejectComment,
  });

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] as int,
      refNum: map['refNum'] as String,
      area: map['area'] as String,
      block: map['block'] as String,
      plot: map['plot'] as String,
      landSize: map['landSize'] as double,
      typeId: map['typeId'] as int,
      usageId: map['usageId'] as int,
      statusId: map['statusId'] as int,
      createdAt: DateFormat('yyyy-MM-dd')
          .format(DateTime.tryParse(map['createdAt'].toString())),
      initiatorId: map['initiatorId'] as int,
      verifierId: map['verifierId'] as int,
      approverId: map['approverId'] as int,
      dateInitiated: map['dateInitiated'] as DateTime,
      dateVerified: map['dateVerified'] as DateTime,
      dateApproved: map['dateApproved'] as DateTime,
      status: map['status'] as String,
      rejectComment: map['rejectComment'] as String,
    );
  }

  factory Property.fromJson(String source) =>
      Property.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final DateFormat f = DateFormat('yyyy-MM-dd hh:mm');
    return <String, dynamic>{
      'id': id,
      'refNum': refNum,
      'area': area,
      'block': block,
      'plot': plot,
      'landSize': landSize,
      'typeId': typeId,
      'usageId': usageId,
      'statusId': statusId,
      'createdAt': createdAt,
      'initiatorId': initiatorId,
      'verifierId': verifierId,
      'approverId': approverId,
      'dateInitiated': dateTimeFormatter.format(dateInitiated).toString(),
      'dateVerified': dateVerified == null
          ? null
          : dateTimeFormatter.format(dateVerified).toString(),
      'dateApproved': dateApproved == null
          ? null
          : dateTimeFormatter.format(dateApproved).toString(),
      'status': status,
      'rejectComment': rejectComment,
    };
  }

  @Id()
  int id;
  String refNum;
  String area;
  String block;
  String plot;
  double landSize;
  int typeId;
  int usageId;
  int statusId;
  String createdAt;
  int initiatorId;
  int verifierId;
  int approverId;
  DateTime dateInitiated;
  DateTime dateVerified;
  DateTime dateApproved;
  String status;
  String rejectComment;
}
