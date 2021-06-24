import 'package:orm/orm.dart';
import 'models/payment.dart';
import 'package:database/sql.dart';
import 'package:orm/util/sql.recase.dart';

class PaymentRepository extends Repository<Payment, int> {
  PaymentRepository({String dbUser, String dbPassword, String db})
      : super(dbUser: dbUser, dbPassword: dbPassword, db: db);

  Future<Map<String, dynamic>> filter(
      String category, int limit, int pageNumber) async {
    int _limit = limit;
    int _offset = (_limit * pageNumber) - _limit;

    String _filterStr = category == null || category.toLowerCase() == 'all'
        ? ''
        : "status = 'PaymentStatus.${category.toLowerCase()}'";
    String whereStr =
        category == null || category.toLowerCase() == 'all' ? '' : 'where';

    final SqlStatement query = SqlStatement(
        '''select * , count(*) OVER() AS full_count from payment $whereStr $_filterStr limit ? offset ?''',
        <String>[_limit.toString(), _offset.toString()]);

    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      return <String, dynamic>{'payments': <Payment>[], 'total': 0};
    }
    List<Payment> _payments = <Payment>[];

    results.forEach((Map<String, dynamic> element) {
      Payment _payment =
          Payment.fromMap(recaseMap(element, recaseKeyCamelCase));
      _payments.add(_payment);
    });

    Map<String, dynamic> totalElement = results.first;
    int total = totalElement['full_count'] as int;

    return <String, dynamic>{'payments': _payments, 'total': total};
  }
}
