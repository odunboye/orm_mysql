import 'package:oniru_server/modules/owner/models/owners.response.dart';
import 'package:oniru_server/modules/owner/owner.service.dart';
import 'package:oniru_server/shared/util/dateUtil.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'models/owner.dart';

class OwnerController {
  OwnerService _ownerService = OwnerService();
  Router get router {
    final Router router = Router();
    router.post('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Owner owner = Owner.fromJson2(requestBody);
        owner.createdAt = dateTimeFormatter.format(DateTime.now());
        Owner _owner = await _ownerService.createOwner(owner);
        return Response.ok(_owner.toJson2());
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.get('/', (Request request) async {
      try {
        String searchString = request.url.queryParameters['name'];
        int page = int.tryParse(request.url.queryParameters['page']);
        int size = int.tryParse(request.url.queryParameters['size']);

        var result = await _ownerService.filter(searchString, size, page);
        int total = result['total'] as int;

        int _totalPages = total == 0 ? 0 : (total / size).round();

        OwnersResponse ownersResponse = OwnersResponse();
        ownersResponse.size = size;
        ownersResponse.currentPage = page;
        ownersResponse.totalPages = _totalPages;
        ownersResponse.totalElements = total;
        ownersResponse.content = result['owners'] as List<Owner>;
        return Response.ok(ownersResponse.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });
    router.get('/<ownerId|[0-9]+>', (Request request, String ownerId) async {
      try {
        int _ownerId = int.tryParse(ownerId);
        Owner _owner = await _ownerService.findByID(_ownerId);
        return Response.ok(_owner.toJson2());
      } catch (e) {
        print(e);
        return Response.notFound('');
      }
    });
    router.put('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Owner owner = Owner.fromJson2(requestBody);
        Owner _owner = await _ownerService.updateOwner(owner);
        return Response.ok(_owner.toJson2());
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
