import 'dart:mirrors';

import 'package:database/database.dart';
import 'package:database/database_adapter.dart';
import 'package:database_adapter_mysql/database_adapter_mysql.dart';
import 'package:orm/src/functions.repository/mysql.functions.repository.dart';
import 'package:orm/util/sql.recase.dart';

import '../functions.repository/functions.repository.dart';

// Example: UserRepository extends Repository<User, int>
// Note: First parameter is the class model, and the second is the type of id
abstract class Repository<T, S> {
  final FunctionsRepository functionsRepository = MySqlFunctionsRepository();
  final String dbUser;
  final String dbPassword;
  final String db;

  Repository(
      {this.dbUser = 'root', this.dbPassword = '1234', this.db = 'testDB'}) {
    var _db = newDB();
    _db.sqlClient.execute(functionsRepository.createTableFromObject(T));
    _db.sqlClient.close();
  }

  Database newDB() {
    return Database.withAdapter(MysqlAdapter(
      user: dbUser,
      password: dbPassword,
      databaseName: db,
    ));
  }

  Future<List<T>> findAll() async {
    ClassMirror classMirror = reflectClass(T);
    String? tablename = functionsRepository.getTableName(classMirror);
    var _dbClient = newDB().sqlClient;
    var data = await _dbClient
        .query('SELECT * FROM $tablename')
        .toMaps()
        .then((value) => _dbClient.close());
    List<T> result = <T>[];
    data.forEach((element) {
      functionsRepository.replaceBoolInt(classMirror, element);
      InstanceMirror res = classMirror
          .newInstance(#fromJson, [recaseMap(element, recaseKeyCamelCase)]);
      result.add(res.reflectee);
    });

    return result;
  }

  Future<List<T>> findAllWithPagination(int limit, int pageNumber) async {
    if (limit.isNegative || pageNumber.isNegative) {
      throw FormatException();
    }

    int _limit = limit;
    int _offset = (_limit * pageNumber) - _limit;
    ClassMirror classMirror = reflectClass(T);
    String? tablename = functionsRepository.getTableName(classMirror);
    var _dbClient = newDB().sqlClient;

    var data = await _dbClient
        .query('SELECT * FROM $tablename LIMIT $_limit OFFSET $_offset')
        .toMaps();

    await _dbClient.close();

    List<T> result = <T>[];
    data.forEach((element) {
      functionsRepository.replaceBoolInt(classMirror, element);
      InstanceMirror res = classMirror
          .newInstance(#fromMap, [recaseMap(element, recaseKeyCamelCase)]);
      result.add(res.reflectee);
    });

    return result;
  }

  Future<T?> findOne(S value) async {
    ClassMirror cm = reflectClass(T);
    String? tablename = functionsRepository.getTableName(cm);
    String primaryKey = functionsRepository.getPrimaryKey(cm);
    List values = [value];
    var _dbClient = newDB().sqlClient;
    var data = await _dbClient
        .query('SELECT * FROM $tablename WHERE $primaryKey = ?', values)
        .toMaps();

    await _dbClient.close();

    if (data.isNotEmpty) {
      functionsRepository.replaceBoolInt(cm, data.single);
      InstanceMirror res = cm
          .newInstance(#fromMap, [recaseMap(data.single, recaseKeyCamelCase)]);
      return res.reflectee;
    }
    return null;
  }

  // TODO: know if delete was done via exception
  // wrap in try
  Future<void> deleteOne(S value) async {
    ClassMirror cm = reflectClass(T);
    String? tablename = functionsRepository.getTableName(cm);
    String primaryKey = functionsRepository.getPrimaryKey(cm);
    List values = [value];
    // var valueMap = {'Values': values};
    var _dbClient = newDB().sqlClient;

    await _dbClient.execute(
        'DELETE FROM $tablename WHERE $primaryKey = ?', values);
    await _dbClient.close();
  }

  Future<T?> insert(T value) async {
    InstanceMirror res = reflect(value);
    ClassMirror cm = reflectClass(T);
    String? tablename = functionsRepository.getTableName(cm);
    Map<String, dynamic> map =
        recaseMap(res.invoke(#toMap, []).reflectee, recaseKeySnakeCase);
    List<String> keys = map.keys.toList();
    map.forEach((key, value) {
      if (value == null) keys.remove(key);
    });
    List<dynamic> values = [];
    List varString = [];

    map.values.forEach((v) {
      if (v != null) {
        varString.add('?');
        values.add(v);
      }
    });
    /* cm.declarations.forEach((key, value) {
      if (!value.isPrivate) {
        if (!(value is MethodMirror)) {
          InstanceMirror vm = res.getField(key);
          print(vm.reflectee);
          if (vm.reflectee is String) {
            if (values.isEmpty) {
              values += '\"${vm.reflectee}\"';
            }
          } else {
            values += '\"${vm.reflectee}\"';
          }
        }
      }
    }); */

    var _dbClient = newDB().sqlClient;
    await _dbClient.execute(
        'INSERT INTO `$tablename`(${keys.join(",")}) VALUES (${varString.join(",")})',
        values);
    var lastInertIdRes =
        await _dbClient.query('SELECT LAST_INSERT_ID();').toRows();
    await _dbClient.close();
    return findOne(functionsRepository.intToId(lastInertIdRes.first[0]));
  }

  void update(S id, T objet, {bool withNull = true}) async {
    ClassMirror cm = reflectClass(T);
    String? tablename = functionsRepository.getTableName(cm);
    String primaryKey = functionsRepository.getPrimaryKey(cm);
    InstanceMirror res = reflect(objet);
    Map<String, dynamic> map =
        recaseMap(res.invoke(#toMap, []).reflectee, recaseKeySnakeCase);
    List<String> query = [];
    map.forEach((key, value) {
      if (value is String) {
        query.add('$key = "$value"');
      } else {
        // Achei que não aceitar valores null faz parte da regra de negocio
        if (withNull) {
          query.add('$key = $value');
        } else if (value != null) {
          query.add('$key = $value');
        }
      }
    });
    List values = [id];
    var _dbClient = newDB().sqlClient;
    await _dbClient.execute(
        'UPDATE `$tablename` SET ${query.join(',')} WHERE $primaryKey = ?',
        values);

    await _dbClient.close();
  }

  Map<String, dynamic> recaseMap(Map<String, dynamic> map,
      [recaseKey = recaseKeyNone]) {
    if (recaseKey == recaseKeyNone) {
      return map;
    }
    Map<String, dynamic> result = Map();
    map.forEach((k, v) {
      result[recaseKey(k)] = v;
    });
    return result;
  }
}
