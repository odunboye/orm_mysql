import 'dart:mirrors';

import '../annotations/foreign.table.runner.dart';

abstract class FunctionsRepository {
  String getTableName(ClassMirror cm);
  String getColumnName(VariableMirror vm);
  String createTableFromObject(Type classe);
  String processColunm(VariableMirror vm);
  String getSqlType(String dartType);
  String getPrimaryKey(ClassMirror cm);
  List<ForeignTableInner> getForeignKeys(ClassMirror cm, Type T);
  void replaceBoolInt(ClassMirror cm, Map<String, dynamic> data);
  dynamic intToId(dynamic id);
}
