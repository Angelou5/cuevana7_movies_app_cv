import 'package:flutter/material.dart';

import '../../domain/entities/movie_image.dart';
import 'gallery_viewer.dart';

/// Tira horizontal de miniaturas de la película. Al tocar una imagen se
/// abre [GalleryViewer] a pantalla completa, comenzando en esa foto.
class MovieGallery extends StatelessWidget {
  final List<MovieImage> images;

  const MovieGallery({super.key, required this.images});

  void _openViewer(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (_, _, _) =>
            GalleryViewer(images: images, initialIndex: index),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final image = images[index];

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openViewer(context, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.thumbnailUrl.isEmpty
                  ? Container(
                      width: 300,
                      height: 200,
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white38,
                      ),
                    )
                  : Image.network(
                      image.thumbnailUrl,
                      height: 200,
                      width: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 300,
                        height: 200,
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white38,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
