import 'package:get_server/get_server.dart';
import 'package:oniru_lib/oniru_lib.dart';
import 'package:oniru_server/modules/property/property.repository.dart';
import 'models/property.dart';

class PropertyService {
  final PropertyRepository _propertyRepository = PropertyRepository(
    dbUser: Get.find(tag: 'dbUser'),
    dbPassword: Get.find(tag: 'dbPassword'),
    db: Get.find(tag: 'db'),
  );

  Future<List<Property>> findAll() async => await _propertyRepository.findAll();

  Future<List<Property>> findAllWithPagination(
          int size, int pageNumber) async =>
      await _propertyRepository.findAllWithPagination(size, pageNumber);

  Future<Map<String, dynamic>> searchPaginatedPropertyDTO(
          {String ref,
          String ownerName,
          String plot,
          int limit,
          int pageNumber}) async =>
      _propertyRepository.searchPaginatedPropertyDTO(
          limit: limit,
          pageNumber: pageNumber,
          ref: ref,
          ownerName: ownerName,
          plot: plot);

  Future<Property> findByID(int id) async =>
      await _propertyRepository.findOne(id);

  Future<PropertyDTO> findByRefExact(String refNum) async =>
      await _propertyRepository.findByRefExact(refNum);

  Future<int> count() async => _propertyRepository.count();

  Future<List<PropertyDTO>> findPaginatedPropertyDTO(
          int limit, int pageNumber) async =>
      _propertyRepository.findPaginatedPropertyDTO(limit, pageNumber);

  Future<Property> create(Property PropertyModel) async =>
      await _propertyRepository.insert(PropertyModel);

  Future<void> delete(int id) async => await _propertyRepository.deleteOne(id);

  Future<Property> update(Property propertyModel) async {
    Property propertySave = await _propertyRepository.findOne(propertyModel.id);
    if (propertySave == null) {
      throw Exception('No Property found with id ${propertyModel.id}');
    }
    Property newPropertyModel = propertyModel;

    //Do not allow changing id;
    newPropertyModel.id = propertyModel.id;
    newPropertyModel.createdAt = propertyModel.createdAt;

    //Update has null return for now
    _propertyRepository.update(propertyModel.id, newPropertyModel);
    return await findByID(propertyModel.id);
  }
}
