import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() {
    return _instance;
  }

  PermissionService._internal();

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<bool> requestAudioPermission() async {
    final status = await Permission.audio.request();
    return status.isGranted;
  }

  Future<bool> requestForegroundServicePermission() async {
    final status = await Permission.audio.request();
    return status.isGranted;
  }

  Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  Future<PermissionStatus> getStoragePermissionStatus() async {
    return await Permission.storage.status;
  }

  Future<void> openAppSettings() async {
    openAppSettings();
  }

  Future<bool> requestAllAudioPermissions() async {
    final storageGranted = await requestStoragePermission();
    final audioGranted = await requestAudioPermission();
    
    return storageGranted && audioGranted;
  }
}
