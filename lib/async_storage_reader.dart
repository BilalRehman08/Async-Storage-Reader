/// A library for reading AsyncStorage data from React Native apps in Flutter.
///
/// This library provides a unified interface to access AsyncStorage data
/// from both Android and iOS platforms, facilitating data migration
/// from React Native to Flutter applications.
library async_storage_reader;

import 'dart:io' as io;
import 'package:async_storage_reader/src/ios_storage.dart';
import 'package:async_storage_reader/src/shared_prefs_storage.dart';
import 'package:async_storage_reader/src/sqlite_storage.dart';

/// A class to read and manage AsyncStorage data across different storage mechanisms.
///
/// This class provides methods to access, retrieve, and manage data stored
/// in SQLite, SharedPreferences (Android), and iOS-specific storage.
class AsyncStorageReader {
  /// The SQLite storage implementation.
  ///
  /// This member handles all SQLite-related operations for storing and retrieving data.
  final SQLiteStorage sqliteStorage;

  /// The SharedPreferences storage implementation for Android.
  ///
  /// This member handles all SharedPreferences-related operations for storing and retrieving data on Android devices.
  final SharedPrefsStorage sharedPrefsStorage;

  /// The iOS-specific storage implementation.
  ///
  /// This member handles all iOS-specific operations for storing and retrieving data on iOS devices.
  final IOSStorage iosStorage;

  /// Constructs an instance of [AsyncStorageReader].
  ///
  /// You can optionally provide custom implementations of [SQLiteStorage],
  /// [SharedPrefsStorage], and [IOSStorage]. If not provided, default
  /// implementations will be used.
  AsyncStorageReader({
    SQLiteStorage? sqliteStorage,
    SharedPrefsStorage? sharedPrefsStorage,
    IOSStorage? iosStorage,
  })  : sqliteStorage = sqliteStorage ?? SQLiteStorage(),
        sharedPrefsStorage = sharedPrefsStorage ?? SharedPrefsStorage(),
        iosStorage = iosStorage ?? IOSStorage();

  /// Retrieves the value associated with the given [key].
  ///
  /// This method first checks SQLite storage, then falls back to
  /// platform-specific storage (SharedPreferences for Android, iOS-specific for iOS).
  ///
  /// Returns a [Future] that completes with the value as a [String],
  /// or `null` if the key is not found.
  Future<String?> getItem(String key) async {
    String? value = await sqliteStorage.getItemFromSQLite(key);
    if (value != null) return value;

    return io.Platform.isAndroid
        ? await sharedPrefsStorage.getItemFromSharedPreferences(key)
        : await iosStorage.getItemFromIOSAsyncStorage(key);
  }

  /// Retrieves all key-value pairs stored in AsyncStorage.
  ///
  /// This method first checks SQLite storage, then falls back to
  /// platform-specific storage if SQLite is empty.
  ///
  /// Returns a [Future] that completes with a [Map] containing
  /// all key-value pairs stored in AsyncStorage.
  Future<Map<String, String>> getAllItems() async {
    Map<String, String> allItems = await sqliteStorage.getAllItemsFromSQLite();

    if (allItems.isEmpty) {
      allItems.addAll(io.Platform.isAndroid
          ? await sharedPrefsStorage.getAllItemsFromSharedPreferences()
          : await iosStorage.getAllItemsFromIOSAsyncStorage());
    }

    return allItems;
  }

  /// Removes the value associated with the given [key].
  ///
  /// This method attempts to remove the item from SQLite storage first,
  /// then falls back to platform-specific storage if unsuccessful.
  ///
  /// Returns a [Future] that completes with a [bool] indicating
  /// whether the removal was successful.
  Future<bool> removeItem(String key) async {
    bool success = await sqliteStorage.removeItemFromSQLite(key);
    if (!success) {
      success = io.Platform.isAndroid
          ? await sharedPrefsStorage.removeItemFromSharedPreferences(key)
          : await iosStorage.removeItemFromIOSAsyncStorage(key);
    }
    return success;
  }

  /// Clears all data from AsyncStorage.
  ///
  /// This method attempts to clear SQLite storage first,
  /// then falls back to platform-specific storage if unsuccessful.
  ///
  /// Returns a [Future] that completes with a [bool] indicating
  /// whether the clearing operation was successful.
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
