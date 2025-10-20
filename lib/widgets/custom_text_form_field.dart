import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String title; // Título superior del campo
  final String labelText; // Label dentro del campo
  final String? hintText; // Hint opcional (ej: 'Ej: Juan Pérez')
  final TextEditingController controller; // Controlador del campo
  final bool isPassword; // Si es true, oculta el texto como contraseña
  final bool enabled; // Opcional: si el campo está habilitado (default: true)
  final TextInputType? keyboardType;
  final String? Function(String?)? validator; // Nuevo: Validador opcional

  const CustomTextFormField({
    super.key,
    required this.title,
    required this.labelText,
    required this.controller,
    this.hintText,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType,
    this.validator, // Nuevo: Parámetro para validador
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText =
      true; // Estado para controlar la visibilidad de la contraseña

  @override
  void initState() {
    super.initState();
    // Inicializar _obscureText basado en si es un campo de contraseña
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título superior
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Campo de texto
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword
              ? _obscureText
              : false, // Oculta solo si es contraseña y _obscureText es true
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          validator: widget.validator ??
              _getDefaultValidator(widget.keyboardType ??
                  TextInputType
                      .none), // Nuevo: Pasar el validador al TextFormField
          decoration: InputDecoration(
            labelText: widget.labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: widget.hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xFFD6DEE5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.red),
            ),
            errorStyle: TextStyle(color: Colors.red),
            // Suffix icon solo si es campo de contraseña
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color(
                          0xFFD6DEE5), // Color similar al border para consistencia
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Toggle visibilidad
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  String? Function(String?)? _getDefaultValidator(TextInputType type) {
    switch (type) {
      case TextInputType.emailAddress:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu correo electrónico';
          }
          if (!_isValidEmail(value)) {
            return 'Por favor ingresa un correo válido';
          }
          return null;
        };
      case TextInputType.phone:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu número de teléfono';
          }
          if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(value)) {
            return 'Número inválido';
          }
          return null;
        };
      case TextInputType.number:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa un número';
          }
          if (double.tryParse(value) == null) {
            return 'Debe ser un número válido';
          }
          return null;
        };
      default:
        return (value) {
          if (value == null || value.isEmpty) return 'Este campo es requerido';
          return null; // Solo required para texto genérico
        };
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
