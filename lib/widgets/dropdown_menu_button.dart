import 'package:adipix/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RotatedDropdown<T> extends StatelessWidget {
  const RotatedDropdown({
    super.key,
    required this.hint,
    required this.decoration,
    required this.items,
    required this.onChanged,
  });

  final String hint;
  final InputDecoration decoration;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  // Widget para el ícono por defecto (sin rotación, como pediste)
  static final Widget defaultIcon = Transform.rotate(
    angle: 0, // Rotación a 0 grados (flecha normal)
    child: const Icon(Icons.keyboard_arrow_down_rounded,
        color: AppTheme.primaryColor),
  );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      // Usamos el ícono estático para todos los casos
      icon: defaultIcon,
      decoration: decoration,
      items: items,
      onChanged: onChanged,
      hint: Text(
        hint,
        style: TextStyle(color: Color(0xFF9AAEBF), fontWeight: FontWeight.w400),
      ),
    );
  }
}
