import 'package:get_server/get_server.dart';

import 'models/authority.dart';
import 'authority.repository.dart';

class AuthorityService {
  final AuthorityRepository _authorityRepository = AuthorityRepository(
    dbUser: Get.find(tag: 'dbUser'),
    dbPassword: Get.find(tag: 'dbPassword'),
    db: Get.find(tag: 'db'),
  );

  Future<List<Authority>> findAll() async =>
      await _authorityRepository.findAll();

  Future<List<Authority>> findAllByUserId(int userId) async =>
      await _authorityRepository.findAllByUserId(userId);

  Future<List<Authority>> findAllWithPagination(
          int size, int pageNumber) async =>
      await _authorityRepository.findAllWithPagination(size, pageNumber);

  Future<Authority> findByID(int id) async =>
      await _authorityRepository.findOne(id);

  Future<Authority> create(Authority authority) async =>
      await _authorityRepository.insert(authority);

  Future<void> deleteUser(int id) async =>
      await _authorityRepository.deleteOne(id);

  Future<Authority> update(Authority authority) async {
    Authority authoritySave = await _authorityRepository.findOne(authority.id);
    if (authoritySave == null) {
      throw Exception('No Authority found with id ${authority.id}');
    }
    Authority newAuthority = authority;

    //Do not allow changing id;
    newAuthority.id = authoritySave.id;

    //Update has null return for now
    _authorityRepository.update(authoritySave.id, newAuthority);

    return await findByID(authoritySave.id);
  }
}
