import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importación de HeightUnit asumida desde onboarding_screen.dart para evitar el error anterior

class OnboardingStepHeight extends StatefulWidget {
  final double? initialHeight; // Altura en la unidad primaria (cm)
  final HeightUnit initialUnit;
  final Function(double?, HeightUnit) onChanged;

  const OnboardingStepHeight({
    super.key,
    required this.initialHeight,
    required this.initialUnit,
    required this.onChanged,
  });

  @override
  State<OnboardingStepHeight> createState() => _OnboardingStepHeightState();
}

class _OnboardingStepHeightState extends State<OnboardingStepHeight> {
  final TextEditingController _cmController = TextEditingController();
  final TextEditingController _ftController = TextEditingController();
  final TextEditingController _inController = TextEditingController();

  HeightUnit _selectedUnit = HeightUnit.cm;
  String? _errorText; // Para mostrar errores de validación

  // ⭐ RANGOS DE VALIDACIÓN ⭐
  static const double _minHeightCm = 50; // 50 cm
  static const double _maxHeightCm = 250; // 250 cm

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.initialUnit;

    // Inicializar los controladores con el valor inicial
    if (widget.initialHeight != null) {
      if (_selectedUnit == HeightUnit.cm) {
        _cmController.text = widget.initialHeight!.round().toString();
      } else {
        final double totalInches = widget.initialHeight! / 2.54;
        final int feet = (totalInches / 12).floor();
        // Las pulgadas se toman como el resto de la división
        final int inches = (totalInches % 12).round();
        _ftController.text = feet.toString();
        _inController.text = inches.toString();
      }
    }

