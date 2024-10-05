import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  Future<String?> getItemFromSharedPreferences(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print("Error reading from SharedPreferences: $e");
      return null;
    }
  }

  Future<Map<String, String>> getAllItemsFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      Map<String, String> result = {};
      for (String key in allKeys) {
        String? value = prefs.getString(key);
        if (value != null) {
          result[key] = value;
        }
      }
      return result;
    } catch (e) {
      print("Error reading all items from SharedPreferences: $e");
      return {};
    }
  }

  Future<bool> removeItemFromSharedPreferences(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return true;
    } catch (e) {
      print("Error removing item from SharedPreferences: $e");
      return false;
    }
  }

  Future<bool> clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      print("Error clearing SharedPreferences: $e");
      return false;
    }
  }
}
