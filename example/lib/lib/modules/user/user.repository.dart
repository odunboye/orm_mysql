import 'package:database/sql.dart';
import 'package:orm/orm.dart';
import 'package:orm/util/sql.recase.dart';
import 'models/user.dart';

class UserRepository extends Repository<User, int> {
  UserRepository({String dbUser, String dbPassword, String db})
      : super(dbUser: dbUser, dbPassword: dbPassword, db: db);

  Future<User> findByEmailPassword(String email, String password) async {
    final SqlStatement query = SqlStatement(
        'SELECT * FROM user WHERE email=? AND password=?',
        <String>[email, password]);
    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }
    Map<String, dynamic> userMapRecased =
        recaseMap(results.first, recaseKeyCamelCase);
    User _user = User.fromMap(userMapRecased);
    return _user;
  }
}
