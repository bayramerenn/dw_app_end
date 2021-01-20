import 'package:dw_app/dal/database/database_helper.dart';
import 'package:dw_app/dal/database/entity/entity.dart';
import 'package:dw_app/models/offline_barcode.dart';

import 'abstract/base_dao.dart';

class OfflineBarcodeDao implements BaseDao<OfflineBarcode> {
  @override
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _offlineBarcode = OfflineBarcode();

  @override
  Future<int> delete(int id) async {
    var _db = await databaseHelper.getDatabase();
    var result = await _db.delete(Entity.offlineBarcodeTableName,
        where: Entity.offlineBarcodeColumnId + '= ?', whereArgs: [id]);

    return result;
  }

  @override
  Future<OfflineBarcode> findById(int id) async {
    var _db = await databaseHelper.getDatabase();
    var result = await _db.query(Entity.offlineBarcodeTableName,
        where: Entity.offlineBarcodeColumnId + "= ?",
        whereArgs: [Entity.offlineBarcodeColumnId]);
    return result.map((map) => OfflineBarcode.fromMap(map)).first;
  }

  @override
  Future<List<OfflineBarcode>> getAll(String query) async {
    var _db = await databaseHelper.getDatabase();
    if (query == null) {
      var result = await _db.query(Entity.offlineBarcodeTableName,
          orderBy: Entity.offlineBarcodeColumnId + " DESC");

      return result.map((map) => OfflineBarcode.fromMap(map)).toList();
    } else {
      var result = await _db.query(
        Entity.offlineBarcodeTableName,
        where: Entity.offlineBarcodeColumnBarcode + " like ?",
        whereArgs: ['%$query'],
        orderBy: Entity.offlineBarcodeColumnId + "DESC",
      );
      return result.map((map) => OfflineBarcode.fromMap(map)).toList();
    }
  }

  @override
  Future<int> insert(OfflineBarcode data) async {
    var _db = await databaseHelper.getDatabase();
    var map = Map<String, dynamic>();
    map['id'] = 1;
    var result = await _db.insert(
        Entity.offlineBarcodeTableName, _offlineBarcode.toMap(data));

    return result;
  }

  @override
  Future<int> update(OfflineBarcode data) async {
    var _db = await databaseHelper.getDatabase();
    var result = await _db.update(
        Entity.offlineBarcodeTableName, _offlineBarcode.toMap(data),
        where: Entity.offlineBarcodeColumnId + " = ?", whereArgs: [data.id]);
    return result;
  }
}
