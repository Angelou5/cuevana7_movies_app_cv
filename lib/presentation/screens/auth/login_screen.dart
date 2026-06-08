import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/resources/styles/styles.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_text_field.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/primary_button.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/or_divider.dart';
import '../../../services/biometric_service.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'login-screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final biometricService = BiometricService();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  Future<void> _authenticateWithFingerprint() async {
    final authenticated = await biometricService.authenticate();
    if (!mounted) return;
    if (authenticated) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Autenticación cancelada o fallida')),
      );
    }
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
                const SizedBox(height: 40),

                Center(child: _Logo()),

                const SizedBox(height: 24),

                const Text('Inicio de sesión', style: AppStyles.title),

                const SizedBox(height: 32),

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

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '¿Olvidaste la contraseña?',
                    style: AppStyles.forgotPassword,
                  ),
                ),

                const SizedBox(height: 36),

                PrimaryButton(
                  label: 'Iniciar sesión',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _onLoginPressed,
                ),

                const SizedBox(height: 24),

                const OrDivider(),

                const SizedBox(height: 24),

                PrimaryButton(
                  label: 'Registrarse',
                  isLoading: false,
                  onPressed: () => context.push('/register'),
                ),

                const SizedBox(height: 24),

                Center(
                  child: GestureDetector(
                    onTap: _authenticateWithFingerprint,//dedo
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.hint, width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset('assets/images/huella.png'),
                      ),
                    ),
                  ),
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

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/images/logo.png', width: 62, height: 62),
          const SizedBox(height: 8),
          const Text(
            'Cuevana 7',
            style: TextStyle(
              fontFamily: 'InclusiveSans',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
