import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user_review.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/user_reviews_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_snackbar.dart';

/// Card que muestra la reseña propia del usuario con opciones de editar/borrar.
class UserReviewCard extends StatelessWidget {
  final UserReview review;
  final VoidCallback onEdit;

  const UserReviewCard({
    super.key,
    required this.review,
    required this.onEdit,
  });

  String _fmtDiff(Duration d) {
    if (d.inDays > 0) return 'Hace ${d.inDays}d';
    if (d.inHours > 0) return 'Hace ${d.inHours}h';
    if (d.inMinutes > 0) return 'Hace ${d.inMinutes}m';
    return 'Ahora';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Eliminar reseña?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'InclusiveSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(dialogContext).pop();
                      final provider =
                          context.read<UserReviewsProvider>();
                      final ok = await provider.deleteReview(review.id);
                      if (!context.mounted) return;
                      if (!ok) {
                        showErrorSnackBar(
                          context,
                          'No se pudo eliminar la reseña',
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB94040),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3C),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'InclusiveSans',
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B).withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar + label ──
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF8E8E93),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Tu reseña',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontFamily: 'InclusiveSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (review.updatedAt.difference(review.createdAt).inSeconds > 60) ...[
                const SizedBox(width: 8),
                Text(
                  'Editado · ${_fmtDiff(DateTime.now().toUtc().difference(review.updatedAt.toUtc()))}',
                  style: TextStyle(
                    color: AppColors.hint,
                    fontSize: 11,
                    fontFamily: 'InclusiveSans',
                  ),
                ),
              ],
            ],
          ),

          // ── Rating ──
          if (review.rating != null) ...[
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating!
                      ? Icons.star
                      : Icons.star_border,
                  color: const Color(0xFFF0BB58),
                  size: 18,
                );
              }),
            ),
          ],

          // ── Contenido ──
          const SizedBox(height: 8),
          Text(
            review.content,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontFamily: 'InclusiveSans',
              height: 1.4,
            ),
          ),

          // ── Acciones ──
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Editar',
                  style: TextStyle(
                    color: AppColors.hint,
                    fontSize: 13,
                    fontFamily: 'InclusiveSans',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _confirmDelete(context),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Color(0xFFE05C5C),
                    fontSize: 13,
                    fontFamily: 'InclusiveSans',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
