import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Hero(
                    tag: 'app-logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 36,
                      height: 36,
                    ),
                  ),
                  const SizedBox(width: 10),

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
                          Icon(Icons.search, color: AppColors.hint, size: 20),
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
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Géneros populares',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontFamily: 'InclusiveSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _GenreChip(label: 'Terror'),
                  const SizedBox(width: 8),
                  _GenreChip(label: 'Comedia'),
                  const SizedBox(width: 8),
                  _GenreChip(label: 'Suspenso'),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.hint,
                    size: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Novedades',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontFamily: 'InclusiveSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _MovieCard(),
                  const SizedBox(width: 10),
                  _MovieCard(),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.hint,
                    size: 22,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Opiniones',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontFamily: 'InclusiveSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ReviewCard(rating: 4),
                  const SizedBox(height: 10),
                  _ReviewCard(rating: 5),
                ],
              ),
            ),

            const Spacer(),

            Container(
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
                  Icon(
                    Icons.bookmark_border,
                    color: AppColors.buttonText,
                    size: 26,
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: AppColors.buttonText,
                    size: 26,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _MovieCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

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
          // Avatar
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
                // Estrellas
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
