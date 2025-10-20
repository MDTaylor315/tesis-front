import 'package:adipix/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnboardingStepName extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onChanged;

  const OnboardingStepName({
    super.key,
    required this.initialName,
    required this.onChanged,
  });

  @override
  State<OnboardingStepName> createState() => _OnboardingStepNameState();
}

class _OnboardingStepNameState extends State<OnboardingStepName> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _nameController.addListener(_updateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateName);
    _nameController.dispose();
    super.dispose();
  }

  void _updateName() {
    widget.onChanged(_nameController.text);
  }

  InputDecoration _noBorderDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: Colors.grey.withOpacity(0.3),
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,

      contentPadding: EdgeInsets.zero,
      isDense: true,

      // ⭐ MOSTRAR EL ERROR DE VALIDACIÓN ⭐
      errorStyle: const TextStyle(fontSize: 14, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Cómo te decimos?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: SizedBox(
              width: double.infinity, // Ancho fijo para el nombre
              child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.name,
                  textCapitalization:
                      TextCapitalization.words, // Capitalizar primera letra
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryColor,
                  ),
                  decoration: _noBorderDecoration(hint: 'Nick')
                      .copyWith(errorText: null)),
            ),
          ),
        ],
      ),
    );
  }
}
