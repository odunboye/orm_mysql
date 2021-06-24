import 'models/consent.dart';

Future<Consent> validateUpdateConsentBody(
  String payload,
) async {
  try {
    if (payload == null) throw Exception('payload invalid');
    Consent body = Consent.fromJson(payload);
    if (body.id?.isNaN ?? true) {
      throw Exception('id not a number');
    } else if (body.propertyId?.isNaN ?? true) {
      throw Exception('proprtyId');
    } else if (body.newOwnerId?.isNaN ?? true) {
      throw Exception('New Owner');
    } else if (body.oldOwnerId?.isNaN ?? true) {
      throw Exception('Old Owner');
    }
    return body;
  } catch (err) {
    rethrow;
  }
}

Future<Consent> validateAddConsentBody(
  String payload,
) async {
  try {
    if (payload == null) throw Exception('payload');
    Consent body = Consent.fromJson(payload);
    if (body.id?.isNaN ?? true) {
      throw Exception('id not a number');
    } else if (body.propertyId?.isNaN ?? true) {
      throw Exception('proprtyId');
    } else if (body.newOwnerId?.isNaN ?? true) {
      throw Exception('New Owner');
    } else if (body.oldOwnerId?.isNaN ?? true) {
      throw Exception('Old Owner');
    }
    return body;
  } catch (err) {
    rethrow;
  }
}

Future<Consent> validateConsentRejectBody(
  String payload,
) async {
  try {
    if (payload == null) throw Exception('payload invalid');
    Consent body = Consent.fromJson(payload);
    return body;
  } catch (err) {
    rethrow;
  }
}
