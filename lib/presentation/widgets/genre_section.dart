import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';

class GenreSection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;
  const GenreSection({super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: movies.isEmpty
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) =>
                      MovieCard(movie: movies[index]),
                ),
        ),
      ],
    );
  }
}
