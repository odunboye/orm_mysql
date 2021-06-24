import 'models/payment.dart';

Future<Payment> validateUpdatePaymentBody(
  String payload,
) async {
  try {
    if (payload == null) throw Exception('payload invalid');
    Payment body = Payment.fromJson(payload);
    if (body.id?.isNaN ?? true) {
      throw Exception('id not a number');
    } else if (body.propertyId?.isNaN ?? true) {
      throw Exception('proprtyId');
    } else if (body.amount?.isNaN ?? true) {
      throw Exception('amount');
    } else if (body.payer?.isEmpty ?? true) {
      throw Exception('payer');
    } else if (body.originatingBank?.isEmpty ?? true) {
      throw Exception('originatingBank');
    } else if (body.receivingBank?.isEmpty ?? true) {
      throw Exception('receivingBank');
    } else if (body.tellerRefNo?.isEmpty ?? true) {
      throw Exception('tellerRefNo');
    } else if (body.evidence?.isEmpty ?? true) {
      throw Exception('evidence');
    } else if (body.datePaid?.isEmpty ?? true) {
      throw Exception('datePaid');
    }
    return body;
  } catch (err) {
    rethrow;
  }
}

Future<Payment> validateAddPaymentBody(
  String payload,
) async {
  try {
    if (payload == null) throw Exception('payload');
    Payment body = Payment.fromJson(payload);
    if (body.propertyId?.isNaN ?? true) {
      throw Exception('proprty_id');
    } else if (body.amount?.isNaN ?? true) {
      throw Exception('amount');
    } else if (body.payer?.isEmpty ?? true) {
      throw Exception('payer');
    } else if (body.originatingBank?.isEmpty ?? true) {
      throw Exception('originating_bank');
    } else if (body.receivingBank?.isEmpty ?? true) {
      throw Exception('receiving_bank');
    } else if (body.tellerRefNo?.isEmpty ?? true) {
      throw Exception('teller_ref_no');
    } else if (body.evidence?.isEmpty ?? true) {
      throw Exception('evidence');
    } else if (body.datePaid?.toString()?.isEmpty ?? true) {
      throw Exception('date_paid');
    }
    return body;
  } catch (err) {
    rethrow;
  }
}

Future<Payment> validatePaymentRejectBody(
  String payload,
) async {
  try {
    if (payload == null) throw Exception('payload invalid');
    Payment body = Payment.fromJson(payload);
    return body;
  } catch (err) {
    rethrow;
  }
}
