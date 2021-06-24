// TODO:Add allowable role to approver
import 'package:oniru_lib/oniru_lib.dart';
import 'package:oniru_server/shared/util/dateUtil.dart';

import 'models/consent.dart';
import 'consent.service.dart';

abstract class Approver {
  Approver();
  Approver _successor;
  void set successor(Approver successor) {
    _successor = successor;
  }

  Future<Consent> treatRequest(
      {Consent request, int userId, ConsentStatus status});
}

class SupervisorApprover extends Approver {
  SupervisorApprover();
  ConsentService _consentService = ConsentService();
  final ConsentStatus _allowable = ConsentStatus.initial;
  final List<ConsentStatus> _updateStatus = <ConsentStatus>[
    ConsentStatus.verified,
    ConsentStatus.rejected
  ];

  Future<Consent> treatRequest(
      {Consent request, int userId, ConsentStatus status}) async {
    if (userId == request.initiatorId || userId == request.verifierId) {
      throw Exception('User $userId already part of approval chain');
    }
    if (request.status == _allowable.toString()) {
      if (!_updateStatus.contains(status))
        throw Exception('Status cannot be null');
      if (status == ConsentStatus.rejected) {
        if (request.rejectComment.isEmpty) {
          throw Exception('rejectComment cannot be null');
        }
      }
      request
        ..status = status.toString()
        ..verifierId = userId
        ..dateVerified = dateformatter.format(DateTime.now());
      try {
        Consent _consent = await _consentService.update(request);
        return _consent;
      } catch (e) {
        rethrow;
      }
    } else if (_successor != null) {
      try {
        return _successor.treatRequest(
            request: request, userId: userId, status: status);
      } catch (e) {
        rethrow;
      }
    }
    return null;
  }
}

class ManagerApprover extends Approver {
  ManagerApprover();
  ConsentService _consentService = ConsentService();

  final ConsentStatus _allowable = ConsentStatus.verified;
  final List<ConsentStatus> _updateStatus = <ConsentStatus>[
    ConsentStatus.approved,
    ConsentStatus.rejected
  ];

  Future<Consent> treatRequest(
      {Consent request, int userId, ConsentStatus status}) async {
    if (userId == request.initiatorId || userId == request.verifierId) {
      throw Exception('User $userId already part of approval chain');
    }
    try {
      if (request.status == _allowable.toString()) {
        if (!_updateStatus.contains(status))
          throw Exception('Status cannot be null');
        if (status == ConsentStatus.rejected) {
          if (request.rejectComment.isEmpty) {
            throw Exception('rejectComment cannot be null');
          }
        }
        request
          ..status = status.toString()
          ..approverId = userId
          ..dateApproved = dateTimeFormatter.format(DateTime.now());

        Consent _consent = await _consentService.update(request);
        return _consent;
      } else {
        throw Exception('Request treatment not allowed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
