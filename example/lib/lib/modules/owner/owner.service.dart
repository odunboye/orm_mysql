import 'package:get_server/get_server.dart';
import 'package:oniru_server/modules/owner/models/owner.dart';

import 'owner.repository.dart';

class OwnerService {
  final OwnerRepository _ownerRepository = OwnerRepository(
    dbUser: Get.find(tag: 'dbUser'),
    dbPassword: Get.find(tag: 'dbPassword'),
    db: Get.find(tag: 'db'),
  );

  Future<List<Owner>> findAll() async => await _ownerRepository.findAll();

  Future<List<Owner>> findAllWithPagination(
          String searchString, int size, int pageNumber) async =>
      await _ownerRepository.findAllWithPagination(size, pageNumber);

  Future<Map<String, dynamic>> filter(
          String searchString, int size, int pageNumber) async =>
      await _ownerRepository.filter(searchString, size, pageNumber);

  Future<Owner> findByID(int id) async => await _ownerRepository.findOne(id);

  Future<Owner> createOwner(Owner owner) async =>
      await _ownerRepository.insert(owner);

  Future<void> deleteUser(int id) async => await _ownerRepository.deleteOne(id);

  Future<Owner> updateOwner(Owner owner) async {
    Owner ownerSave = await _ownerRepository.findOne(owner.id);
    if (ownerSave == null) {
      throw Exception('No owner found with id ${owner.id}');
    }
    Owner newOwner = owner;

    //Do not allow changing id;
    newOwner.id = owner.id;

    //Update has null return for now
    _ownerRepository.update(owner.id, newOwner);

    return await findByID(owner.id);
  }
}
