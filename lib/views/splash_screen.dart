import 'package:adipix/helpers/request_permission.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';

// ----------------------------------------------------------------------
// ESTADO DE LA PANTALLA: Define qué se debe renderizar.
// ----------------------------------------------------------------------
enum ScreenState { loading, permissionDenied, readyToNavigate }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final PermissionService _permissionService = PermissionService();
  ScreenState _screenState = ScreenState.loading;

  // Los tiempos de espera de tu lógica original
  static const Duration _fadeDelay = Duration(seconds: 1);
  static const Duration _logoDisplayDelay = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Inicia el flujo completo: Animación, verificación de usuario, y verificación de permisos.
  void _startAppFlow() async {
    // 1. Esperar la animación de inicio (Manteniendo tu lógica original)
    await Future.delayed(_fadeDelay);
    await Future.delayed(_logoDisplayDelay);

    // 2. Verificar el estado del usuario (Manteniendo tu lógica original)
    final bool isLoggedIn = await _verifyUserStatus();

    if (!mounted) return;

    // 3. Verificar y solicitar permiso de cámara (AÑADIDO)
    final bool isCameraGranted = await _checkAndRequestCameraPermission();

    if (!mounted) return;

    if (isCameraGranted) {
      print("tiene permisos? si");
      // Si el permiso está OK, navegar.
      if (isLoggedIn) {
        // Asumiendo que /home es la ruta principal si está logueado
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Si no está logueado, ir al onboarding o login.
        // Aquí decidimos ir al Onboarding ya que es el flujo principal de setup.
        Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
      }
    } else {
      // Si el permiso NO fue concedido, mostrar la pantalla de denegación.
      setState(() {
        _screenState = ScreenState.permissionDenied;
      });
    }
  }

  Future<bool> _verifyUserStatus() async {
    // Manteniendo tu lógica original para simular verificación de usuario
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulación: Asumo que si isLoggedIn es true, va a /home; si es false, a /onboarding
    return false; // Forzamos a ir al onboarding para este ejemplo.
  }

  /// Lógica de solicitud de permiso de cámara.
  Future<bool> _checkAndRequestCameraPermission() async {
    // 1. Verificar el estado actual
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else {
      // 2. Solicitar el permiso
      final newStatus = await Permission.camera.request();
      return newStatus.isGranted;
    }
  }

  /// Función que se llama cuando el usuario presiona el botón de reintento.
  void _onRetryPressed() async {
    setState(() {
      _screenState = ScreenState.loading;
    });

    // Verificar si el permiso fue denegado permanentemente (necesita ir a settings)
    final isPermanentlyDenied = await Permission.camera.isPermanentlyDenied;

    if (isPermanentlyDenied) {
      // Abrir la configuración de la aplicación
      await openAppSettings();
      // Pequeño retraso para que el usuario regrese de la configuración
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Reiniciar el flujo de la aplicación para volver a verificar permisos y navegar.
    _startAppFlow();
  }

  @override
  Widget build(BuildContext context) {
    // Si el permiso está denegado, mostramos la pantalla de error personalizada.
    if (_screenState == ScreenState.permissionDenied) {
      return _buildPermissionDeniedScreen(context);
    }

    // Pantalla de carga/logo (tu diseño original)
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        // Usamos tu logo original mientras el flujo de verificación está en curso
        child: Image.asset("assets/img/logo.png", width: width * 0.5),
      ),
    );
  }

  /// Widget que se muestra cuando el permiso de la cámara es denegado.
  Widget _buildPermissionDeniedScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 100,
                color: AppTheme.secondaryColor,
              ),
              const SizedBox(height: 30),
              const Text(
                'Acceso a la Cámara Requerido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'Necesitas activar el permiso de la cámara para poder tomar fotos de tu progreso y continuar con la aplicación.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _onRetryPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Activar Permiso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
