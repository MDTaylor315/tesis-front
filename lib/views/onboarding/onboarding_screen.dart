import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/onboarding/onboarding_camera.dart';
import 'package:adipix/views/onboarding/onboarding_final.dart';
import 'package:adipix/views/onboarding/onboarding_step_age.dart';
import 'package:adipix/views/onboarding/onboarding_step_gender.dart';
import 'package:adipix/views/onboarding/onboarding_step_height.dart';
import 'package:adipix/views/onboarding/onboarding_step_name.dart';
import 'package:adipix/views/onboarding/onboarding_step_weight.dart';
import 'package:flutter/material.dart';

// Enum para los géneros
enum Gender { femenino, masculino, otro }

// Enum para las unidades de altura
enum HeightUnit { cm, ftIn }

// Enum para las unidades de peso
enum WeightUnit { kg, lbs }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 6; // Se corrige a 6 (pasos 0 a 5)

  // ⭐ Variables para almacenar los datos del usuario ⭐
  Gender? _selectedGender;
  DateTime? _dateOfBirth; // ⭐ NUEVA VARIABLE PARA LA FECHA DE NACIMIENTO ⭐
  int? _calculatedAge; // Para almacenar la edad calculada
  double? _height;
  HeightUnit _heightUnit = HeightUnit.cm;
  double? _weight;
  WeightUnit _weightUnit = WeightUnit.kg;
  String _userName = '';
  bool _photoTaken = false;

  // Controla la habilitación del botón "Continuar"
  bool _isCurrentStepValid = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        _validateCurrentStep();
      });
    });
    _validateCurrentStep();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _validateCurrentStep() {
    setState(() {
      switch (_currentPage) {
        case 0: // Género
          _isCurrentStepValid = _selectedGender != null;
          break;
        case 1: // Fecha de Nacimiento
          // Se considera válido si se ha seleccionado una fecha
          _isCurrentStepValid = _dateOfBirth != null;
          break;
        case 2: // Altura
          _isCurrentStepValid = _height != null && _height! > 0;
          break;
        case 3: // Peso
          _isCurrentStepValid = _weight != null && _weight! > 0;
          break;
        case 4: // Nombre
          _isCurrentStepValid = _userName.isNotEmpty;
          break;
        case 5: // ⭐ CÁMARA (NUEVO PASO) ⭐
          _isCurrentStepValid = _photoTaken;
          break;
        default:
          _isCurrentStepValid = false;
      }
    });
  }

  void _nextPage() {
    if (_isCurrentStepValid) {
      // El último paso es el 5 (Cámara)
      if (_currentPage < 5) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      } else {
        // Cuando _currentPage es 5 y es válido (foto tomada), completamos
        _completeOnboarding();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _completeOnboarding() {
    debugPrint('Onboarding Completado:');
    debugPrint('Género: $_selectedGender');
    debugPrint('Edad: $_calculatedAge');
    debugPrint('Altura: $_height $_heightUnit');
    debugPrint('Peso: $_weight $_weightUnit');
    debugPrint('Nombre: $_userName');

    // ⭐ 2. NAVEGACIÓN A ONBOARDING COMPLETION SCREEN ⭐
    // Usamos pushReplacement para reemplazar la pila de onboarding con la pantalla de carga.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OnboardingCompletionScreen(
          onCompletion: () {
            // Este callback se ejecuta después de los 3 segundos de OnboardingCompletionScreen
            if (mounted) {
              // Redirigir a la pantalla principal (reemplaza '/home' con la ruta de tu Home Screen)
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (route) => false);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStepWithButton(Widget stepContent, bool isValid,
      {bool isFinal = false}) {
    // Usamos SingleChildScrollView para que el contenido se ajuste y permita scroll
    // si el teclado o el contenido es muy grande.
    return SingleChildScrollView(
      // Importante: Physics: NeverScrollableScrollPhysics() en PageView
      // y physics: const ClampingScrollPhysics() aquí, es un patrón común
      // para controlar el scroll en PageView.
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // La columna solo ocupa el espacio necesario
        children: [
          // 1. Contenido del paso (Gender, Height, Name, etc.)
          stepContent,

          // 2. El botón de abajo, siempre pegado al contenido
          Padding(
            // Padding superior generoso para separar el contenido del botón.
            // Padding inferior incluye el espacio de seguridad de la pantalla.
            padding: EdgeInsets.fromLTRB(
                24.0, 30.0, 24.0, MediaQuery.of(context).padding.bottom + 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: AppTheme.unselected,
                  //disabledForegroundColor: Colors.white.withOpacity(0.7)
                ),
                child: Text(
                  isFinal ? 'Finalizar' : 'Continuar',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraStep(Widget stepContent) {
    return Column(
      children: [
        // 1. Contenido del paso (OnboardingStepCamera)
        Expanded(child: stepContent),

        // 2. El botón "Finalizar" que aparece después de tomar la foto
        if (_photoTaken)
          Padding(
            padding: EdgeInsets.fromLTRB(
                24.0, 10.0, 24.0, MediaQuery.of(context).padding.bottom + 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCurrentStepValid ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: AppTheme.unselected,
                ),
                child: const Text(
                  'Finalizar', // ⭐ 3. CAMBIAR EL TEXTO A 'Finalizar'
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // Se eliminó el AppBar
      body: Column(
        children: [
          // ⭐ ENCABEZADO PERSONALIZADO EN EL BODY ⭐
          // Lo omitimos si estamos en el paso de la cámara (paso 5),
          // ya que el paso de cámara tiene su propio diseño de UI
          if (_currentPage != 5)
            Padding(
              // El SafeArea y el padding superior simulan el espacio de la AppBar
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de regreso (condicional)
                  _currentPage == 0
                      ? const SizedBox(
                          width: 44) // Espaciador para centrar el logo
                      : OutlinedButton(
                          onPressed: _previousPage,
                          // Estilos compactos para sobrescribir los valores por defecto
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(44, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),

                  // Logo centrado
                  // Se usa un SizedBox.shrink() para el espacio de alineación
                  // si el botón de regreso existe.
                  _currentPage == 0
                      ? const SizedBox(width: 44) // Espaciador si no hay botón
                      : const SizedBox.shrink(),
                ],
              ),
            ),

          // Separador para mayor claridad visual
          if (_currentPage != 5)
            const Divider(height: 1, color: Colors.transparent),

          Expanded(
            // La pantalla de la cámara (paso 5) necesita ocupar todo el espacio
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Paso 0: Género
                _buildStepWithButton(
                  OnboardingStepGender(
                    selectedGender: _selectedGender,
                    onChanged: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                      _validateCurrentStep();
                    },
                  ),
                  _isCurrentStepValid,
                ),
                // Paso 1: Edad
                _buildStepWithButton(
                  OnboardingStepAge(
                    initialDateOfBirth: _dateOfBirth,
                    onChanged: (dob, age) {
                      setState(() {
                        _dateOfBirth = dob;
                        _calculatedAge = age;
                      });
                      _validateCurrentStep();
                    },
                  ),
                  _isCurrentStepValid,
                ),

                // Paso 2: Altura
                _buildStepWithButton(
                  OnboardingStepHeight(
                    initialHeight: _height,
                    initialUnit: _heightUnit,
                    onChanged: (height, unit) {
                      setState(() {
                        _height = height;
                        _heightUnit = unit;
                      });
                      _validateCurrentStep();
                    },
                  ),
                  _isCurrentStepValid,
                ),

                // Paso 3: Peso
                _buildStepWithButton(
                  OnboardingStepWeight(
                    initialWeight: _weight,
                    initialUnit: _weightUnit,
                    onChanged: (weight, unit) {
                      setState(() {
                        _weight = weight;
                        _weightUnit = unit;
                      });
                      _validateCurrentStep();
                    },
                  ),
                  _isCurrentStepValid,
                ),

                // Paso 4: Nombre
                _buildStepWithButton(
                  OnboardingStepName(
                    initialName: _userName,
                    onChanged: (name) {
                      setState(() {
                        _userName = name;
                      });
                      _validateCurrentStep();
                    },
                  ),
                  _isCurrentStepValid,
                ),

                // ⭐ Paso 5: CÁMARA (NUEVO PASO FINAL) ⭐
                _buildCameraStep(
                  OnboardingStepCamera(
                    onChanged: (photoTaken) {
                      setState(() {
                        _photoTaken = photoTaken;
                      });
                      _validateCurrentStep();
                    },
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
