import 'package:oniru_lib/oniru_lib.dart';
import 'package:oniru_server/modules/consent/models/consents.response.dart';
import 'package:oniru_server/shared/util/dateUtil.dart';
import 'package:oniru_server/shared/util/getToken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'consent.approver.dart';
import 'consent.validator.dart';
import 'models/consent.dart';
import 'consent.service.dart';

class ConsentController {
  ConsentService _consentService = ConsentService();
  //start approval chain
  SupervisorApprover supervisor = SupervisorApprover()
    ..successor = ManagerApprover();

  Router get router {
    final Router router = Router();
    router.post('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Consent consent = Consent.fromJson(requestBody);
        consent.initiatorId = getUserIdFromToken(request);
        consent.dateInitiated = dateTimeFormatter.format(DateTime.now());
        Consent _consent = await _consentService.create(consent);
        return Response.ok(_consent.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.get('/', (Request request) async {
      try {
        int page = int.tryParse(request.url.queryParameters['page']);
        int size = int.tryParse(request.url.queryParameters['size']);
        String category = request.url.queryParameters['category'];
        Map<String, dynamic> result =
            await _consentService.filter(category, size, page);
        int total = result['total'] as int;

        ConsentsResponse consentsResponse = ConsentsResponse();
        consentsResponse.size = size;
        consentsResponse.currentPage = page;
        consentsResponse.totalPages = (total / size).round();
        consentsResponse.totalElements = total;
        consentsResponse.content = result['consents'] as List<Consent>;

        return Response.ok(consentsResponse.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.get('/<consentId|[0-9]+>',
        (Request request, String consentId) async {
      try {
        int _consentId = int.tryParse(consentId);
        Consent _consent = await _consentService.findByID(_consentId);
        if (_consent == null) {
          throw Exception();
        }
        return Response.ok(_consent.toJson());
      } catch (e) {
        return Response.notFound('');
      }
    });
    router.put('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Consent consent = Consent.fromJson(requestBody);
        Consent _consent = await _consentService.update(consent);
        return Response.ok(_consent.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.delete('/', (Request request) async {
      return Response.ok('delete');
    });

    router.put('/<consentId|[0-9]+>/reject',
        (Request request, String consentId) async {
      try {
        String requestBody = await request.readAsString();
        int consentIdInt = int.tryParse(consentId);
        int userId = getUserIdFromToken(request);
        Consent incomingConsent = await validateConsentRejectBody(requestBody);
        Consent _consent = await _consentService.findByID(consentIdInt);
        _consent.rejectComment = incomingConsent.rejectComment;

        Consent treatedConsent = await supervisor.treatRequest(
            request: _consent, userId: userId, status: ConsentStatus.rejected);

        return Response.ok(treatedConsent.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.put('/<consentId|[0-9]+>/approve',
        (Request request, String consentId) async {
      int consentIdInt = int.tryParse(consentId);
      Consent incomingConsent = await _consentService.findByID(consentIdInt);
      int userId = getUserIdFromToken(request);

      Consent treatedConsent = await supervisor.treatRequest(
          request: incomingConsent,
          userId: userId,
          status: ConsentStatus.approved);
      return Response.ok(treatedConsent.toJson());
    });

    router.put('/<consentId|[0-9]+>/verify',
        (Request request, String consentId) async {
      try {
        int consentIdInt = int.tryParse(consentId);
        Consent incomingConsent = await _consentService.findByID(consentIdInt);
        int userId = getUserIdFromToken(request);

        Consent treatedConsent = await supervisor.treatRequest(
            request: incomingConsent,
            userId: userId,
            status: ConsentStatus.verified);

        return Response.ok(treatedConsent.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }
}
