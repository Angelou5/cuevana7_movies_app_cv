import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cuevana7_movies_app_cv/domain/entities/actor.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor_detail.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/shared/http_utils.dart';

class ActorDetailScreen extends StatefulWidget {
  static const String name = 'actor-detail';

  /// Actor "ligero" que viene del reparto (ya tenemos id, nombre y foto,
  /// así que la pantalla se puede pintar de inmediato mientras se carga
  /// el resto de la información desde TMDB).
  final Actor actor;

  const ActorDetailScreen({super.key, required this.actor});

  @override
  State<ActorDetailScreen> createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  late Future<ActorDetail> _detailFuture;
  late Future<List<Movie>> _moviesFuture;
  bool _bioExpanded = false;

  static const int _bioCollapsedThreshold = 220;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final repo = context.read<MovieProvider>().repository;
    setState(() {
      _detailFuture = repo.getActorDetails(widget.actor.id);
      _moviesFuture = repo.getActorMovies(widget.actor.id);
    });
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final date = DateTime.parse(raw);
      const meses = [
        'ene',
        'feb',
        'mar',
        'abr',
        'may',
        'jun',
        'jul',
        'ago',
        'sep',
        'oct',
        'nov',
        'dic',
      ];
      return '${date.day} de ${meses[date.month - 1]} de ${date.year}';
    } catch (_) {
      return raw;
    }
  }

  int? _calculateAge(String birthday, String? deathday) {
    if (birthday.isEmpty) return null;
    try {
      final birth = DateTime.parse(birthday);
      final end = (deathday != null && deathday.isNotEmpty)
          ? DateTime.parse(deathday)
          : DateTime.now();
      int age = end.year - birth.year;
      if (end.month < birth.month ||
          (end.month == birth.month && end.day < birth.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final actor = widget.actor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BottomFadeMask(
          fadeHeightFraction: 0.06,
          child: RefreshIndicator(
            color: AppColors.white,
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              _loadData();
              await Future.wait([_detailFuture, _moviesFuture]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Botón de regreso ─────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Foto + nombre ─────────────────────────────
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade800,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: actor.profilePath.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 70,
                            )
                          : Image.network(
                              actor.profilePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 70,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        actor.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'InclusiveSans',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Info personal + biografía ─────────────────
                  FutureBuilder<ActorDetail>(
                    future: _detailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SizedBox(
                            height: 160,
                            child: ErrorView(
                              error: classifyError(snapshot.error!),
                              onRetry: _loadData,
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      final detail = snapshot.data!;
                      final age = _calculateAge(
                        detail.birthday,
                        detail.deathday,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Chips de info ──────────────────────
                          if (detail.knownForDepartment.isNotEmpty ||
                              detail.birthday.isNotEmpty ||
                              detail.placeOfBirth.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  if (detail.knownForDepartment.isNotEmpty)
                                    _InfoChip(
                                      icon: Icons.theater_comedy_outlined,
                                      label: detail.knownForDepartment,
                                    ),
                                  if (detail.birthday.isNotEmpty)
                                    _InfoChip(
                                      icon: Icons.cake_outlined,
                                      label: age != null
                                          ? '${_formatDate(detail.birthday)} ($age años)'
                                          : _formatDate(detail.birthday),
                                    ),
                                  if (detail.deathday != null &&
                                      detail.deathday!.isNotEmpty)
                                    _InfoChip(
                                      icon: Icons.local_florist_outlined,
                                      label:
                                          'Falleció el ${_formatDate(detail.deathday!)}',
                                    ),
                                  if (detail.placeOfBirth.isNotEmpty)
                                    _InfoChip(
                                      icon: Icons.location_on_outlined,
                                      label: detail.placeOfBirth,
                                    ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          // ── Biografía ───────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Biografía',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontFamily: 'InclusiveSans',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  detail.biography,
                                  maxLines: _bioExpanded ? null : 6,
                                  overflow: _bioExpanded
                                      ? null
                                      : TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 15,
                                    fontFamily: 'InclusiveSans',
                                    height: 1.5,
                                  ),
                                ),
                                if (detail.biography.length >
                                    _bioCollapsedThreshold)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => setState(
                                        () => _bioExpanded = !_bioExpanded,
                                      ),
                                      child: Text(
                                        _bioExpanded ? 'Ver menos' : 'Ver más',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.75,
                                          ),
                                          fontSize: 13,
                                          fontFamily: 'InclusiveSans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ── Filmografía ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Filmografía',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontFamily: 'InclusiveSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FutureBuilder<List<Movie>>(
                      future: _moviesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return SizedBox(
                            height: 160,
                            child: ErrorView(
                              error: classifyError(snapshot.error!),
                              onRetry: _loadData,
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }

                        final movies = snapshot.data!;

                        if (movies.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No se encontraron películas para este actor.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 14,
                                fontFamily: 'InclusiveSans',
                              ),
                            ),
                          );
                        }

                        return Wrap(
                          spacing: 12,
                          runSpacing: 16,
                          children: movies
                              .map(
                                (movie) => SizedBox(
                                  width: 145,
                                  height: 200,
                                  child: MovieCard(movie: movie),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontFamily: 'InclusiveSans',
            ),
          ),
        ],
      ),
    );
  }
}
