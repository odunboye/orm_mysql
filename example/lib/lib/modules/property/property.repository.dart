import 'package:orm/orm.dart';
import 'models/property.dart';

import 'package:database/sql.dart';
import 'package:orm/util/sql.recase.dart';
import 'package:oniru_lib/oniru_lib.dart';

class PropertyRepository extends Repository<Property, int> {
  PropertyRepository({String dbUser, String dbPassword, String db})
      : super(dbUser: dbUser, dbPassword: dbPassword, db: db);

  Future<Map<String, dynamic>> searchPaginatedPropertyDTO(
      {String ref,
      String ownerName,
      String plot,
      int limit,
      int pageNumber}) async {
    int _limit = limit;
    int _offset = (_limit * pageNumber) - _limit;
    String refNumFilter = ref == null ? '' : "p.ref_num = '$ref'";
    String ownerFilter =
        ownerName == null ? '' : "o.first_name like '%$ownerName%'";
    String plotFilter = plot == null ? '' : 'p.plot = $plot';

    String whereStr = 'where';
    if (ref == null && ownerName == null && plot == null) {
      whereStr = '';
    }

    final SqlStatement query = SqlStatement(
        '''select  p.id,p.ref_num, p.area, p.block, p.plot, t.name as type, 
            u.name as `usage`, o.first_name,
            o.last_name, o.address,o.district, po.owner_id, count(*) OVER() AS full_count
            from property  p
            inner join property_owner po on  p.id = po.property_id
            inner join owner o on po.owner_id=o.id
            inner join type t on p.type_id = t.id 
            inner join `usage` u on p.usage_id = u.id 
            $whereStr $refNumFilter $ownerFilter $plotFilter
             limit ? offset ?''',
        <String>[_limit.toString(), _offset.toString()]);
    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }
    List<PropertyDTO> _propertiesDTO = <PropertyDTO>[];
    results.forEach((Map<String, dynamic> element) {
      PropertyDTO _propertyDTO =
          PropertyDTO.fromJson(recaseMap(element, recaseKeyCamelCase));
      _propertiesDTO.add(_propertyDTO);
    });

    Map<String, dynamic> totalElement = results.first;
    int total = totalElement['full_count'] as int;
    return <String, dynamic>{'properties': _propertiesDTO, 'total': total};
  }

  Future<List<PropertyDTO>> findPaginatedPropertyDTO(
      int limit, int pageNumber) async {
    int _limit = limit;
    int _offset = (_limit * pageNumber) - _limit;
    final SqlStatement query = SqlStatement(
        '''select  p.id,p.ref_num, p.area, p.block, p.plot, t.name as type, 
            u.name as `usage`, o.first_name,
            o.last_name, o.address,o.district
            from property  p
            inner join property_owner po on  p.id = po.property_id
            inner join owner o on po.owner_id=o.id
            inner join type t on p.type_id = t.id 
            inner join `usage` u on p.usage_id = u.id 
             limit ? offset ?''',
        <String>[_limit.toString(), _offset.toString()]);

    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }
    await _dbClient.close();

    List<PropertyDTO> _propertiesDTO = <PropertyDTO>[];
    results.forEach((Map<String, dynamic> element) {
      PropertyDTO _propertyDTO = PropertyDTO.fromJson(recaseMap(element));
      _propertiesDTO.add(_propertyDTO);
    });

    return _propertiesDTO;
  }

  Future<PropertyDTO> findByRefExact(String refNum) async {
    final SqlStatement query = SqlStatement(
        '''select  p.id,p.ref_num, p.area, p.block, p.plot, t.name as type, 
            u.name as `usage`, o.first_name,
            o.last_name, o.address,o.district
            from property  p
            inner join property_owner po on  p.id = po.property_id
            inner join owner o on po.owner_id=o.id
            inner join type t on p.type_id = t.id 
            inner join `usage` u on p.usage_id = u.id 
            where p.ref_num = ?
             ''', <String>[refNum]);

    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }
    await _dbClient.close();

    PropertyDTO _propertyDTO =
        PropertyDTO.fromJson(recaseMap(results.first, recaseKeyCamelCase));

    return _propertyDTO;
  }

  Future<int> count() async {
    final SqlStatement query = SqlStatement('SELECT COUNT(*) FROM property;');
    SqlClient _dbClient = newDB().sqlClient;
    SqlIterator result = await _dbClient.rawQuery(query);
    await _dbClient.close();
    List<Map<String, dynamic>> results = await result.toMaps();
    if (results.isEmpty) {
      throw Exception();
    }
    return results.first['COUNT(*)'] as int;
  }
}
