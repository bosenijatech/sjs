import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionManager {
  // --- Singleton setup ---
  PermissionManager._privateConstructor();
  static final PermissionManager _instance =
      PermissionManager._privateConstructor();
  static PermissionManager get instance => _instance;

  bool _isRequesting = false;

  /// 📸 Request camera permission (handles Android/iOS safely)
  Future<bool> requestCameraPermission() async {
    return _safeRequest(() async {
      final status = await Permission.camera.status;

      if (status.isGranted) return true;
      if (status.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      return false;
    });
  }

  /// 🖼️ Request gallery (photos/media) permission — handles Android 13+ changes
  Future<bool> requestGalleryPermission() async {
    return _safeRequest(() async {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final result = await Permission.photos.request();
        return result.isGranted;
      } else {
        // Android 13+ needs separate media permissions
        final statuses = await [
          Permission.photos,
          Permission.videos,
        ].request();

        bool allGranted =
            statuses.values.every((element) => element.isGranted);

        if (!allGranted &&
            statuses.values.any((e) => e.isPermanentlyDenied)) {
          await openAppSettings();
        }

        return allGranted;
      }
    });
  }

  /// 📂 Request storage permission (for file saving)
  Future<bool> requestStoragePermission() async {
    return _safeRequest(() async {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // iOS doesn't need storage permission (handled by Photos)
        return true;
      }

      final status = await Permission.storage.status;

      if (status.isGranted) return true;
      if (status.isDenied) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      return false;
    });
  }

  /// 🔔 Request notification permission (Android 13+, iOS 10+)
  Future<bool> requestNotificationPermission() async {
    return _safeRequest(() async {
      final status = await Permission.notification.status;

      if (status.isGranted) return true;
      final result = await Permission.notification.request();

      if (result.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      return result.isGranted;
    });
  }

  /// 🧩 Internal safe guard to prevent multiple requests at once
  Future<bool> _safeRequest(Future<bool> Function() request) async {
    if (_isRequesting) {
      debugPrint("⚠️ Permission request already running. Skipping.");
      return false;
    }
    _isRequesting = true;

    try {
      return await request();
    } finally {
      _isRequesting = false;
    }
  }
}
