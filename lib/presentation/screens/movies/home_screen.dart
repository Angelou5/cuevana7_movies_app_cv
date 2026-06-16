import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ── Bottom Navigation Bar fijo
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.dark,
          border: Border(
            top: BorderSide(color: AppColors.inputFill, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: AppColors.buttonText, size: 26),
            Icon(Icons.bookmark_border, color: AppColors.buttonText, size: 26),
            Icon(Icons.favorite_border, color: AppColors.buttonText, size: 26),
          ],
        ),
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Título "Home"
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: AppColors.hint,
                        fontSize: 15,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // ── Barra de búsqueda y logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Search bar
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 14),
                                Icon(
                                  Icons.search,
                                  color: AppColors.hint,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Buscar',
                                  style: TextStyle(
                                    color: AppColors.hint,
                                    fontSize: 16,
                                    fontFamily: 'InclusiveSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Logo pequeño
                        Hero(
                          tag: 'app-logo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Banner hero / carrusel principal
                  _HeroBanner(),

                  const SizedBox(height: 16),

                  // ── Sección: Géneros populares
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Géneros populares',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Chips de géneros con scroll horizontal
                  _GenreChipsRow(),

                  const SizedBox(height: 20),

                  // ── Sección: Novedades (carrusel horizontal)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Novedades',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MovieCarousel(),

                  const SizedBox(height: 20),

                  // ── Sección: Para ver en familia
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Para ver en familia',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _HeroBanner(),

                  const SizedBox(height: 20),

                  // ── Sección: Infantiles
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Infantiles',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MovieCarousel(),

                  const SizedBox(height: 20),

                  // ── Sección: Historias biográficas
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Historias biográficas',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MovieCarousel(),

                  const SizedBox(height: 20),

                  // ── Sección: Para ver en familia
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Para ver en familia',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _HeroBanner(),

                  const SizedBox(height: 20),

                  // ── Sección: Opiniones
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Opiniones',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Lista de reviews
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _ReviewCard(rating: 4),
                        const SizedBox(height: 10),
                        _ReviewCard(rating: 4),
                        const SizedBox(height: 10),
                        _ReviewCard(rating: 4),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Banner hero
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFB22222),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// ── Chips de géneros con scroll horizontal
class _GenreChipsRow extends StatelessWidget {
  final List<String> genres = const ['Acsi', 'Comedia', 'Romance', 'Acción'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: genres.map((g) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _GenreChip(label: g),
          );
        }).toList(),
      ),
    );
  }
}

// ── Chip individual de género
class _GenreChip extends StatelessWidget {
  final String label;
  const _GenreChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.buttonText,
          fontSize: 12,
          fontFamily: 'InclusiveSans',
        ),
      ),
    );
  }
}

// ── Carrusel horizontal de películas con fade en los bordes
class _MovieCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // Difuminado en los bordes izquierdo y derecho
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white,
          Colors.white,
          Colors.transparent,
        ],
        stops: [0.0, 0.08, 0.92, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        height: 130,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            // Card placeholder de película
            return Container(
              width: 90,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Card de opinión / review
class _ReviewCard extends StatelessWidget {
  final int rating;
  const _ReviewCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar circular
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hint, width: 1.5),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.hint,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estrellas de calificación
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: AppColors.dark,
                      size: 14,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                // Texto de la reseña
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc gravida sagittis tempus.',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 12,
                    fontFamily: 'InclusiveSans',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
