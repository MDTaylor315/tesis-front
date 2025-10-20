import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:adipix/theme/app_theme.dart';

// Este widget ahora maneja la inicialización, vista previa y captura de la cámara
class OnboardingStepCamera extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const OnboardingStepCamera({
    super.key,
    required this.onChanged,
  });

  @override
  State<OnboardingStepCamera> createState() => _OnboardingStepCameraState();
}

class _OnboardingStepCameraState extends State<OnboardingStepCamera> {
  // Controladores de la cámara
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  // Estado de la captura
  bool _isTakingPhoto = false;
  String? _imagePath;

  // Estado del temporizador
  Timer? _timer;
  int _countdown = 3;

  // Opciones de la cámara (ej: flash, cámara frontal/trasera)
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa la cámara disponible (la primera trasera que encuentre)
  Future<void> _initializeCamera() async {
    // 1. Obtener lista de cámaras
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      debugPrint("Error: No se encontraron cámaras disponibles.");
      return;
    }

    // 2. Seleccionar la primera cámara trasera
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // 3. Inicializar el controlador
    _initializeControllerFuture = _controller!.initialize().then((_) {
      if (!mounted) return;
      // Una vez inicializada, configurar el flash por defecto
      _controller!.setFlashMode(_flashMode);
      setState(() {});
    }).catchError((e) {
      debugPrint("Error al inicializar la cámara: $e");
    });
  }

  // Comienza la cuenta regresiva antes de tomar la foto
  void _startCountdown() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isTakingPhoto = true;
      _countdown = 3; // Reset del contador
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        _capturePhoto();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  // Lógica de captura de foto
  Future<void> _capturePhoto() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return;

      // Ensure the capture process is not interrupted
      final XFile file = await _controller!.takePicture();

      // Mover la imagen a un directorio temporal de la app para asegurar persistencia
      final directory = await getTemporaryDirectory();
      final String filePath =
          '${directory.path}/adipix_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(file.path).copy(filePath);

      setState(() {
        _imagePath = filePath;
        _isTakingPhoto = false;
      });

      // Notificar al widget padre que la foto ha sido tomada
      widget.onChanged(true);
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isTakingPhoto = false;
      });
      // Volver a validar el paso por si algo falló
      widget.onChanged(false);
    }
  }

  // Permite al usuario reintentar la captura
  void _retakePhoto() {
    setState(() {
      _imagePath = null;
      _isTakingPhoto = false;
      _countdown = 3;
    });
    // Notificar al padre que el paso ya no es válido hasta que se tome una nueva foto
    widget.onChanged(false);
  }

  // Alternar el modo de flash
  void _toggleFlash() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final newFlashMode =
        _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    _controller!.setFlashMode(newFlashMode);

    setState(() {
      _flashMode = newFlashMode;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget interfaz() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          // Estilos compactos para sobrescribir los valores por defecto

          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Si hay una imagen capturada, mostrarla en modo "Revisión"
          if (_imagePath != null) {
            return _buildReviewMode();
          }
          // Si el controlador está inicializado, mostrar la vista previa
          if (_controller != null && _controller!.value.isInitialized) {
            return _buildCameraView(context);
          }
        }

        // Mientras espera o si hubo un error de inicialización
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.secondaryColor),
        );
      },
    );
  }

  // --- Widgets de la Interfaz ---

  Widget _buildCameraView(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Calcular el aspect ratio para llenar la pantalla sin distorsionar la vista previa
    final cameraAspectRatio = _controller!.value.aspectRatio;

    // El widget CameraPreview debe estar envuelto en una escala para llenar el espacio
    return Stack(
      children: [
        // 1. Vista Previa de la Cámara (Fondo)
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: cameraAspectRatio,
            child: CameraPreview(_controller!),
          ),
        ),

        // 2. Overlay de las guías circulares (BodyTrackingPainter)
        Positioned.fill(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomPaint(
                size: Size(size.width,
                    size.height), // Usar el tamaño completo para mejor cálculo
                painter: BodyTrackingPainter(),
              ),
            ),
          ),
        ),

        // 3. Contenido Superior/Temporizador
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.greyBorder, width: 0.5),
                  ),
                  onPressed: () {},
                  // Estilos compactos para sobrescribir los valores por defecto

                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'Seguimiento corporal',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Cada mes te tomarás una foto para registrar tu progreso',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                // INDICADOR DEL TEMPORIZADOR
                if (_isTakingPhoto)
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        '$_countdown',
                        style: const TextStyle(
                          fontSize: 100,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black54,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const Spacer(),

                // Botón de Flash
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildCameraButton(
                        _flashMode == FlashMode.off
                            ? Icons.flash_off
                            : Icons.flash_on,
                        _isTakingPhoto
                            ? () {}
                            : _toggleFlash, // No permitir cambiar flash durante la captura
                        isEnabled: !_isTakingPhoto),
                  ),
                ),

                // Instrucciones inferiores
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Párate de frente, de preferencia sin ropa para mejor precisión.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Controles de Cámara
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Botón Galería (Simulación)
                        _buildCameraButton(Icons.image_outlined, () {
                          // Lógica de Galería/Importar
                        }, isEnabled: !_isTakingPhoto),

                        // Botón Capturar (inicia la cuenta regresiva)
                        _buildCaptureButton(_startCountdown, !_isTakingPhoto),

                        // Placeholder/Boton Inverso
                        const SizedBox(width: 44),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Modo de revisión de la foto
  Widget _buildReviewMode() {
    return Column(
      children: [
        // 1. Imagen capturada
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(_imagePath!),
                fit: BoxFit.cover,
              ),
              // Overlay (opcional: efecto de revisión o borde)
              Container(
                color: Colors.black38,
              ),
              // Botón de reintentar
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Estás conforme con la foto?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _retakePhoto,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Volver a Tomar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // IMPORTANTE: El botón "Continuar/Finalizar" se maneja en el padre (_OnboardingScreenState)
        // Se ocultará aquí pero aparecerá en OnboardingScreen cuando _photoTaken sea true.
      ],
    );
  }

  // --- Componentes Reutilizables ---

  Widget _buildCaptureButton(VoidCallback onPressed, bool isEnabled) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 4),
        ),
        child: Center(
          child: Icon(Icons.camera_alt,
              color: isEnabled ? AppTheme.secondaryColor : AppTheme.unselected,
              size: 30),
        ),
      ),
    );
  }

  Widget _buildCameraButton(IconData icon, VoidCallback onPressed,
      {required bool isEnabled}) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white54 : Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon,
            color: isEnabled ? Colors.white : Colors.white54, size: 24),
        onPressed: isEnabled ? onPressed : null,
      ),
    );
  }
}

