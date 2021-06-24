import 'package:get_server/get_server.dart';
import 'package:oniru_server/modules/user/models/user.dart';

import 'user.repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository(
    dbUser: Get.find(tag: 'dbUser'),
    dbPassword: Get.find(tag: 'dbPassword'),
    db: Get.find(tag: 'db'),
  );

  Future<List<User>> findAll() async => await _userRepository.findAll();

  Future<List<User>> findAllWithPagination(int size, int pageNumber) async =>
      await _userRepository.findAllWithPagination(size, pageNumber);

  Future<User> findByID(int id) async => await _userRepository.findOne(id);

  Future<User> findByEmailPassword(String email, String password) async =>
      _userRepository.findByEmailPassword(email, password);

  Future<User> create(User user) async => await _userRepository.insert(user);

  Future<void> deleteUser(int id) async => await _userRepository.deleteOne(id);

  Future<User> update(User user) async {
    User userSave = await _userRepository.findOne(user.id);
    if (userSave == null) {
      throw Exception('No user found with id ${user.id}');
    }
    User newUser = user;

    //Do not allow changing id;
    newUser.id = userSave.id;
    newUser.dateAdded = userSave.dateAdded;

    //Update has null return for now
    _userRepository.update(user.id, newUser);

    return await findByID(newUser.id);
  }
}
