import 'package:flutter/material.dart';
import 'package:adipix/theme/app_theme.dart';

/// Función para mostrar el diálogo de observaciones del plan
void showPlanObservationsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: const PlanObservationsDialog(),
      );
    },
  );
}

/// Widget del diálogo de observaciones
class PlanObservationsDialog extends StatefulWidget {
  const PlanObservationsDialog({super.key});

  @override
  State<PlanObservationsDialog> createState() => _PlanObservationsDialogState();
}

class _PlanObservationsDialogState extends State<PlanObservationsDialog> {
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  final TextEditingController _otherRestrictionsController =
      TextEditingController();

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicalConditionsController.dispose();
    _otherRestrictionsController.dispose();
    super.dispose();
  }

  void _generatePlan() {
    // Obtener los valores de los campos
    final allergies = _allergiesController.text;
    final medicalConditions = _medicalConditionsController.text;
    final otherRestrictions = _otherRestrictionsController.text;

    // Aquí puedes procesar la información
    print('Alergias: $allergies');
    print('Condiciones médicas: $medicalConditions');
    print('Otras restricciones: $otherRestrictions');

    // Cerrar el diálogo
    Navigator.of(context).pop();

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generando nuevo plan diario...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 32,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Text(
                  'Observaciones del plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A52),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtítulo
                Text(
                  'Responde con sinceridad para ajustar tu nutrición diaria.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Campo 1: Alergias
                Text(
                  '¿A qué alimentos eres alérgico o estás restringido por alguna condición médica? (Sepáralos por comas)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _allergiesController,
                  decoration: _buildInputDecoration('Escribe aquí...'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Campo 2: Condiciones médicas
                Text(
                  '¿Tienes alguna condición médica como diabetes o hipertensión?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _medicalConditionsController,
                  decoration: _buildInputDecoration('Escribe aquí...'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Campo 3: Otras restricciones
                Text(
                  '¿Tienes alguna otra restricción, como dificultad para comprar ciertos alimentos o limitaciones específicas?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _otherRestrictionsController,
                  decoration: _buildInputDecoration('Escribe aquí...'),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Botón de generar plan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generatePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D62),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Generar nuevo plan diario',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppTheme.primaryColor,
          width: 2,
        ),
      ),
    );
  }
}
