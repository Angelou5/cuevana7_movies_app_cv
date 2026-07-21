import 'package:flutter/material.dart';

class OpinionesScreen extends StatelessWidget {
  const OpinionesScreen({super.key});

  static const Color fondo = Color(0xFF0B1626);
  static const Color fondoCard = Color(0xFF122642);
  static const Color borde = Color(0xFF2E6E8E);
  static const Color textoSecundario = Color(0xFF8C99AC);

  @override
  Widget build(BuildContext context) {
    final resenas = List.generate(
      5,
      (index) => const _Resena(
        usuario: '@GaelPandaMovie67',
        calificacion: 4,
        tiempo: 'Hace 4h',
        comentario:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc gravida sagittis tempus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc sagittis tempus.',
      ),
    );

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
                      'Opiniones',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Más recientes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: resenas.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) => resenas[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Resena extends StatelessWidget {
  final String usuario;
  final int calificacion;
  final String tiempo;
  final String comentario;

  const _Resena({
    required this.usuario,
    required this.calificacion,
    required this.tiempo,
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OpinionesScreen.fondoCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OpinionesScreen.borde, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white70, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < calificacion ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tiempo,
                      style: const TextStyle(
                        color: OpinionesScreen.textoSecundario,
                        fontSize: 11,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comentario,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
