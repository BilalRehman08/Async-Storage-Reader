import 'dart:io' as io;

/// An abstract class to check the platform type.
///
/// Provides methods to determine if the current platform is Android or iOS.
abstract class PlatformChecker {
  /// Returns `true` if the current platform is Android.
  bool get isAndroid;

  /// Returns `true` if the current platform is iOS.
  bool get isIOS;
}

/// A class that implements [PlatformChecker] to provide platform-specific checks.
///
/// Uses Dart's [io.Platform] to determine the current operating system.
class RealPlatformChecker implements PlatformChecker {
  /// Returns `true` if the current platform is Android.
  @override
  bool get isAndroid => io.Platform.isAndroid;

  /// Returns `true` if the current platform is iOS.
  @override
  bool get isIOS => io.Platform.isIOS;
}
