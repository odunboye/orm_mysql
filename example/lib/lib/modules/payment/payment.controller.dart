import 'package:oniru_lib/oniru_lib.dart';
import 'package:oniru_server/modules/payment/models/payments.response.dart';
import 'package:oniru_server/modules/payment/payment_approvers.dart';
import 'package:oniru_server/shared/util/dateUtil.dart';
import 'package:oniru_server/shared/util/getToken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'models/payment.dart';
import 'payment.service.dart';
import 'payment.validators.dart';

class PaymentController {
  PaymentService _paymentService = PaymentService();

  //start approval chain
  SupervisorApprover supervisor = SupervisorApprover()
    ..successor = ManagerApprover();

  Router get router {
    final Router router = Router();
    router.post('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Payment payment = await validateAddPaymentBody(requestBody);
        payment.initiatorId = getUserIdFromToken(request);
        payment.dateInitiated = dateTimeFormatter.format(DateTime.now());
        payment.dateVerified = null;
        payment.dateApproved = null;
        payment.status = PaymentStatus.initial.toString();
        Payment _payment = await _paymentService.create(payment);
        return Response.ok(_payment.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.get('/', (Request request) async {
      try {
        int page = int.tryParse(request.url.queryParameters['page']);
        int size = int.tryParse(request.url.queryParameters['size']);
        String category = request.url.queryParameters['category'];
        if (category == null || category == 'null') {
          category = 'All';
        }

        var result = await _paymentService.filter(category, size, page);
        int total = result['total'] as int;

        int _totalPages = total == 0 ? 0 : (total / size).round();

        PaymentsResponse paymentsResponse = PaymentsResponse();
        paymentsResponse.size = size;
        paymentsResponse.currentPage = page;
        paymentsResponse.totalPages = _totalPages;
        paymentsResponse.totalElements = total;
        paymentsResponse.content = result['payments'] as List<Payment>;

        return Response.ok(paymentsResponse.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.get('/<paymentId|[0-9]+>',
        (Request request, String paymentId) async {
      try {
        int _paymentId = int.tryParse(paymentId);
        Payment _payment = await _paymentService.findByID(_paymentId);
        if (_payment == null) {
          throw Exception();
        }
        return Response.ok(_payment.toJson());
      } catch (e) {
        return Response.notFound('');
      }
    });

    router.put('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Payment payment = await validateUpdatePaymentBody(requestBody);
        payment.initiatorId = getUserIdFromToken(request);
        payment.dateInitiated = dateTimeFormatter.format(DateTime.now());
        payment.dateVerified = null;
        payment.dateApproved = null;
        payment.status = PaymentStatus.initial.toString();
        Payment _payment = await _paymentService.update(payment);
        return Response.ok(_payment.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.delete('/', (Request request) async {
      return Response.ok('delete');
    });

    router.put('/<paymentId|[0-9]+>/reject',
        (Request request, String paymentId) async {
      try {
        String requestBody = await request.readAsString();
        int paymentIdInt = int.tryParse(paymentId);
        int userId = getUserIdFromToken(request);
        Payment incomingPayment = await validatePaymentRejectBody(requestBody);
        Payment _payment = await _paymentService.findByID(paymentIdInt);
        _payment.datePaid =
            dateTimeFormatter.format(DateTime.parse(_payment.datePaid));
        _payment.rejectComment = incomingPayment.rejectComment;
        Payment treatedPayment = await supervisor.treatRequest(
            request: _payment, userId: userId, status: PaymentStatus.rejected);

        return Response.ok(treatedPayment.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.put('/<paymentId|[0-9]+>/approve',
        (Request request, String paymentId) async {
      int paymentIdInt = int.tryParse(paymentId);
      Payment incomingPayment = await _paymentService.findByID(paymentIdInt);
      int userId = getUserIdFromToken(request);
      incomingPayment.datePaid =
          dateTimeFormatter.format(DateTime.parse(incomingPayment.datePaid));
      incomingPayment.dateInitiated = dateTimeFormatter
          .format(DateTime.parse(incomingPayment.dateInitiated));
      incomingPayment.dateVerified = dateTimeFormatter
          .format(DateTime.parse(incomingPayment.dateVerified));
      Payment treatedPayment = await supervisor.treatRequest(
          request: incomingPayment,
          userId: userId,
          status: PaymentStatus.approved);
      return Response.ok(treatedPayment.toJson());
    });

    router.put('/<paymentId|[0-9]+>/verify',
        (Request request, String paymentId) async {
      try {
        int paymentIdInt = int.tryParse(paymentId);
        Payment incomingPayment = await _paymentService.findByID(paymentIdInt);
        int userId = getUserIdFromToken(request);
        incomingPayment.datePaid =
            dateTimeFormatter.format(DateTime.parse(incomingPayment.datePaid));
        incomingPayment.dateInitiated = dateTimeFormatter
            .format(DateTime.parse(incomingPayment.dateInitiated));
        Payment treatedPayment = await supervisor.treatRequest(
            request: incomingPayment,
            userId: userId,
            status: PaymentStatus.verified);

        return Response.ok(treatedPayment.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }
}
