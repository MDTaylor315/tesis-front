import 'package:flutter/material.dart';

Widget buildTextFormField({
   TextEditingController? controller,
  required String labelText, // sirve como label o hint según diseño
  required String? Function(String?) validator,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  bool readOnly = false,
  VoidCallback? onTap,
  Widget? suffixIcon,

  // Personalización opcional
  Color? fillColor,
  Color? borderColor,
  Color? hintColor,
}) {
  final Color _fill = fillColor ?? const Color(0xFF203328);
  final Color _border = borderColor ?? const Color(0xFF42644F);
  final Color _hint = hintColor ?? Colors.white.withOpacity(0.7);

  final borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: _border),
  );

  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: keyboardType,
    obscureText: obscureText,
    readOnly: readOnly,
    onTap: onTap,
    style: const TextStyle(color: Colors.white, fontSize: 16),
    decoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintText: labelText, // usamos labelText como hint
      hintStyle: TextStyle(color: _hint, fontSize: 16),
      filled: true,
      fillColor: _fill,
      border: borderStyle,
      enabledBorder: borderStyle,
      focusedBorder: borderStyle.copyWith(
        borderSide: BorderSide(color: _border.withOpacity(0.9), width: 1.4),
      ),
      errorBorder: borderStyle.copyWith(
        borderSide: BorderSide(color: Colors.red.withOpacity(0.9), width: 1.4),
      ),
      focusedErrorBorder: borderStyle.copyWith(
        borderSide: BorderSide(color: Colors.red.withOpacity(0.9), width: 1.6),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      suffixIcon: suffixIcon,
    ),
  );
}
