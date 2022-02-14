import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> hasPermission(Permission permission) async {
    return await permission.isGranted;
  }

  static Future<bool> _requestPermission(
    Permission permission, {
    Function? onDenied,
  }) async {
    PermissionStatus permissionStatus = await permission.request();
    if (permissionStatus.isDenied) {
      onDenied?.call();
    }
    return permissionStatus.isGranted;
  }

  static Future<bool> requestLocationWhenInUsePermission(
      {Function? onDenied}) async {
    return _requestPermission(Permission.locationWhenInUse, onDenied: onDenied);
  }
}
