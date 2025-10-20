import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/onboarding/onboarding_screen.dart'; // Importa el enum Gender
import 'package:flutter/material.dart';

class OnboardingStepGender extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender> onChanged;

  const OnboardingStepGender({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Te damos la bienvenida a Adipix.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cuéntanos sobre ti para personalizar tu experiencia.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          const Text(
            '¿Cuál es tu género?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor, // Color del título
            ),
          ),
          const SizedBox(height: 24),

          // ⭐ OPCIÓN FEMENINO ⭐
          _buildGenderOption(
            context,
            gender: Gender.femenino,
            label: 'Femenino',
            imagePath: 'assets/img/woman.png', // Ruta de tu imagen Femenina
            isSelected: selectedGender == Gender.femenino,
            onTap: () => onChanged(Gender.femenino),
          ),
          const SizedBox(height: 16),

          // ⭐ OPCIÓN MASCULINO ⭐
          _buildGenderOption(
            context,
            gender: Gender.masculino,
            label: 'Masculino',
            imagePath: 'assets/img/man.png', // Ruta de tu imagen Masculina
            isSelected: selectedGender == Gender.masculino,
            onTap: () => onChanged(Gender.masculino),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required Gender gender,
    required String label,
    String? imagePath, // La ruta de la imagen es opcional
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: imagePath != null ? 160 : 60, // Si hay imagen, más alto
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.secondaryColor.withOpacity(0.08)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.secondaryColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppTheme.secondaryColor : Colors.black87,
                ),
              ),
            ),
            const Spacer(), // Empuja la imagen y el check a la derecha
            if (imagePath != null)
              Expanded(
                // ⭐ Hace que la imagen ocupe todo el espacio restante ⭐
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover, // Para que la imagen ocupe todo el alto
                  alignment: Alignment
                      .bottomRight, // Alinea la imagen a la derecha y abajo
                ),
              ),
            // Checkmark
            Padding(
              padding: EdgeInsets.only(right: imagePath != null ? 16.0 : 20.0),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppTheme.secondaryColor : Colors.grey[300],
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
