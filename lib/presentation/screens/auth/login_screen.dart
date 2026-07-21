import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/resources/styles/styles.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_text_field.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/primary_button.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/applogo.dart';
import '../../../implements/datasources/biometric_datasource_impl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/shared/validators.dart';
import 'package:cuevana7_movies_app_cv/shared/http_utils.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';

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
  RequestError? _error;
  final biometricService = BiometricDatasourceImpl();
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
    try {
      final url = Uri.parse('https://pixonsite.org/signin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailCtrl.text.trim(),
          'password': _passwordCtrl.text,
        }),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];
        await context.read<AuthProvider>().setToken(token);
        const storage = FlutterSecureStorage();
        await storage.write(key: 'saved_email', value: _emailCtrl.text.trim());
        await storage.write(key: 'saved_password', value: _passwordCtrl.text);
        if (!mounted) return;
        context.read<MovieProvider>().loadNowPlaying();
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos xd')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final err = classifyError(e);
      if (err.type == ErrorType.network || err.type == ErrorType.server) {
        setState(() => _error = err);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Función lista para conectar con la API
  Future<void> _onGoogleSignInPressed() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Usar la instancia Singleton (Nuevo estándar de google_sign_in 7.0+)
     // 1. Usar la instancia Singleton (Nuevo estándar)
      final googleSignIn = GoogleSignIn.instance;

      // 2. Inicializar el SDK de Google SOLO con tu clave
      await googleSignIn.initialize(
        serverClientId: '122965167698-gmeepqqqvocvlis9cjq2fmcdl5p2ogha.apps.googleusercontent.com',
      );

      // 3. Invocar la ventana nativa
      final googleUser = await googleSignIn.authenticate();
      
      // Si el usuario le da para atrás o cancela la ventanita flotante

      // 4. Extraemos los datos de autenticación de Google
      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('No se pudo generar el ID Token de Google');
      }

      // 5. Le pegamos a TU backend de Shelf
      final url = Uri.parse('https://pixonsite.org/auth/google');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
        }),
      );

      if (!mounted) return;
      print('Respuesta del servidor: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token']; // El JWT que firmó tu Shelf server

        // 6. Guardamos el token en tu AuthProvider para mantener al usuario autenticado
        await context.read<AuthProvider>().setToken(token);

        // Opcional por si usas persistencia rápida para la huella dactilar
        const storage = FlutterSecureStorage();
        await storage.write(key: 'saved_email', value: googleUser.email);

        if (!mounted) return;
        context.read<MovieProvider>().loadNowPlaying();
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al validar tu cuenta de Google con el servidor $response.statusCode')),
        );
      }

    } catch (e) {
      if (!mounted) return;
      final err = classifyError(e);
      if (err.type == ErrorType.network || err.type == ErrorType.server) {
        setState(() => _error = err);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _authenticateWithFingerprint() async {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      final ok = await biometricService.authenticate();
      if (!mounted) return;
      if (ok) context.go('/');
      return;
    }
    const storage = FlutterSecureStorage();
    final savedEmail = await storage.read(key: 'saved_email');
    final savedPassword = await storage.read(key: 'saved_password');
    if (savedEmail == null || savedPassword == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero inicia sesión con tu correo')),
      );
      return;
    }
    final authenticated = await biometricService.authenticate();
    if (!mounted) return;
    if (!authenticated) return;
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('https://pixonsite.org/signin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': savedEmail, 'password': savedPassword}),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await auth.setToken(data['token']);
        context.read<MovieProvider>().loadNowPlaying();
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión expirada, inicia sesión de nuevo'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final err = classifyError(e);
      if (err.type == ErrorType.network || err.type == ErrorType.server) {
        setState(() => _error = err);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // [TAREA: Espaciado correcto del ícono mostrar/ocultar] — constraints
  // fijas y padding cero en el IconButton, más un margen derecho explícito
  // para que quede a la misma distancia del borde que el texto lo está
  // del borde izquierdo (contentPadding horizontal de AppTextField)
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
          child: _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: ErrorView(
                        error: _error!,
                        onRetry: () => setState(() => _error = null),
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
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
                      const SizedBox(height: 12),

                      // Logo + "Cuevanita" del widget
                      AppLogo(logoSize: 62, textColor: AppColors.white),

                      const SizedBox(height: 16),

                      // Título
                      const Text(
                        'Inicio de sesión',
                        style: AppStyles.title,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Campo correo
                      AppTextField(
                        controller: _emailCtrl,
                        hint: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => validateEmail(v),
                      ),

                      const SizedBox(height: 16),

                      // Campo contraseña
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
                        // [TAREA: Espaciado correcto del ícono mostrar/ocultar]
                        suffixIcon: _visibilityToggle(
                          obscure: _obscurePassword,
                          onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Olvidaste contraseña
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
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
                      ),

                      const SizedBox(height: 32),

                      // Botón iniciar sesión
                      PrimaryButton(
                        label: 'Iniciar sesión',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _onLoginPressed,
                      ),

                      const SizedBox(height: 16),

                      // Botón registrarse
                      PrimaryButton(
                        label: 'Registrarse',
                        isLoading: false,
                        onPressed: () => context.push('/register'),
                      ),

                      const SizedBox(height: 16),

                      // --- SECCIÓN: Divisor "ó" ---
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade600,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'ó',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade600,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // --- SECCIÓN: Botón de Google ---
                      // Nota: Si tu widget 'PrimaryButton' ya soporta íconos, puedes usarlo. 
                      // Si no, este ElevatedButton imita tu estilo visual.
                      PrimaryButton(
                        label: 'Iniciar con Google',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _onGoogleSignInPressed,
                        icon: Container(
                          //decoration: const BoxDecoration(
                            //color: Colors.white,
                            //shape: BoxShape.circle,
                          //),
                          padding: const EdgeInsets.all(6), // Espaciado interno para el círculo blanco
                          child: Image.asset(
                            'assets/images/google.png',
                            height: 24, // Tu asset con la altura que definiste
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Huella dactilar
                      PrimaryButton(
                        label: 'Usar biometría',
                        isLoading: false,
                        onPressed: _authenticateWithFingerprint,
                        icon: Image.asset(
                          'assets/images/huella.png',
                          height: 24,
                        ),
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
