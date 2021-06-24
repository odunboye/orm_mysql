import 'package:database/database.dart';
import 'package:database/sql.dart';
import 'package:database_adapter_mysql/database_adapter_mysql.dart';
import 'package:orm/orm.dart';
import 'package:orm/util/sql.recase.dart';
import 'models/consent.dart';

class ConsentRepository extends Repository<Consent, int> {
  ConsentRepository({String dbUser, String dbPassword, String db})
      : super(dbUser: dbUser, dbPassword: dbPassword, db: db);

  Database newDB() {
    return Database.withAdapter(MysqlAdapter(
      user: dbUser,
      password: dbPassword,
      databaseName: db,
    ));
  }

  Future<Map<String, dynamic>> filter(
      String category, int limit, int pageNumber) async {
    int _limit = limit;
    int _offset = (_limit * pageNumber) - _limit;

    String _filterStr = category == null || category.toLowerCase() == 'all'
        ? ''
        : "status = 'ConsentStatus.$category'";
    String whereStr =
        category == null || category.toLowerCase() == 'all' ? '' : 'where';

    final SqlStatement query = SqlStatement(
        '''select * , count(*) OVER() AS full_count from consent 
               $whereStr $_filterStr limit ? offset ?''',
        <String>[_limit.toString(), _offset.toString()]);

    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    List<Consent> _consents = <Consent>[];
    if (results.isEmpty) {
      // throw Exception();
      return <String, dynamic>{
        'consents': _consents,
        'total': _consents.length
      };
    }
    results.forEach((Map<String, dynamic> element) {
      Consent _consent =
          Consent.fromMap(recaseMap(element, recaseKeyCamelCase));
      _consents.add(_consent);
    });
    Map<String, dynamic> totalElement = results.first;
    int total = totalElement['full_count'] as int;

    return <String, dynamic>{'consents': _consents, 'total': total};
  }
}
