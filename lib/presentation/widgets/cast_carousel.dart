import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/actor.dart';
import '../../resources/colors/colors.dart';

class CastCarousel extends StatelessWidget {
  final List<Actor> cast;
  final bool showAll;

  const CastCarousel({super.key, required this.cast, this.showAll = false});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) {
      return const SizedBox();
    }

    final maxItems = showAll
        ? cast.length
        : (cast.length > 5 ? 5 : cast.length);

    return SizedBox(
      height: 170,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: maxItems,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          final actor = cast[index];

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push('/actor/${actor.id}', extra: actor),
            child: SizedBox(
              width: 85,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade800,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: actor.profilePath.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 34,
                          )
                        : Image.network(
                            actor.profilePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 34,
                            ),
                          ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    actor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'InclusiveSans',
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    actor.character,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontFamily: 'InclusiveSans',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
