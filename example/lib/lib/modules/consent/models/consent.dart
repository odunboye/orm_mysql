import 'dart:convert';

import 'package:oniru_server/shared/util/dateUtil.dart';
import 'package:orm/orm.dart';

@table
class Consent {
  Consent({
    this.id,
    this.propertyId,
    this.newOwnerId,
    this.oldOwnerId,
    this.surveyNo,
    this.witnessFirstName,
    this.witnessLastName,
    this.witnessAddress,
    this.witnessOccupation,
    this.status,
    this.initiatorId,
    this.verifierId,
    this.approverId,
    this.dateInitiated,
    this.dateVerified,
    this.dateApproved,
    this.rejectComment,
  });

  factory Consent.fromMap(Map<String, dynamic> map) {
    return Consent(
      id: map['id'] as int,
      propertyId: map['propertyId'] as int, // map['propertyId'] as int,
      newOwnerId: map['newOwnerId'] as int,
      oldOwnerId: map['oldOwnerId'] as int,
      surveyNo: map['surveyNo'] as String,
      witnessFirstName: map['witnessFirstName'] as String,
      witnessLastName: map['witnessLastName'] as String,
      witnessOccupation: map['witnessOccupation'] as String,
      witnessAddress: map['witnessAddress'] as String,
      initiatorId: map['initiatorId'] as int,
      verifierId: map['verifierId'] as int,
      approverId: map['approverId'] as int,
      dateInitiated:
          map['dateInitiated'] == null ? null : map['dateInitiated'].toString(),
      dateVerified:
          map['dateVerified'] == null ? null : map['dateVerified'].toString(),
      dateApproved:
          map['dateApproved'] == null ? null : map['dateApproved'].toString(),
      status: map['status'] as String,
      rejectComment: map['rejectComment'] as String,
    );
  }
  factory Consent.fromJson(String source) =>
      Consent.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'propertyId': propertyId,
      'newOwnerId': newOwnerId,
      'oldOwnerId': oldOwnerId,
      'surveyNo': surveyNo,
      'witnessFirstName': witnessFirstName,
      'witnessLastName': witnessLastName,
      'witnessOccupation': witnessOccupation,
      'witnessAddress': witnessAddress,
      'initiatorId': initiatorId,
      'verifierId': verifierId,
      'approverId': approverId,
      'dateInitiated':
          dateTimeFormatter.format(DateTime.tryParse(dateInitiated.toString())),
      'dateVerified': dateVerified == null
          ? null
          : dateTimeFormatter
              .format(DateTime.tryParse(dateVerified.toString())),
      'dateApproved': dateApproved == null
          ? null
          : dateTimeFormatter
              .format(DateTime.tryParse(dateApproved.toString())),
      'status': status,
      'rejectComment': rejectComment,
    };
  }

  @Id()
  int id;
  int propertyId;
  int newOwnerId;
  int oldOwnerId;
  String surveyNo;
  String witnessFirstName;
  String witnessLastName;
  String witnessAddress;
  String witnessOccupation;
  int initiatorId;
  int verifierId;
  int approverId;
  String status;
  String dateInitiated;
  String dateVerified;
  String dateApproved;
  String rejectComment;
}
