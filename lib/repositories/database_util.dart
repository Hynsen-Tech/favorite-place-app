import 'package:favorite_place_app/repositories/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtil {
  DatabaseUtil._internal();

  static final DatabaseUtil _instance = DatabaseUtil._internal();

  factory DatabaseUtil() => _instance;

  Future<List<Map<String, Object?>>> getTable(String table) async {
    final Database db = await DBHelper().db;
    final List<Map<String, Object?>> data = await db.query(table);
    return data;
  }

  Future<int> insertInDatabase(
      {required String table, required Map<String, Object?> values}) async {
    final Database db = await DBHelper().db;
    final int id =
        await db.insert(table, values); //TODO manage duplicate and errors
    return id;
  }

  Future<Map<String, dynamic>> insert(String table, Map<String, Object?> values) async {
    final Database db = await DBHelper().db;
    Map<String, dynamic> response = {
      'id': null,
      'error': null,
    };
    try {
      response['id'] = await db.insert(table, values);
    } catch(e){
      response['id'] = null;
      response['error'] = e;
    }
    return response;
  }

  Future<Map<String, dynamic>> update(String table, Map<String, Object?> values,
      String where, List<dynamic> args) async {
    final Database db = await DBHelper().db;
    Map<String, dynamic> response = {
      'num': -1,
      'error': null,
    };
    try {
      response['num'] = await db.update(table, values, where: where, whereArgs: args);
    } catch(e) {
      response['num'] = -1;
      response['error'] = e;
    }
    return response;
  }

  Future<Map<String, dynamic>> delete(
      String table, String where, List<dynamic> args) async {
    final Database db = await DBHelper().db;
    Map<String, dynamic> response = {
      'num': -1,
      'error': null,
    };
    try {
      response['num'] = await db.delete(table, where: where, whereArgs: args);
    } catch (e) {
      response['id'] = -1;
      response['error'] = e;
    }
    return response;
  }
}
