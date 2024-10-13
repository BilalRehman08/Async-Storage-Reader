/// A library for reading AsyncStorage data from React Native apps in Flutter.
///
/// This library provides a unified interface to access AsyncStorage data
/// from both Android and iOS platforms, facilitating data migration
/// from React Native to Flutter applications.
library async_storage_reader;

import 'package:async_storage_reader/src/ios_storage.dart';
import 'package:async_storage_reader/src/platform_checker.dart';
import 'package:async_storage_reader/src/sqlite_storage.dart';

/// A class to read and manage AsyncStorage data based on platform.
///
/// This class provides methods to access, retrieve, and manage data stored
/// in SQLite for Android and iOS, and iOS-specific storage for iOS.
class AsyncStorageReader {
  /// The SQLite storage implementation for Android.
  final SQLiteStorage sqliteStorage;

  /// The iOS-specific storage implementation for iOS.
  final IOSStorage iosStorage;

  /// The platform checker implementation to determine the current platform.
  final PlatformChecker platformChecker;

  /// Constructs an instance of [AsyncStorageReader].
  ///
  /// You can optionally provide custom implementations of [SQLiteStorage] and [IOSStorage].
  /// If not provided, default implementations will be used.
  AsyncStorageReader({
    SQLiteStorage? sqliteStorage,
    IOSStorage? iosStorage,
    PlatformChecker? platformChecker,
  })  : sqliteStorage = sqliteStorage ?? SQLiteStorage(),
        iosStorage = iosStorage ?? IOSStorage(),
        platformChecker = platformChecker ?? RealPlatformChecker();

  /// Retrieves the value associated with the given [key].
  ///
  /// On Android, it uses SQLite storage, and on iOS, it uses iOS-specific storage.
  ///
  /// Returns a [Future] that completes with the value as a [String],
  /// a message if the platform is not supported, or if the key is not found.
  Future<String> getItem(String key) async {
    if (platformChecker.isAndroid) {
      final value = await sqliteStorage.getItemFromSQLite(key);
      return value ?? 'Key not found';
    } else if (platformChecker.isIOS) {
      return await iosStorage.getItemFromIOSAsyncStorage(key) ??
          'Key not found';
    }
    return 'Platform not supported';
  }

  /// Retrieves all key-value pairs stored in AsyncStorage.
  ///
  /// On Android, it uses SQLite storage, and on iOS, it uses iOS-specific storage.
  ///
  /// Returns a [Future] that completes with a [Map] containing
  /// all key-value pairs stored in AsyncStorage, or an empty message if none exist.
  Future<Map<String, String>> getAllItems() async {
    if (platformChecker.isAndroid) {
      final items = await sqliteStorage.getAllItemsFromSQLite();
      return items.isNotEmpty ? items : {'message': 'No items found'};
    } else if (platformChecker.isIOS) {
      final items = await iosStorage.getAllItemsFromIOSAsyncStorage();
      return items.isNotEmpty ? items : {'message': 'No items found'};
    }
    return {};
  }

  /// Removes the value associated with the given [key].
  ///
  /// On Android, it uses SQLite storage, and on iOS, it uses iOS-specific storage.
  ///
  /// Returns a [Future] that completes with a [bool] indicating
  /// whether the removal was successful.
  Future<bool> removeItem(String key) async {
    if (platformChecker.isAndroid) {
      return await sqliteStorage.removeItemFromSQLite(key);
    } else if (platformChecker.isIOS) {
      return await iosStorage.removeItemFromIOSAsyncStorage(key);
    }
    return false;
  }

  /// Clears all data from AsyncStorage.
  ///
  /// On Android, it uses SQLite storage, and on iOS, it uses iOS-specific storage.
  ///
  /// Returns a [Future] that completes with a [bool] indicating
  /// whether the clearing operation was successful.
  Future<bool> clear() async {
    if (platformChecker.isAndroid) {
      return await sqliteStorage.clearSQLite();
    } else if (platformChecker.isIOS) {
      return await iosStorage.clearIOSAsyncStorage();
    }
    return false;
  }
}
