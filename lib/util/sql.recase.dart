library sql_recase;

import 'package:recase/recase.dart';

/// identity function used for maintain consistency
String recaseKeyNone(String k) => k;

/// recase string [k] to camelCase
String recaseKeyCamelCase(String k) => ReCase(k).camelCase;

/// recase string [k] to snake_case
String recaseKeySnakeCase(String k) => ReCase(k).snakeCase;

/// recase all [map] keys according to [recaseKey] function
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
