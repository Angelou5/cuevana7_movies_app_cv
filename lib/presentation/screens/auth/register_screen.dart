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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  // fila con flecha atrás + título centrado
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
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'El nombre es obligatorio';
                      if (v.trim().length < 2)
                        return 'El nombre debe tener al menos 2 caracteres';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Apellido
                  AppTextField(
                    controller: _lastNameCtrl,
                    hint: 'Apellido',
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'El apellido es obligatorio';
                      if (v.trim().length < 2)
                        return 'El apellido debe tener al menos 2 caracteres';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Correo
                  AppTextField(
                    controller: _emailCtrl,
                    hint: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'El correo es obligatorio';
                      if (!v.contains('@'))
                        return 'Escribe un correo válido, falta el @';
                      if (!v.contains('.'))
                        return 'Escribe un correo válido, falta el dominio';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

<<<<<<< HEAD
                  // Contraseña
                  AppTextField(
                    controller: _passwordCtrl,
                    hint: 'Contraseña',
                    obscureText: _obscurePassword,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'La contraseña es obligatoria';
                      if (v.length < 8)
                        return 'La contraseña debe tener al menos 8 caracteres';
                      if (!RegExp(r'[A-Z]').hasMatch(v))
                        return 'Debe tener una mayúscula';
                      if (!RegExp(r'[a-z]').hasMatch(v))
                        return 'Debe tener una minúscula';
                      if (!RegExp(r'\d').hasMatch(v))
                        return 'Debe tener un número';
                      if (!RegExp(r'[-!@#$%^&*(),.?":{}|<>_]').hasMatch(v))
                        return 'Debe tener un carácter especial';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hint,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
=======
                AppTextField(
                  controller: _emailCtrl,
                  hint: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'El correo es obligatorio';
                    }
                    if (!v.contains('@')) {
                      return 'Escribe un correo válido, falta el @';
                    }
                    if (!v.contains('.')) {
                      return 'Escribe un correo válido, falta el dominio';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _passwordCtrl,
                  hint: 'Contraseña',
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    if (v.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.hint,
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Confirmar contraseña
                  AppTextField(
                    controller: _confirmPasswordCtrl,
                    hint: 'Confirmar Contraseña',
                    obscureText: _obscureConfirm,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Confirma tu contraseña';
                      if (v != _passwordCtrl.text)
                        return 'Las contraseñas no coinciden';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hint,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Botón iniciar sesión
                  PrimaryButton(
                    label: 'Iniciar sesión',
                    isLoading: false,
                    onPressed: () => context.go('/login'),
                  ),

                  const SizedBox(height: 16),

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
    );
  }
}
