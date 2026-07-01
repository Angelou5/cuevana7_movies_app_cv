import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/resources/styles/styles.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_text_field.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/primary_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  static const name = 'register-screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // ---- Regex de apoyo ----
  static final RegExp _nameFirstUpper = RegExp(r'^[A-ZÁÉÍÓÚÑ]');
  static final RegExp _nameRestLower = RegExp(r'^.[a-záéíóúñ]*$');
  static final RegExp _hasNumber = RegExp(r'\d');
  static final RegExp _emailDomainValido = RegExp(
    r'^[^\s@]+@[^\s@]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _hasUpper = RegExp(r'[A-Z]');
  static final RegExp _hasLower = RegExp(r'[a-z]');
  static final RegExp _hasSpecial = RegExp(r'[-!@#$%^&*(),.?":{}|<>_]');

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_refresh);
    _lastNameCtrl.addListener(_refresh);
    _emailCtrl.addListener(_refresh);
    _passwordCtrl.addListener(_refresh);
    _confirmPasswordCtrl.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _nameCtrl.removeListener(_refresh);
    _lastNameCtrl.removeListener(_refresh);
    _emailCtrl.removeListener(_refresh);
    _passwordCtrl.removeListener(_refresh);
    _confirmPasswordCtrl.removeListener(_refresh);
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  String? _validateNameField(String? v, {required String campo}) {
    if (v == null || v.isEmpty) return '$campo es obligatorio';
    if (v.trim().length < 2) return '$campo debe tener al menos 2 caracteres';
    if (_hasNumber.hasMatch(v)) return '$campo no debe tener números';
    if (!_nameFirstUpper.hasMatch(v)) {
      return '$campo debe empezar con mayúscula';
    }
    if (!_nameRestLower.hasMatch(v)) {
      return 'Solo la primera letra de $campo va en mayúscula';
    }
    return null;
  }

  String? _validateEmailField(String? v) {
    if (v == null || v.isEmpty) return 'El correo es obligatorio';
    if (!v.contains('@')) return 'Escribe un correo válido, falta el @';
    if (!_emailDomainValido.hasMatch(v)) {
      return 'Escribe un correo válido, falta un dominio (ej. .com)';
    }
    return null;
  }

  String? _validatePasswordField(String? v) {
    if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
    if (v.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
    if (!_hasUpper.hasMatch(v)) return 'Debe tener una mayúscula';
    if (!_hasLower.hasMatch(v)) return 'Debe tener una minúscula';
    if (!_hasNumber.hasMatch(v)) return 'Debe tener un número';
    if (!_hasSpecial.hasMatch(v)) return 'Debe tener un carácter especial';
    return null;
  }

  String? _validateConfirmField(String? v) {
    if (v == null || v.isEmpty) return 'Confirma tu contraseña';
    if (v != _passwordCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }

  void _onRegisterPressed() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('https://pixonsite.org/signup');
      final fullName = '${_nameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}';
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': fullName,
          'email': _emailCtrl.text.trim(),
          'password': _passwordCtrl.text,
        }),
      );
      if (!mounted) return;
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );
        context.go('/login');
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Error al registrar xd')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // [TAREA: Espaciado correcto del ícono mostrar/ocultar] — constraints
  // fijas y padding cero en el IconButton, más un margen derecho explícito
  // para que quede a la misma distancia del borde que el texto lo está
  // del borde izquierdo (mismo patrón que Login para consistencia visual)
  Widget _visibilityToggle({
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        splashRadius: 20,
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.hint,
          size: 22,
        ),
        onPressed: onToggle,
      ),
    );
  }

  // ------- Widget de checklist en vivo -------

  Widget _requirement(String text, bool satisfied) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            satisfied ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: satisfied ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: satisfied
                    ? Colors.greenAccent
                    : Colors.redAccent.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameChecklist(String value, String campo) {
    if (value.isEmpty) return const SizedBox.shrink();
    final startsUpper = _nameFirstUpper.hasMatch(value);
    final restLower = _nameRestLower.hasMatch(value);
    final noNumbers = !_hasNumber.hasMatch(value);
    final minLength = value.trim().length >= 2;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _requirement('Empieza con mayúscula', startsUpper),
          _requirement('Resto en minúsculas', restLower),
          _requirement('Sin números', noNumbers),
          _requirement('Mínimo 2 caracteres', minLength),
        ],
      ),
    );
  }

  Widget _emailChecklist(String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    final hasAt = value.contains('@');
    final hasValidDomain = _emailDomainValido.hasMatch(value);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _requirement('Contiene @', hasAt),
          _requirement('Dominio válido (ej. .com, .mx)', hasValidDomain),
        ],
      ),
    );
  }

  Widget _passwordChecklist(String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _requirement('Mínimo 8 caracteres', value.length >= 8),
          _requirement('Al menos una mayúscula', _hasUpper.hasMatch(value)),
          _requirement('Al menos una minúscula', _hasLower.hasMatch(value)),
          _requirement('Al menos un número', _hasNumber.hasMatch(value)),
          _requirement(
            'Al menos un carácter especial',
            _hasSpecial.hasMatch(value),
          ),
        ],
      ),
    );
  }

  Widget _confirmChecklist(String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    final matches = value == _passwordCtrl.text;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: _requirement('Coincide con la contraseña', matches),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.53, 1.0],
            colors: [AppColors.background, AppColors.dark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              // [TAREA: Responsividad] — limita el ancho máximo en
              // pantallas grandes (tablets/desktop)
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const Text('Registro', style: AppStyles.title),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Nombre
                      AppTextField(
                        controller: _nameCtrl,
                        hint: 'Nombre',
                        validator: (v) =>
                            _validateNameField(v, campo: 'El nombre'),
                      ),
                      _nameChecklist(_nameCtrl.text, 'El nombre'),

                      const SizedBox(height: 16),

                      // Apellido
                      AppTextField(
                        controller: _lastNameCtrl,
                        hint: 'Apellido',
                        validator: (v) =>
                            _validateNameField(v, campo: 'El apellido'),
                      ),
                      _nameChecklist(_lastNameCtrl.text, 'El apellido'),

                      const SizedBox(height: 16),

                      // Correo
                      AppTextField(
                        controller: _emailCtrl,
                        hint: 'Correo Electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmailField,
                      ),
                      _emailChecklist(_emailCtrl.text),

                      const SizedBox(height: 16),

                      // Contraseña
                      AppTextField(
                        controller: _passwordCtrl,
                        hint: 'Contraseña',
                        obscureText: _obscurePassword,
                        validator: _validatePasswordField,
                        // [TAREA: Espaciado correcto del ícono mostrar/ocultar]
                        suffixIcon: _visibilityToggle(
                          obscure: _obscurePassword,
                          onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      _passwordChecklist(_passwordCtrl.text),

                      const SizedBox(height: 16),

                      // Confirmar contraseña
                      AppTextField(
                        controller: _confirmPasswordCtrl,
                        hint: 'Confirmar Contraseña',
                        obscureText: _obscureConfirm,
                        validator: _validateConfirmField,
                        // [TAREA: Espaciado correcto del ícono mostrar/ocultar]
                        suffixIcon: _visibilityToggle(
                          obscure: _obscureConfirm,
                          onToggle: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                      _confirmChecklist(_confirmPasswordCtrl.text),

                      const SizedBox(height: 36),

                      // Botón registrarse
                      PrimaryButton(
                        label: 'Registrarse',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _onRegisterPressed,
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
