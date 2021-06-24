import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'modules/consent/consent.controller.dart';
import 'modules/owner/owner.controller.dart';
import 'modules/property/property.controller.dart';
import 'modules/user/user.controller.dart';
import 'modules/payment/payment.controller.dart';

class Api {
  Handler get handler {
    final Router router = Router();

    router.mount('/owners/', OwnerController().router);
    router.mount('/properties/', PropertyController().router);
    router.mount('/consents/', ConsentController().router);
    router.mount('/payments/', PaymentController().router);
    router.mount('/users/', UserController().router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}
