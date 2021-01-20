import 'package:dw_app/dal/database/database_helper.dart';

abstract class BaseDao<T> {
  DatabaseHelper databaseHelper;

  Future<int> delete(int id);
  Future<int> insert(T data);
  Future<int> update(T data);
  Future<List<T>> getAll(String query);
  Future<T> findById(int id);
}
