import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'models/user.dart';
import 'user.service.dart';

class UserController {
  UserService _service = UserService();

  Router get router {
    final Router router = Router();
    router.post('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();

        User user =
            User.fromMap(jsonDecode(requestBody) as Map<String, dynamic>);
        User _user = await _service.create(user);
        return Response.ok(jsonEncode(_user.toJson()));
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.get('/', (Request request) async {
      try {
        int page = int.tryParse(request.url.queryParameters['page']);
        int size = int.tryParse(request.url.queryParameters['size']);
        List<User> users = await _service.findAllWithPagination(size, page);

        List<Map<String, dynamic>> usersJson =
            users.map((User v) => v.toMap()).toList();
        return Response.ok(jsonEncode(usersJson));
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.get('/<userId|[0-9]+>', (Request request, String userId) async {
      try {
        int _userId = int.tryParse(userId);
        User _user = await _service.findByID(_userId);
        return Response.ok(jsonEncode(_user.toJson()));
      } catch (e) {
        print(e);
        return Response.notFound('');
      }
    });
    router.put('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        User user =
            User.fromMap(jsonDecode(requestBody) as Map<String, dynamic>);
        User _user = await _service.update(user);
        return Response.ok(jsonEncode(_user.toJson()));
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.delete('/', (Request request) async {
      return Response.ok('delete');
    });
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));
    return router;
  }
}
