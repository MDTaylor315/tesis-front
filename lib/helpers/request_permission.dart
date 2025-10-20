import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Verifica si el permiso de la cámara está concedido.
  Future<bool> isCameraGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Solicita el permiso de la cámara.
  ///
  /// Devuelve true si el permiso es concedido, false si es denegado o permanentemente denegado.
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Abre la configuración de la aplicación si el permiso es denegado permanentemente.
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
