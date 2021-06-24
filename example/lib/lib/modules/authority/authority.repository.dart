import 'package:database/sql.dart';
import 'package:orm/orm.dart';
import 'models/authority.dart';

class AuthorityRepository extends Repository<Authority, int> {
  AuthorityRepository({String dbUser, String dbPassword, String db})
      : super(dbUser: dbUser, dbPassword: dbPassword, db: db);

  Future<List<Authority>> findAllByUserId(int userId) async {
    final SqlStatement query =
        SqlStatement('''SELECT a.id, a.name, a.description
      FROM user u
      INNER JOIN user_authority ua ON u.id = ua.user_id
      INNER JOIN authority a ON ua.authority_id  = a.id 
      WHERE u.id=?''', <String>[userId.toString()]);
    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }
    List<Authority> _authorities = [];
    results.forEach((Map<String, dynamic> element) {
      Authority _authority = Authority.fromJson(recaseMap(element));
      _authorities.add(_authority);
    });

    return _authorities;
  }
}
