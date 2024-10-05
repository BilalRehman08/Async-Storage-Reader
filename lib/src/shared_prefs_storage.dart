import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  /// Retrieves an item from SharedPreferences.
  ///
  /// [key] is the key of the item to retrieve.
  Future<String?> getItemFromSharedPreferences(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print("Error reading from SharedPreferences: $e");
      return null;
    }
  }

  /// Retrieves all items from SharedPreferences.
  ///
  /// Returns a Map of all key-value pairs stored in SharedPreferences.
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

  /// Removes an item from SharedPreferences.
  ///
  /// [key] is the key of the item to remove.
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

  /// Clears all items from SharedPreferences.
  ///
  /// Returns true if the operation was successful, false otherwise.
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