// Pintor para simular las guías circulares/curvas de seguimiento corporal
class BodyTrackingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Pintura del contorno
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1);

    // Dimensiones relativas del cuerpo para el overlay
    final rectWidth = size.width * 0.9;
    final rectHeight = size.height * 0.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final left = centerX - rectWidth / 2;
    final top = centerY - rectHeight / 2;

    // Dibujar las esquinas curvadas
    const double cornerRadius = 20.0;
    const double arcLength = 50.0;

    // Top Left Arc
    canvas.drawArc(
      Rect.fromLTWH(left, top, arcLength * 2, arcLength * 2),
      3.14159, // Start angle: 180 degrees (left)
      1.5708, // Sweep angle: 90 degrees (down)
      false,
      paint,
    );

    // Top Right Arc
    canvas.drawArc(
      Rect.fromLTWH(
          left + rectWidth - arcLength * 2, top, arcLength * 2, arcLength * 2),
      -1.5708, // Start angle: 270 degrees (up)
      1.5708, // Sweep angle: 90 degrees (right)
      false,
      paint,
    );

    // Bottom Left Arc
    canvas.drawArc(
      Rect.fromLTWH(
          left, top + rectHeight - arcLength * 2, arcLength * 2, arcLength * 2),
      3.14159, // Start angle: 0 degrees (right)
      -1.5708, // Sweep angle: -90 degrees (up)
      false,
      paint,
    );

    // Bottom Right Arc
    canvas.drawArc(
      Rect.fromLTWH(left + rectWidth - arcLength * 2,
          top + rectHeight - arcLength * 2, arcLength * 2, arcLength * 2),
      1.5708, // Start angle: 90 degrees (down)
      -1.5708, // Sweep angle: -90 degrees (left)
      false,
      paint,
    );
/*
    // Líneas auxiliares horizontales (caderas, hombros)
    final hipY = top + rectHeight * 0.7;
    final shoulderY = top + rectHeight * 0.3;

    // Hombros
    canvas.drawLine(
        Offset(left + arcLength, shoulderY),
        Offset(left + rectWidth - arcLength, shoulderY),
        paint..strokeWidth = 1.0);
    // Caderas
    canvas.drawLine(Offset(left + arcLength, hipY),
        Offset(left + rectWidth - arcLength, hipY), paint..strokeWidth = 1.0);*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
