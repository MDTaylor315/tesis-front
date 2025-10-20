import 'package:adipix/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class OnboardingStepAge extends StatefulWidget {
  final DateTime? initialDateOfBirth;
  final Function(DateTime?, int?) onChanged;

  const OnboardingStepAge({
    super.key,
    required this.initialDateOfBirth,
    required this.onChanged,
  });

  @override
  State<OnboardingStepAge> createState() => _OnboardingStepAgeState();
}

class _OnboardingStepAgeState extends State<OnboardingStepAge> {
  final TextEditingController _dateController = TextEditingController();

  // MÁSCARA: Permanece con espacios para la entrada de datos.
  final _maskFormatter = MaskTextInputFormatter(
    mask: '## ## ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  DateTime? _selectedDate;
  int? _age;
  String? _errorText;

  static const int _minRequiredAge = 15;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateOfBirth;

    if (_selectedDate != null) {
      _dateController.text = _formatDateToString(_selectedDate!);
      _age = _calculateAge(_selectedDate!);
    }

    _dateController.addListener(_validateAndNotify);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateAndNotify();
    });
  }

  @override
  void dispose() {
    _dateController.removeListener(_validateAndNotify);
    _dateController.dispose();
    super.dispose();
  }

  // Formateador usa espacios, coincidiendo con la máscara.
  String _formatDateToString(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day $month $year';
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (age < 0) return 0;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _validateAndNotify() {
    final rawText = _dateController.text;
    DateTime? validatedDate;
    int? calculatedAge;
    String? currentError;

    if (rawText.length < _maskFormatter.getMask()!.length) {
      currentError = null;
    } else {
      try {
        // La lógica de división sigue usando el espacio.
        final parts = rawText.trim().split(' ');
        if (parts.length != 3 || parts.any((p) => p.isEmpty)) {
          throw FormatException('Formato de fecha incompleto.');
        }

        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);

        validatedDate = DateTime(year, month, day);

        if (validatedDate.isAfter(DateTime.now())) {
          throw FormatException('La fecha no puede ser futura.');
        }

        calculatedAge = _calculateAge(validatedDate);
        if (calculatedAge < _minRequiredAge) {
          throw FormatException('Debes tener al menos $_minRequiredAge años.');
        }

        if (calculatedAge > 120) {
          throw FormatException('Edad no válida.');
        }
      } on FormatException catch (e) {
        currentError = e.message;
        validatedDate = null;
        calculatedAge = null;
      } catch (_) {
        currentError = 'Fecha inválida';
        validatedDate = null;
        calculatedAge = null;
      }
    }

    setState(() {
      _selectedDate = validatedDate;
      _age = calculatedAge;
      _errorText = currentError;
    });

    widget.onChanged(_selectedDate, _age);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppTheme.secondaryColor;

    final String ageDisplay =
        (_age != null && _selectedDate != null) ? '$_age años' : 'Edad';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Cuándo naciste?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _dateController,
                    inputFormatters: [_maskFormatter],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      // Aquí NO usamos letterSpacing: 2
                    ),
                    decoration: InputDecoration(
                      // ⭐ CAMBIO CLAVE: Usamos la cadena literal con guiones ⭐
                      hintText: 'DD MM AAAA',
                      hintStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: primaryColor.withOpacity(0.3),
                      ),
                      // Eliminar todos los bordes
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,

                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      errorText: _errorText,
                      errorStyle:
                          const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ageDisplay,
                  style: TextStyle(
                    fontSize: 16,
                    color: (_age != null)
                        ? primaryColor.withOpacity(0.7)
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
