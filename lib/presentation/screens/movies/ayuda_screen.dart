import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  static const Color fondo = Color(0xFF0B1626);
  static const Color fondoItem = Color(0xFF122642);
  static const Color borde = Color(0xFF2E6E8E);

  @override
  Widget build(BuildContext context) {
    final opciones = const [
      'Reportes o fallas',
      'Contenido de la App',
      'Preguntas frecuentes',
      'Contactar soporte técnico',
    ];

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Ayuda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: opciones.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _OpcionAyuda(titulo: opciones[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionAyuda extends StatelessWidget {
  final String titulo;

  const _OpcionAyuda({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AyudaScreen.fondoItem,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AyudaScreen.borde, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat'),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
