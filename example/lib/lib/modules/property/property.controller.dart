import 'dart:convert';

import 'package:oniru_lib/dto/property.dto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'models/properties.response.dart';
import 'models/property.dart';
import 'property.service.dart';

class PropertyController {
  PropertyService _propertyService = PropertyService();

  Router get router {
    final Router router = Router();

    router.post('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();

        Property property = Property.fromJson(requestBody);
        Property _property = await _propertyService.create(property);
        return Response.ok(_property.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.get('/', (Request request) async {
      try {
        int page = int.tryParse(request.url.queryParameters['page']);
        int size = int.tryParse(request.url.queryParameters['size']);

        String refNum = request.url.queryParameters['ref'];
        String ownerName = request.url.queryParameters['owner'];
        String plot = request.url.queryParameters['plot'];

        var result = await _propertyService.searchPaginatedPropertyDTO(
          limit: size,
          pageNumber: page,
          ref: refNum,
          ownerName: ownerName,
          plot: plot,
        );
        int total = result['total'] as int;

        PropertiesResponse propertiesResponse = PropertiesResponse();
        propertiesResponse.size = size;
        propertiesResponse.currentPage = page;
        propertiesResponse.totalPages = (total / size).ceil();
        propertiesResponse.totalElements = total;
        propertiesResponse.content = result['properties'] as List<PropertyDTO>;

        return Response.ok(propertiesResponse.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.get('/<propertyId|[0-9]+>',
        (Request request, String propertyId) async {
      try {
        int _propertyId = int.tryParse(propertyId);
        Property _property = await _propertyService.findByID(_propertyId);
        return Response.ok(_property.toJson());
      } catch (e) {
        print(e);
        return Response.notFound('');
      }
    });

    router.get('/ref', (Request request) async {
      try {
        String refNum = request.url.queryParameters['ref'];
        PropertyDTO _propertyDTO =
            await _propertyService.findByRefExact(refNum);
        return Response.ok(jsonEncode(_propertyDTO.toJson()));
      } catch (e) {
        print(e);
        return Response.notFound('');
      }
    });

    router.put('/', (Request request) async {
      try {
        String requestBody = await request.readAsString();
        Property property = Property.fromJson(requestBody);
        Property _property = await _propertyService.update(property);
        return Response.ok(_property.toJson());
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.delete('/', (Request request) async {
      return Response.ok('delete');
    });

    router.get('/owners', (Request request) async {
      try {
        int page = int.tryParse(request.url.queryParameters['page']);
        int size = int.tryParse(request.url.queryParameters['size']);
        int total = await _propertyService.count();
        List<PropertyDTO> properties =
            await _propertyService.findPaginatedPropertyDTO(size, page);
        PropertiesResponse propertiesResponse = PropertiesResponse();
        propertiesResponse.size = size;
        propertiesResponse.currentPage = page;
        propertiesResponse.totalPages = (total / size).round();
        propertiesResponse.totalElements = total;
        propertiesResponse.content = properties;

        Map<String, dynamic> responseJson = propertiesResponse.toMap();

        return Response.ok(jsonEncode(responseJson));
      } catch (e) {
        return Response.internalServerError();
      }
    });

    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));
    return router;
  }
}
