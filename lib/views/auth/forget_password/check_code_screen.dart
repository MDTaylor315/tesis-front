import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/auth/auth_shell_screen.dart';
import 'package:adipix/views/auth/forget_password/reset_password_screen.dart';
import 'package:adipix/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Importar para Timer

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendSeconds = 30;
  bool _isResendActive = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _isResendActive = true;
    if (mounted) setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        if (mounted) setState(() {});
      } else {
        _isResendActive = false;
        if (mounted) setState(() {});
        _timer?.cancel();
      }
    });
  }

  // Nueva función: Reinicia el temporizador
  void _resetResendTimer() {
    _timer?.cancel(); // Cancela el temporizador actual
    _resendSeconds = 30; // Resetea los segundos
    _startResendTimer(); // Reinicia el temporizador
    // Opcional: Agrega lógica aquí para reenviar el código (ej: llamar a una API)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código reenviado')),
    );
  }

  void _handleTextChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _handleKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      }
    }
  }

  Widget _buildCodeField(int index) {
    return SizedBox(
      width: 65,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) => _handleKey(event, index),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          onChanged: (value) => _handleTextChanged(value, index),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCodeComplete = _controllers.every((c) => c.text.isNotEmpty);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          left: 24,
          right: 24,
        ),
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => AuthShell(),
              ),
              (route) => false,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Recordaste tu contraseña? ',
                  style: TextStyle(color: Colors.black)),
              Text("Inicia sesión",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
                Image.asset('assets/img/logo_letras.png', height: 40),
              ],
            ),
            const SizedBox(height: 48),
            const Text(
              'Revisa tu correo electrónico',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Hemos enviado un código a ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "correo@email.com",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => _buildCodeField(index)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCodeComplete
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ResetPasswordScreen(), // Envuelve el widget en MaterialPageRoute
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enviar código '),
                  GestureDetector(
                    // Nuevo: Hace el texto clickable
                    onTap: _isResendActive
                        ? null
                        : _resetResendTimer, // Solo clickable si no está activo
                    child: Text(
                      _isResendActive
                          ? '00:${_resendSeconds.toString().padLeft(2, '0')}'
                          : 'Reenviar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isResendActive
                            ? Colors.grey
                            : AppTheme.secondaryColor, // Azul cuando clickable
                        decoration: _isResendActive
                            ? TextDecoration.none
                            : TextDecoration
                                .underline, // Subrayado opcional para indicar clickable
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
