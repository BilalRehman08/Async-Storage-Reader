import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteStorage {
  static Database? _database;

  static Future<void> _initializeDatabase() async {
    if (_database != null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = Platform.isIOS
          ? '${directory.path}/../Library/Application Support/RKStorage'
          : '${directory.path}/../databases/RKStorage';

      if (!await File(path).exists()) return;

      _database = await openDatabase(path, readOnly: false);
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  Future<String?> getItemFromSQLite(String key) async {
    await _initializeDatabase();
    if (_database == null) return null;

    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'catalystLocalStorage',
        columns: ['value'],
        where: 'key = ?',
        whereArgs: [key],
      );
      return maps.isNotEmpty ? maps.first['value'] as String? : null;
    } catch (e) {
      print("Error reading from SQLite: $e");
      return null;
    }
  }

  Future<Map<String, String>> getAllItemsFromSQLite() async {
    await _initializeDatabase();
    if (_database == null) return {};

    try {
      final List<Map<String, dynamic>> maps =
          await _database!.query('catalystLocalStorage');
      return Map.fromEntries(maps.map(
          (item) => MapEntry(item['key'] as String, item['value'] as String)));
    } catch (e) {
      print("Error reading all items from SQLite: $e");
      return {};
    }
  }

  Future<bool> removeItemFromSQLite(String key) async {
    await _initializeDatabase();
    if (_database == null) return false;

    try {
      await _database!.delete(
        'catalystLocalStorage',
        where: 'key = ?',
        whereArgs: [key],
      );
      return true;
    } catch (e) {
      print("Error removing item from SQLite: $e");
      return false;
    }
  }

  Future<bool> clearSQLite() async {
    await _initializeDatabase();
    if (_database == null) return false;

    try {
      await _database!.delete('catalystLocalStorage');
      return true;
    } catch (e) {
      print("Error clearing SQLite: $e");
      return false;
    }
  }
}
