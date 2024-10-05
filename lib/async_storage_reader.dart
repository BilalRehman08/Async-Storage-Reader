library async_storage_reader;

import 'dart:io' as io;
import 'package:async_storage_reader/src/ios_storage.dart';
import 'package:async_storage_reader/src/shared_prefs_storage.dart';
import 'package:async_storage_reader/src/sqlite_storage.dart';

class AsyncStorageReader {
  final SQLiteStorage sqliteStorage;
  final SharedPrefsStorage sharedPrefsStorage;
  final IOSStorage iosStorage;

  AsyncStorageReader({
    SQLiteStorage? sqliteStorage,
    SharedPrefsStorage? sharedPrefsStorage,
    IOSStorage? iosStorage,
  })  : sqliteStorage = sqliteStorage ?? SQLiteStorage(),
        sharedPrefsStorage = sharedPrefsStorage ?? SharedPrefsStorage(),
        iosStorage = iosStorage ?? IOSStorage();

  Future<String?> getItem(String key) async {
    String? value = await sqliteStorage.getItemFromSQLite(key);
    if (value != null) return value;

    return io.Platform.isAndroid
        ? await sharedPrefsStorage.getItemFromSharedPreferences(key)
        : await iosStorage.getItemFromIOSAsyncStorage(key);
  }

  Future<Map<String, String>> getAllItems() async {
    Map<String, String> allItems = await sqliteStorage.getAllItemsFromSQLite();

    if (allItems.isEmpty) {
      allItems.addAll(io.Platform.isAndroid
          ? await sharedPrefsStorage.getAllItemsFromSharedPreferences()
          : await iosStorage.getAllItemsFromIOSAsyncStorage());
    }

    return allItems;
  }

  Future<bool> removeItem(String key) async {
    bool success = await sqliteStorage.removeItemFromSQLite(key);
    if (!success) {
      success = io.Platform.isAndroid
          ? await sharedPrefsStorage.removeItemFromSharedPreferences(key)
          : await iosStorage.removeItemFromIOSAsyncStorage(key);
    }
    return success;
  }

  Future<bool> clear() async {
    bool success = await sqliteStorage.clearSQLite();
    if (!success) {
      success = io.Platform.isAndroid
          ? await sharedPrefsStorage.clearSharedPreferences()
          : await iosStorage.clearIOSAsyncStorage();
    }
    return success;
  }
}
