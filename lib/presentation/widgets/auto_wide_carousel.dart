import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/wide_movie_card.dart';

/// Carrusel automático de películas a pantalla completa con dots indicadores.
/// Se avanza solo cada 5 segundos y pausa al interactuar.
class AutoWideCarousel extends StatefulWidget {
  final List<dynamic> movies;
  final double height;
  const AutoWideCarousel({super.key, required this.movies, required this.height});

  @override
  State<AutoWideCarousel> createState() => _AutoWideCarouselState();
}

class _AutoWideCarouselState extends State<AutoWideCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  static const double _horizontalPadding = 24;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.movies.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % widget.movies.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didUpdateWidget(covariant AutoWideCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movies.length != widget.movies.length) {
      _currentPage = 0;
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return SizedBox(height: widget.height);

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is UserScrollNotification) _startAutoPlay();
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.movies.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: Center(
                    child: WideMovieCard(
                      movie: widget.movies[index],
                      onShowDescription: _pauseAutoPlay,
                      onHideDescription: _startAutoPlay,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.movies.length.clamp(0, 5), (index) {
            final isActive = index == (_currentPage % 5);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
