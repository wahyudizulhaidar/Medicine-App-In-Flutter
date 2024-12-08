

import 'package:medicine/database/pills_database.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  final PillsDatabase _pillsDatabase = PillsDatabase();
  static Database? _database;

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _pillsDatabase.setDatabase();
    }
    return _database!;
  }

  Future<int?> insertData(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;

      if (!data.containsKey('name') || !data.containsKey('amount') || !data.containsKey('type')) {
        throw Exception('Data tidak lengkap, pastikan semua kolom yang diperlukan ada.');
      }

      return await db.insert(table, data);
    } catch (e) {
      print('Error inserting data into $table: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllData(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<int?> deleteData(String table, int id) async {
    try {
      final db = await database;
      return await db.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print('Error deleting data: $e');
      return null;
    }
  }
}