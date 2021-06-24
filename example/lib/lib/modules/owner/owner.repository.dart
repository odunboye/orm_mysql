import 'package:database/sql.dart';
import 'package:orm/orm.dart';
import 'package:orm/util/sql.recase.dart';
import 'models/owner.dart';

class OwnerRepository extends Repository<Owner, int> {
  OwnerRepository({String dbUser, String dbPassword, String db})
      : super(dbUser: dbUser, dbPassword: dbPassword, db: db);

  Future<Map<String, dynamic>> filter(
      String name, int limit, int pageNumber) async {
    int _limit = limit;
    int _offset = (_limit * pageNumber) - _limit;
    String _firstNameFilter = name == null ? '' : "first_name like '%$name%'";
    String whereStr = name == null ? '' : 'where';
    final SqlStatement query = SqlStatement('''
        SELECT *, count(*) OVER() AS full_count FROM owner 
        $whereStr $_firstNameFilter 
        LIMIT $_limit OFFSET $_offset''', []);

    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }

    if (results.isEmpty) {
      return <String, dynamic>{'owners': <Owner>[], 'total': 0};
    }
    List<Owner> _owners = <Owner>[];

    results.forEach((Map<String, dynamic> element) {
      Owner _payment = Owner.fromMap(recaseMap(element, recaseKeyCamelCase));
      _owners.add(_payment);
    });

    Map<String, dynamic> totalElement = results.first;
    int total = totalElement['full_count'] as int;

    return <String, dynamic>{'owners': _owners, 'total': total};
  }
}
