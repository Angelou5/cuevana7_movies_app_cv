import 'package:flutter/material.dart';

/// Aplica un degradado (fade) en la parte inferior del [child],
/// para que el contenido se desvanezca suavemente antes de llegar
/// a la navbar flotante, en vez de cortarse de golpe.
class BottomFadeMask extends StatelessWidget {
  final Widget child;
  final double fadeHeightFraction;

  const BottomFadeMask({
    super.key,
    required this.child,
    this.fadeHeightFraction = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Colors.white, Colors.white, Colors.transparent],
        stops: [0.0, 1 - fadeHeightFraction, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