    _cmController.addListener(_validateAndNotify);
    _ftController.addListener(_validateAndNotify);
    _inController.addListener(_validateAndNotify);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateAndNotify();
    });
  }

  @override
  void dispose() {
    _cmController.dispose();
    _ftController.dispose();
    _inController.dispose();
    super.dispose();
  }

  double? _calculateTotalCm() {
    if (_selectedUnit == HeightUnit.cm) {
      final cm = int.tryParse(_cmController.text);
      return cm != null && cm > 0 ? cm.toDouble() : null;
    } else {
      final feet = int.tryParse(_ftController.text) ?? 0;
      final inches = int.tryParse(_inController.text) ?? 0;

      if (feet == 0 && inches == 0) return null;

      // ⭐ VALIDACIÓN DE PULGADAS: NO DEBEN EXCEDER 11 ⭐
      if (inches > 11) {
        // No lanzamos una excepción aquí, solo permitimos la conversión
        // y dejamos que la validación del rango (en _validateAndNotify) capture el error.
        // Alternativamente, podrías forzar el límite aquí y notificar un error específico.
        // Por simplicidad en la UI, lo manejamos como un error de rango.
      }

      final totalInches = (feet * 12) + inches;
      return totalInches * 2.54;
    }
  }

  void _validateAndNotify() {
    final double? totalCm = _calculateTotalCm();
    String? currentError;

    // Verificar si la entrada está vacía (feet=0, inches=0)
    final bool isEmpty =
        (_selectedUnit == HeightUnit.cm && _cmController.text.isEmpty) ||
            (_selectedUnit == HeightUnit.ftIn &&
                _ftController.text.isEmpty &&
                _inController.text.isEmpty);

    if (isEmpty) {
      currentError = null; // No hay error si no hay nada ingresado.
    }
    // Si hay un valor calculado...
    else if (totalCm != null) {
      // 1. Validar que la altura esté en el rango realista
      if (_selectedUnit == HeightUnit.cm &&
          (totalCm < _minHeightCm || totalCm > _maxHeightCm)) {
        currentError =
            'La altura debe estar entre ${_minHeightCm.round()}cm y ${_maxHeightCm.round()}cm.';
      }

      // 2. Validaciones específicas para ft & in
      else if (_selectedUnit == HeightUnit.ftIn) {
        final feet = int.tryParse(_ftController.text) ?? 0;
        final inches = int.tryParse(_inController.text) ?? 0;

        // ⭐ NUEVA VALIDACIÓN: Límite para el campo de pies ⭐
        if (feet > 8) {
          currentError = 'El valor en pies es demasiado alto (máximo 8ft).';
        }

        // 3. Validar que las pulgadas no excedan 11
        else if (inches > 11) {
          currentError = 'Las pulgadas no pueden ser mayores a 11.';
        }
      }
    }
    // Si totalCm es null, pero la entrada NO está vacía, significa que hay texto no numérico o 0/0.
    // Esto ya lo cubre isEmpty y totalCm != null, así que el caso es manejado.

    setState(() {
      _errorText = currentError;
    });

    // Solo notificamos al padre si la validación es exitosa
    if (currentError == null && totalCm != null) {
      widget.onChanged(totalCm, _selectedUnit);
    } else {
      // Si hay error o no hay entrada válida (aunque no sea 0/0), notificamos null
      widget.onChanged(null, _selectedUnit);
    }
  }

  void _setUnit(HeightUnit unit) {
    if (unit == _selectedUnit) return;

    setState(() {
      _selectedUnit = unit;
      // Recalcular y validar al cambiar de unidad
    });
    _validateAndNotify();
  }

  // ... (métodos _buildUnitButton, _noBorderDecoration, _buildUnitLabel sin cambios)

  // Estilo genérico de InputDecoration para eliminar bordes
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

  // Widget para la unidad de medida (ft o in)
  Widget _buildUnitLabel(String unit, {double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: bottomPadding, left: 10), // Aplicamos el padding aquí
      child: Text(
        unit,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppTheme.secondaryColor.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildUnitButton(HeightUnit unit, String text) {
    final bool isSelected = _selectedUnit == unit;
    return Expanded(
      child: GestureDetector(
        onTap: () => _setUnit(unit),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : AppTheme.unselected,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            border: isSelected
                ? Border.all(color: AppTheme.unselected, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
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
            '¿Cuánto mides?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          // Dejamos 80px de espacio
          const SizedBox(height: 80),

          // ⭐ ZONA DE ENTRADA DE ALTURA (Condicional) ⭐
          Center(
            // El errorText se maneja dentro de _noBorderDecoration,
            // pero si hay error, queremos mostrarlo debajo de los campos.
            child: Column(
              children: [
                _selectedUnit == HeightUnit.cm
                    ? _buildCmInput()
                    : _buildFtInInput(),

                // ⭐ Mostrar el error una sola vez debajo de los campos ⭐
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
              ],
            ),
          ),

          SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.unselected,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildUnitButton(HeightUnit.cm, 'cm'),
                _buildUnitButton(HeightUnit.ftIn, 'ft & in'),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Widget para entrada en Centímetros
  Widget _buildCmInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // CrossAxisAlignment.end es correcto para alinear en la parte inferior
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Campo de entrada de CM (IntrinsicWidth está bien)
        IntrinsicWidth(
          child: TextField(
            controller: _cmController,
            // ... (otros parámetros del TextField sin cambios)
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryColor,
            ),
            decoration:
                _noBorderDecoration(hint: '0').copyWith(errorText: null),
          ),
        ),
        // ⭐ MODIFICADO: Aplicar padding inferior para la alineación. ⭐
        _buildUnitLabel('cm', bottomPadding: 16.0),
      ],
    );
  }

  // Widget para entrada en Pies y Pulgadas
  Widget _buildFtInInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. Entrada de Pies (ft)
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _ftController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1)
                  ],
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryColor,
                  ),
                  // ⭐ NO USAMOS errorText aquí, lo mostramos fuera del TextField ⭐
                  decoration:
                      _noBorderDecoration(hint: '0').copyWith(errorText: null),
                ),
              ),
              _buildUnitLabel('ft', bottomPadding: 16.0),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // 2. Entrada de Pulgadas (in)
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _inController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryColor,
                  ),
                  // ⭐ NO USAMOS errorText aquí, lo mostramos fuera del TextField ⭐
                  decoration:
                      _noBorderDecoration(hint: '0').copyWith(errorText: null),
                ),
              ),
              _buildUnitLabel('in', bottomPadding: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}
