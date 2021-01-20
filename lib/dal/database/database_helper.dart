import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'entity/entity.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper = DatabaseHelper._initial();
  Database _database;

  DatabaseHelper._initial();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      print("oluşturdu");
      return _databaseHelper = DatabaseHelper._initial();
    } else {
      print("return etti");
      return _databaseHelper;
    }
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else
      return _database;
  }

  _initializeDatabase() async {
    Directory documentDirecrory = await getApplicationDocumentsDirectory();
    String path = join(documentDirecrory.path, "datewarehouse.db");
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  void _createDatabase(Database db, int version) async {
    print("oluştu");
    await db.execute(
      "CREATE TABLE ${Entity.offlineBarcodeTableName} ("
      "id	INTEGER PRIMARY KEY AUTOINCREMENT,"
      "barcode	TEXT NOT NULL,"
      "quantity	INTEGER NOT NULL"
      ")",
    );
  }
}
// "PRIMARY KEY('id' AUTOINCREMENT)"
