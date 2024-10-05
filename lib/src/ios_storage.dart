import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class IOSStorage {
  String? _asyncStoragePath;

  Future<void> _initializeIOSAsyncStoragePath() async {
    if (_asyncStoragePath != null) return;

    final directory = await getApplicationDocumentsDirectory();
    final appSupportDir =
        Directory('${directory.path}/../Library/Application Support');
    final packageInfo = await PackageInfo.fromPlatform();
    final bundleId = packageInfo.packageName;

    _asyncStoragePath =
        '${appSupportDir.path}/$bundleId/RCTAsyncLocalStorage_V1';
  }

  Future<String?> getItemFromIOSAsyncStorage(String key) async {
    await _initializeIOSAsyncStoragePath();
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

  Future<Map<String, String>> getAllItemsFromIOSAsyncStorage() async {
    await _initializeIOSAsyncStoragePath();
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

  Future<bool> removeItemFromIOSAsyncStorage(String key) async {
    await _initializeIOSAsyncStoragePath();
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

  Future<bool> clearIOSAsyncStorage() async {
    await _initializeIOSAsyncStoragePath();
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
