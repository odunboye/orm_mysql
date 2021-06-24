// TODO:Add allowable role to approver
import 'package:oniru_lib/oniru_lib.dart';
import 'package:oniru_server/shared/util/dateUtil.dart';

import 'models/payment.dart';
import 'payment.service.dart';

abstract class Approver {
  Approver();
  Approver _successor;
  void set successor(Approver successor) {
    _successor = successor;
  }

  Future<Payment> treatRequest(
      {Payment request, int userId, PaymentStatus status});
}

class SupervisorApprover extends Approver {
  SupervisorApprover();
  PaymentService _paymentService = PaymentService();
  final PaymentStatus _allowable = PaymentStatus.initial;
  final List<PaymentStatus> _updateStatus = <PaymentStatus>[
    PaymentStatus.verified,
    PaymentStatus.rejected
  ];

  Future<Payment> treatRequest(
      {Payment request, int userId, PaymentStatus status}) async {
    if (request.status == _allowable.toString()) {
      if (!_updateStatus.contains(status))
        throw Exception('Status cannot be null');
      if (status == PaymentStatus.rejected) {
        if (request.rejectComment.isEmpty) {
          throw Exception('rejectComment cannot be null');
        }
        request.datePaid =
            dateTimeFormatter.format(DateTime.parse(request.datePaid));
        request.dateInitiated =
            dateTimeFormatter.format(DateTime.parse(request.dateInitiated));
      }
      request
        ..status = status.toString()
        ..verifierId = userId
        ..dateVerified = dateTimeFormatter.format(DateTime.now());
      try {
        Payment _payment = await _paymentService.update(request);
        return _payment;
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
  PaymentService _paymentService = PaymentService();

  final PaymentStatus _allowable = PaymentStatus.verified;
  final List<PaymentStatus> _updateStatus = <PaymentStatus>[
    PaymentStatus.approved,
    PaymentStatus.rejected
  ];

  Future<Payment> treatRequest(
      {Payment request, int userId, PaymentStatus status}) async {
    try {
      if (request.status == _allowable.toString()) {
        if (!_updateStatus.contains(status))
          throw Exception('Status cannot be null');
        if (status == PaymentStatus.rejected) {
          if (request.rejectComment.isEmpty) {
            throw Exception('rejectComment cannot be null');
          }
          request.datePaid =
              dateTimeFormatter.format(DateTime.parse(request.datePaid));
          request.dateInitiated =
              dateTimeFormatter.format(DateTime.parse(request.dateInitiated));
          request.dateVerified =
              dateTimeFormatter.format(DateTime.parse(request.dateVerified));
        }
        request
          ..status = status.toString()
          ..approverId = userId
          ..dateApproved = dateTimeFormatter.format(DateTime.now());

        Payment _payment = await _paymentService.update(request);
        return _payment;
      } else {
        throw Exception('Request treatment not allowed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
