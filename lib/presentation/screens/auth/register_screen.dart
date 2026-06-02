import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/resources/styles/styles.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth/auth_provider.dart';

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
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.register(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      name: '${_nameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
    );

    if (!mounted) return;

    if (authProvider.status == AuthStatus.authenticated) {
      context.go('/');
    } else if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.redAccent,
        ),
      );
      authProvider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<AuthProvider>().status == AuthStatus.checking;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                const SizedBox(height: 24),

                // Título
                const Text('Registro de usuario', style: AppStyles.title),

                const SizedBox(height: 32),

                // Nombre
                _AppTextField(
                  controller: _nameCtrl,
                  hint: 'Nombre',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu nombre';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Apellido
                _AppTextField(
                  controller: _lastNameCtrl,
                  hint: 'Apellido',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu apellido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Correo
                _AppTextField(
                  controller: _emailCtrl,
                  hint: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu correo';
                    if (!v.contains('@')) return 'Correo no válido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Contraseña
                _AppTextField(
                  controller: _passwordCtrl,
                  hint: 'Contraseña',
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
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

                // Confirmar contraseña
                _AppTextField(
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

                // Botón registrarse
                _PrimaryButton(
                  label: 'Registrarse',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onRegisterPressed,
                ),

                const SizedBox(height: 24),

                // Separador ¿Ya tienes cuenta?
                _AccountDivider(),

                const SizedBox(height: 24),

                // Botón iniciar sesión
                _PrimaryButton(
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

// ─── Widgets privados ────────────────────────────────────────────────────────

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AppTextField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppStyles.fieldText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.hintField,
        filled: true,
        fillColor: AppColors.inputFill,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dark,
          disabledBackgroundColor: AppColors.dark.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.buttonText,
                  strokeWidth: 2.5,
                ),
              )
            : Text(label, style: AppStyles.buttonLabel),
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 53,
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
        Expanded(
          child: Center(
            child: Text(
              '¿Ya tienes una cuenta?',
              style: AppStyles.dividerLabel,
            ),
          ),
        ),
        const SizedBox(
          width: 53,
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
      ],
    );
  }
}
