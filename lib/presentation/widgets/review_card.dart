import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';

class ReviewCard extends StatefulWidget {
  final MovieReview movieReview;
  const ReviewCard({super.key, required this.movieReview});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.movieReview.review;
    final starRating = review.rating != null ? (review.rating! / 2).round() : 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B).withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar circular con borde blanco
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movieReview.movieTitle,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontFamily: 'InclusiveSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  review.author,
                  style: const TextStyle(
                    color: AppColors.hint,
                    fontSize: 11,
                    fontFamily: 'InclusiveSans',
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < starRating ? Icons.star : Icons.star_border,
                      color: AppColors.white,
                      size: 14,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  review.content,
                  maxLines: _isExpanded ? null : 2,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: 'InclusiveSans',
                    height: 1.5,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(
                    _isExpanded ? 'Leer menos' : 'Leer más',
                    style: const TextStyle(
                      color: AppColors.hint,
                      fontSize: 12,
                      fontFamily: 'InclusiveSans',
                      fontWeight: FontWeight.w600,
                    ),
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
