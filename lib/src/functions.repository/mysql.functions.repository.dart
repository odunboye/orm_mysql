import 'dart:mirrors';

import 'package:orm/src/annotations/foreign.table.runner.dart';
import 'package:orm/src/functions.repository/functions.repository.dart';
import 'package:recase/recase.dart';

import '../../orm.dart';

class MySqlFunctionsRepository implements FunctionsRepository {
  @override
  String getTableName(ClassMirror cm) {
    String tablename = '';
    cm.metadata.forEach((meta) {
      if (meta.reflectee is Table) {
        String name = meta.reflectee.name;
        if (name.isEmpty) {
          tablename = MirrorSystem.getName(cm.simpleName);
        } else {
          tablename = meta.reflectee.name;
        }
        // tablename = meta.reflectee.name ?? MirrorSystem.getName(cm.simpleName);
      }
    });
    return ReCase(tablename).snakeCase;
  }

  @override
  String getColumnName(VariableMirror vm) {
    //print(vm.metadata);
    String columnName = MirrorSystem.getName(vm.simpleName);
    /* vm.metadata.forEach((meta) {
    if (meta.reflectee is Column) {
      columnName = meta.reflectee.name ?? MirrorSystem.getName(vm.simpleName);
    }
  });
 */

    //mudando para contar _ para duas palvras no sql
    return ReCase(columnName).snakeCase;
  }

  @override
  String createTableFromObject(Type classe) {
    String query = '';
    ClassMirror cm = reflectClass(classe);
    String? tablename = getTableName(cm);
    getPrimaryKey(cm);

    //TODO : livrar coluna com ForeignTable
    cm.metadata.forEach((meta) {
      if (meta.reflectee is Table) {
        query += 'CREATE TABLE IF NOT EXISTS $tablename (';
        cm.declarations.forEach((key, value) {
          if (!value.isPrivate) {
            if (!(value is MethodMirror)) {
              VariableMirror vm = cm.declarations[key] as VariableMirror;
              final columnTable = processColunm(vm);
              if (columnTable.isNotEmpty) {
                if (query.endsWith('(')) {
                  query += '\n ${columnTable}';
                } else {
                  query += ',\n ${columnTable}';
                }
              }
            }
          }
        });

        query += '\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
      }
    });
    return query;
  }

//TODO : adicionado FOREIGN

  @override
  String processColunm(VariableMirror vm) {
    String column = getColumnName(vm);
    column += ' ';
    column += getSqlType(vm.type.reflectedType.toString());
    vm.metadata.forEach((meta) {
      if (meta.reflectee is ForeignTable) {
        column = '';
      } else if (meta.reflectee is Id) {
        column += ' PRIMARY KEY AUTO_INCREMENT NOT NULL';
      } else if (meta.reflectee is ForeignId) {
        column += ' FOREIGN KEY REFERENCES';
      } else if (meta.reflectee is NotNull) {
        column += ' NOT NULL';
      }
      ;
    });

    return column;
  }

  @override
  String getSqlType(String dartType) {
    if (dartType == 'String') {
      return 'VARCHAR(255)';
    } else if (dartType == 'int') {
      return 'INT';
    } else if (dartType == 'bool') {
      return 'BOOLEAN';
    } else {
      return dartType;
    }
  }

  @override
  String getPrimaryKey(ClassMirror cm) {
    String primarykey = '';
    int primarykeys = 0;

    cm.metadata.forEach((meta) {
      if (meta.reflectee is Table) {
        cm.declarations.forEach((key, value) {
          if (!value.isPrivate) {
            if (!(value is MethodMirror)) {
              VariableMirror vm = cm.declarations[key] as VariableMirror;
              vm.metadata.forEach((meta) {
                if (meta.reflectee is Id) {
                  primarykey = getColumnName(vm);
                  primarykeys++;
                }
              });
            }
          }
        });
      }
    });
    if (primarykeys > 1) {
      throw Exception('More than one @id was entered in the ${cm.location} ');
    }

    return primarykey;
  }

//TODO : pegando ForeignId das classes ForeignTable
  @override
  List<ForeignTableInner> getForeignKeys(ClassMirror cm, Type T) {
    var foreignkey = <ForeignTableInner>[];
    cm.metadata.forEach((meta) {
      if (meta.reflectee is Table) {
        cm.declarations.forEach((key, value) {
          if (!value.isPrivate) {
            if (!(value is MethodMirror)) {
              VariableMirror vm = cm.declarations[key] as VariableMirror;

              vm.metadata.forEach((meta) {
                if (meta.reflectee is ForeignTable) {
                  ClassMirror cmInner = reflectClass(vm.type.reflectedType);
                  //print('LIVRO NAMe ---' +
                  //MirrorSystem.getName(cmInner.simpleName));

                  cmInner.metadata.forEach((metaInner) {
                    if (metaInner.reflectee is Table) {
                      //print('LIVRO is TABLE ---');
                      cmInner.declarations.forEach((key, value) {
                        if (!value.isPrivate) {
                          if (!(value is MethodMirror)) {
                            //foreignkey.add(_getColumnName(vm));
                            VariableMirror vmInner =
                                cmInner.declarations[key] as VariableMirror;
                            var tablename = getTableName(cmInner);
                            vmInner.metadata.forEach((metadata) {
                              if (metadata.reflectee is ForeignId) {
                                // print('LIVRO NAMe ---' +
                                // MirrorSystem.getName(vmInner.simpleName));
                                foreignkey.add(ForeignTableInner(
                                    name: tablename,
                                    foreignId: getColumnName(vmInner)));
                              }
                            });
                          }
                        }
                      });
                    }
                  });
                }
              });
            }
          }
        });
      }
    });

    if (foreignkey.isEmpty) {
      throw Exception('Annotations @ForeignId not found in ${cm.location} ');
    }

    return foreignkey;
  }

  @override
  void replaceBoolInt(ClassMirror cm, Map<String, dynamic> data) {
    cm.declarations.forEach((key, value) {
      if (!value.isPrivate) {
        if (value is VariableMirror) {
          if (value.type.reflectedType.toString() == 'bool') {
            String columnBool = ReCase(getColumnName(value)).snakeCase;
            if (data.containsKey(columnBool)) {
              data.update(columnBool, (value) {
                if (value != null) return value == 1;
                print(value);
                return null;
              });
            }
          }
        }
      }
    });
  }

// temp
  @override
  dynamic intToId(dynamic id) {
    return id;
  }
}
