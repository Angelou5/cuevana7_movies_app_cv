import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

/// Botón de ícono SVG con animación de rebote al presionar.
///
/// Se envuelve en [AspectRatio] cuadrado para que su bounding box mida
/// exactamente el alto real de un botón hermano cuando ambos están dentro
/// de un [Row] con [CrossAxisAlignment.stretch] envuelto en [IntrinsicHeight].
///
/// [SvgPicture] fija [width]/[height] explícitos para que el alto de la fila
/// no dependa del asset mostrado.
class ActionIcon extends StatefulWidget {
  final String asset;
  final String semanticLabel;
  final VoidCallback? onTap;
  final double iconSize;

  const ActionIcon({
    super.key,
    required this.asset,
    required this.semanticLabel,
    this.onTap,
    this.iconSize = 44,
  });

  @override
  State<ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<ActionIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final Animation<double> _bounce = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.72).chain(
        CurveTween(curve: Curves.easeOut),
      ),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.72, end: 1.0).chain(
        CurveTween(curve: Curves.easeOutBack),
      ),
      weight: 65,
    ),
  ]).animate(_controller);

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
              child: AnimatedBuilder(
                animation: _bounce,
                builder: (context, child) =>
                    Transform.scale(scale: _bounce.value, child: child),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: SvgPicture.asset(
                    widget.asset,
                    key: ValueKey(widget.asset),
                    width: widget.iconSize,
                    height: widget.iconSize,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
