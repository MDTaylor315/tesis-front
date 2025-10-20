import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/onboarding/onboarding_screen.dart'; // Importa el enum WeightUnit
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingStepWeight extends StatefulWidget {
  final double? initialWeight;
  final WeightUnit initialUnit;
  // ⭐ CORRECCIÓN: Un solo callback que devuelve (double?, WeightUnit) ⭐
  final Function(double?, WeightUnit) onChanged;
  // ELIMINAR: final ValueChanged<double?> onChanged;
  // ELIMINAR: final ValueChanged<WeightUnit> onUnitChanged;

  const OnboardingStepWeight({
    super.key,
    required this.initialWeight,
    required this.initialUnit,
    // Solo requerimos el callback unificado
    required this.onChanged,
    // ELIMINAR: required this.onUnitChanged,
  });

  @override
  State<OnboardingStepWeight> createState() => _OnboardingStepWeightState();
}

class _OnboardingStepWeightState extends State<OnboardingStepWeight> {
  final TextEditingController _weightController = TextEditingController();

  // Sincronizar la unidad con el widget padre al inicio
  late WeightUnit _currentUnit;

  @override
  void initState() {
    super.initState();
    _currentUnit = widget.initialUnit;
    if (widget.initialWeight != null) {
      _weightController.text = widget.initialWeight.toString();
    }
    _weightController.addListener(_updateWeight);

    // Inicializa el valor y la unidad en el padre al cargar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateWeight();
    });
  }

  @override
  void dispose() {
    _weightController.removeListener(_updateWeight);
    _weightController.dispose();
    super.dispose();
  }

  // Función unificada para notificar al padre
  void _updateWeight() {
    final weightText = _weightController.text;
    double? weight;
    if (weightText.isNotEmpty) {
      weight = double.tryParse(weightText);
    }

    // ⭐ Notificamos al padre con el peso actual Y la unidad actual ⭐
    widget.onChanged(weight, _currentUnit);
  }

  // Función para actualizar SOLO la unidad
  void _updateUnit(WeightUnit newUnit) {
    setState(() {
      _currentUnit = newUnit;
      // Llamamos a _updateWeight para notificar al padre el cambio de unidad
      _updateWeight();
    });
  }

  InputDecoration _noBorderDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 80,
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
            '¿Cuánto pesas?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: SizedBox(
              width: 150,
              child: TextField(
                  controller: _weightController,
                  textAlign: TextAlign.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d{0,2}')), // Números y hasta 2 decimales
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryColor,
                  ),
                  decoration:
                      _noBorderDecoration(hint: '0').copyWith(errorText: null)),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ToggleButtons(
                isSelected: [
                  _currentUnit == WeightUnit.kg,
                  _currentUnit == WeightUnit.lbs,
                ],
                onPressed: (index) {
                  // ⭐ Usamos la función _updateUnit corregida ⭐
                  _updateUnit(index == 0 ? WeightUnit.kg : WeightUnit.lbs);
                },
                color: AppTheme.secondaryColor,
                fillColor: Colors.white,
                borderColor: AppTheme.unselected,
                selectedBorderColor: AppTheme.unselected,
                borderRadius: BorderRadius.circular(8),
                borderWidth: 2,
                constraints: BoxConstraints.expand(
                    width: (MediaQuery.of(context).size.width - 48 - 8) / 2,
                    height: 48),
                children: const [
                  Text('kg',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('lbs',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
