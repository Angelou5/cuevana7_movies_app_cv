import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/resources/styles/styles.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_text_field.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/primary_button.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/account_divider.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.dark,
                    size: 22,
                  ),
                ),

                const SizedBox(height: 16),

                const Text('Registro de usuario', style: AppStyles.title),

                const SizedBox(height: 32),

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

                AppTextField(
                  controller: _emailCtrl,
                  hint: 'Correo electrónico',
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

                AppTextField(
                  controller: _passwordCtrl,
                  hint: 'Contraseña',
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'La contraseña es obligatoria';
                    if (v.length < 6)
                      return 'La contraseña debe tener al menos 6 caracteres';
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
                  ),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _confirmPasswordCtrl,
                  hint: 'Confirmar contraseña',
                  obscureText: _obscureConfirm,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirma tu contraseña';
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

                PrimaryButton(
                  label: 'Registrarse',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _onRegisterPressed,
                ),

                const SizedBox(height: 24),

                const AccountDivider(),

                const SizedBox(height: 24),

                PrimaryButton(
                  label: 'Iniciar sesión',
                  isLoading: false,
                  onPressed: () => context.go('/login'),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
