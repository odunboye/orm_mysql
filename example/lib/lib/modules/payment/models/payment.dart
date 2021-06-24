import 'dart:convert';
import 'package:orm/orm.dart';

@table
class Payment {
  Payment({
    this.id,
    this.propertyId,
    this.amount,
    this.payer,
    this.originatingBank,
    this.receivingBank,
    this.tellerRefNo,
    this.evidence,
    this.datePaid,
    this.initiatorId,
    this.verifierId,
    this.approverId,
    this.dateInitiated,
    this.dateVerified,
    this.dateApproved,
    this.status,
    this.rejectComment,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int,
      propertyId: map['propertyId'] as int,
      amount: double.tryParse(map['amount'].toString()),
      payer: map['payer'] as String,
      originatingBank: map['originatingBank'] as String,
      receivingBank: map['receivingBank'] as String,
      tellerRefNo: map['tellerRefNo'] as String,
      evidence: map['evidence'] as String,
      datePaid: map['datePaid'].toString(),
      initiatorId: map['initiatorId'] as int,
      verifierId: map['verifierId'] as int,
      approverId: map['approverId'] as int,
      dateInitiated: map['dateInitiated'].toString(),
      dateVerified:
          map['dateVerified'] == null ? null : map['dateVerified'].toString(),
      dateApproved:
          map['dateApproved'] == null ? null : map['dateApproved'].toString(),
      status: map['status'] as String,
      rejectComment: map['rejectComment'] as String,
    );
  }
  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'propertyId': propertyId,
      'amount': amount,
      'payer': payer,
      'originatingBank': originatingBank,
      'receivingBank': receivingBank,
      'tellerRefNo': tellerRefNo,
      'evidence': evidence,
      'datePaid': datePaid.toString(),
      'initiatorId': initiatorId,
      'verifierId': verifierId,
      'approverId': approverId,
      'dateInitiated': dateInitiated.toString(),
      'dateVerified': dateVerified == null ? null : dateVerified.toString(),
      'dateApproved': dateApproved == null ? null : dateApproved.toString(),
      'status': status,
      'rejectComment': rejectComment,
    };
  }

  @Id()
  int id;
  int propertyId;
  double amount;
  String payer;
  String originatingBank;
  String receivingBank;
  String tellerRefNo;
  String evidence;
  String datePaid;
  int initiatorId;
  int verifierId;
  int approverId;
  String dateInitiated;
  String dateVerified;
  String dateApproved;
  String status;
  String rejectComment;
}
