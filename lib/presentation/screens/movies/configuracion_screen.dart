import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'ayuda_screen.dart';
import 'opiniones_screen.dart';
import 'dart:io';
import 'package:cuevana7_movies_app_cv/presentation/providers/profile_picture_provider.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool recibirComentarios = true;
  bool alertasEstrenos = true;
  bool recomendacionesSemanales = true;

  static const Color fondo = Color(0xFF0B1626);
  static const Color fondoItem = Color(0xFF0F1E33);
  static const Color acento = Color(0xFF3AD6D9);
  static const Color textoSecundario = Color(0xFF8C99AC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.20, 1.0],
                colors: [fondo, Color(0xFF060D18)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Configuración',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _PerfilTile(
                            email: 'gaelMovies@gmail.com',
                            subtitulo: 'Ir a perfil, cambiar contraseña, foto de perfil',
                            fondoItem: fondoItem,
                            textoSecundario: textoSecundario,
                          ),
                          const SizedBox(height: 16),
                          _OpcionExpandible(
                            titulo: 'Ayuda',
                            fondoItem: fondoItem,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AyudaScreen()),
                              );
                            },
                          ),
                          _OpcionSwitch(
                            titulo: 'Recibir comentarios',
                            valor: recibirComentarios,
                            acento: acento,
                            fondoItem: fondoItem,
                            onChanged: (v) => setState(() => recibirComentarios = v),
                          ),
                          _OpcionSwitch(
                            titulo: 'Alertas de Estrenos',
                            valor: alertasEstrenos,
                            acento: acento,
                            fondoItem: fondoItem,
                            onChanged: (v) => setState(() => alertasEstrenos = v),
                          ),
                          _OpcionSwitch(
                            titulo: 'Recomendaciones Semanales',
                            valor: recomendacionesSemanales,
                            acento: acento,
                            fondoItem: fondoItem,
                            onChanged: (v) => setState(() => recomendacionesSemanales = v),
                          ),
                          _OpcionExpandible(
                            titulo: 'Comentarios',
                            fondoItem: fondoItem,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const OpinionesScreen()),
                              );
                            },
                          ),
                          _OpcionTexto(
                            titulo: 'Versión de la aplicación',
                            valor: '1.0.0.6.7',
                            fondoItem: fondoItem,
                            textoSecundario: textoSecundario,
                          ),
                          _OpcionIcono(
                            titulo: 'Cerrar sesión',
                            icono: Icons.logout,
                            fondoItem: fondoItem,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  backgroundColor: fondoItem,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          '¿Cerrar sesión?',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Se cerrará tu sesión actual y volverás al login.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: textoSecundario,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.of(ctx).pop();
                                                await context.read<AuthProvider>().logout();
                                                if (context.mounted) context.go('/login');
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: acento,
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: const Text(
                                                  'Sí, cerrar',
                                                  style: TextStyle(
                                                    color: Color(0xFF0B1626),
                                                    fontSize: 14,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: () => Navigator.of(ctx).pop(),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF1A3350),
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: const Text(
                                                  'Cancelar',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: acento,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Eliminar cuenta',
                                  style: TextStyle(
                                    color: Color(0xFF0B1626),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 110),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: BottomNavBar(activeTab: NavTab.profile, isVisible: true),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfilTile extends StatelessWidget {
  final String email;
  final String subtitulo;
  final Color fondoItem;
  final Color textoSecundario;

  const _PerfilTile({
    required this.email,
    required this.subtitulo,
    required this.fondoItem,
    required this.textoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios del provider de foto de perfil
    final profileProvider = context.watch<ProfilePictureProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: fondoItem,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // --- AVATAR CON SIMULACIÓN DE SUBIDA ---
            GestureDetector(
              onTap: profileProvider.isUploading
                  ? null
                  : () => profileProvider.changeProfilePicture(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white24,
                    backgroundImage: profileProvider.storedProfilePicture != null
                        ? FileImage(profileProvider.storedProfilePicture!)
                        : null,
                    child: profileProvider.storedProfilePicture == null && !profileProvider.isUploading
                        ? const Icon(Icons.person, color: Colors.white70, size: 26)
                        : null,
                  ),
                  // Muestra el spinner mientras simula la subida de 2 segundos
                  if (profileProvider.isUploading)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF3AD6D9), // Color de acento
                        ),
                      ),
                    ),
                  // Badge / Icono de la camarita en la esquina
                  if (!profileProvider.isUploading)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3AD6D9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 10,
                          color: Color(0xFF0B1626),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profileProvider.isUploading
                        ? 'Simulando subida al servidor...'
                        : subtitulo,
                    style: TextStyle(
                      color: profileProvider.isUploading
                          ? const Color(0xFF3AD6D9)
                          : textoSecundario,
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _OpcionExpandible extends StatelessWidget {
  final String titulo;
  final Color fondoItem;
  final VoidCallback onTap;

  const _OpcionExpandible({
    required this.titulo,
    required this.fondoItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: fondoItem,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(top: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat')),
          ],
        ),
      ),
    );
  }
}

class _OpcionSwitch extends StatelessWidget {
  final String titulo;
  final bool valor;
  final Color acento;
  final Color fondoItem;
  final ValueChanged<bool> onChanged;

  const _OpcionSwitch({
    required this.titulo,
    required this.valor,
    required this.acento,
    required this.fondoItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fondoItem,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat')),
          Switch(
            value: valor,
            activeThumbColor: acento,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _OpcionTexto extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color fondoItem;
  final Color textoSecundario;

  const _OpcionTexto({
    required this.titulo,
    required this.valor,
    required this.fondoItem,
    required this.textoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fondoItem,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat')),
          Text(valor, style: TextStyle(color: textoSecundario, fontSize: 13, fontFamily: 'Montserrat')),
        ],
      ),
    );
  }
}

class _OpcionIcono extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color fondoItem;
  final VoidCallback onTap;

  const _OpcionIcono({
    required this.titulo,
    required this.icono,
    required this.fondoItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: fondoItem,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(top: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat')),
            Icon(icono, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}
