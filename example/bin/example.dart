import 'package:database/database.dart';
import 'package:database_adapter_mysql/database_adapter_mysql.dart';
import 'package:example/data/models/user.model.dart';
import 'package:example/services/user.service.dart';
import 'package:get_server/get_server.dart';
import 'package:orm/orm.dart';

void main(List<String> arguments) async {
  Get.put<Database>(MysqlAdapter(
    user: 'root',
    password: '1234',
    databaseName: 'testdb',
  ).database());
  Get.put<FunctionsRepository>(MySqlFunctionsRepository());

  var userService = UserService();
  // var user = User(
  //     name: 'Odun Ade', age: 35, email: 'odinboye@gmail.com', isActive: true);
  // // var res = await userService.createUser(user.toJson());
  // print(res);
  var user = await userService.findByID(1);
  user!.age = 24;
  // print(user!.age.toString());
  // print(user.email);

  // var users = await userService.findAll();
  // await userService.deleteUser(5);
  var newUser = await userService.updateUser(user.id!, user.toJson());
  print(newUser!.toJson());
  print('end');
}
