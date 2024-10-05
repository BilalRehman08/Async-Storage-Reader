import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class IOSStorage {
  String? _asyncStoragePath;

  /// Initializes the iOS AsyncStorage path.
  ///
  /// This method sets up the path where AsyncStorage data will be stored.
  Future<void> initializeIOSAsyncStoragePath() async {
    if (_asyncStoragePath != null) return;

    final directory = await getApplicationDocumentsDirectory();
    final appSupportDir =
        Directory('${directory.path}/../Library/Application Support');
    final packageInfo = await PackageInfo.fromPlatform();
    final bundleId = packageInfo.packageName;

    _asyncStoragePath =
        '${appSupportDir.path}/$bundleId/RCTAsyncLocalStorage_V1';
  }

  /// Retrieves an item from iOS AsyncStorage.
  ///
  /// [key] is the key of the item to retrieve.
  Future<String?> getItemFromIOSAsyncStorage(String key) async {
    await initializeIOSAsyncStoragePath();
    try {
      final manifestFile = File('$_asyncStoragePath/manifest.json');
      if (await manifestFile.exists()) {
        final manifestContent = await manifestFile.readAsString();
        final manifest = json.decode(manifestContent) as Map<String, dynamic>;
        return manifest[key];
      }
    } catch (e) {
      print("Error reading from iOS AsyncStorage: $e");
    }
    return null;
  }

  /// Retrieves all items from iOS AsyncStorage.
  ///
  /// Returns a Map of all key-value pairs stored in AsyncStorage.
  Future<Map<String, String>> getAllItemsFromIOSAsyncStorage() async {
    await initializeIOSAsyncStoragePath();
    try {
      final manifestFile = File('$_asyncStoragePath/manifest.json');
      if (await manifestFile.exists()) {
        final manifestContent = await manifestFile.readAsString();
        Map<String, dynamic> jsonContent = json.decode(manifestContent);
        return jsonContent.map((key, value) => MapEntry(key, value.toString()));
      }
    } catch (e) {
      print("Error reading all items from iOS AsyncStorage: $e");
    }
    return {};
  }

  /// Removes an item from iOS AsyncStorage.
  ///
  /// [key] is the key of the item to remove.
  Future<bool> removeItemFromIOSAsyncStorage(String key) async {
    await initializeIOSAsyncStoragePath();
    try {
      final manifestFile = File('$_asyncStoragePath/manifest.json');
      if (await manifestFile.exists()) {
        final manifestContent = await manifestFile.readAsString();
        final manifest = json.decode(manifestContent) as Map<String, dynamic>;
        manifest.remove(key);
        await manifestFile.writeAsString(json.encode(manifest));
        return true;
      }
    } catch (e) {
      print("Error removing item from iOS AsyncStorage: $e");
    }
    return false;
  }

  /// Clears all items from iOS AsyncStorage.
  ///
  /// Returns true if the operation was successful, false otherwise.
  Future<bool> clearIOSAsyncStorage() async {
    await initializeIOSAsyncStoragePath();
    try {
      final manifestFile = File('$_asyncStoragePath/manifest.json');
      if (await manifestFile.exists()) {
        await manifestFile.writeAsString('{}');
        return true;
      }
    } catch (e) {
      print("Error clearing iOS AsyncStorage: $e");
    }
    return false;
  }
}
