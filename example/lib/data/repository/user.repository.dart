import 'package:database/database.dart';
import 'package:database/database_adapter.dart';
import 'package:example/data/models/user.model.dart';
import 'package:orm/orm.dart';

class UserRepository extends Repository<User, int> {
  UserRepository(
      DatabaseAdapter databaseAdapter, FunctionsRepository functionsRepository)
      : super();
}
