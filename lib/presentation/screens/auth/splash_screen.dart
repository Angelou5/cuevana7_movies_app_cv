import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  static const name = 'splash-screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideIn;
  late Animation<double> _fadeIn;
  late Animation<double> _slideOut;
  late Animation<double> _scaleOut;
  late Animation<double> _fadeOut;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // FASE 1: entra desde abajo (0.0 → 0.10) ~500ms
    _slideIn = Tween<double>(begin: 140.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.10, curve: Curves.easeOut),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.10, curve: Curves.easeOut),
      ),
    );

    // FASE 2: espera ~2 segundos (0.10 → 0.50)

    // FASE 3: sube y encoge (0.50 → 0.70) ~1000ms — normalizado 0.0 a 1.0
    _slideOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.65, curve: Curves.easeInCubic),
      ),
    );

    _scaleOut = Tween<double>(begin: 1.0, end: 0.28).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.65, curve: Curves.easeInCubic),
      ),
    );

    // FASE 4: se queda arriba 1 segundo (0.70 → 0.90)

    // FASE 5: fade out (0.90 → 1.0)
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.90, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.addListener(() {
      if (_controller.value >= 0.55 && !_navigated && mounted) {
        _navigated = true;
        context.go('/login');
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final logoSize = (shortestSide * 0.90).clamp(200.0, 560.0);
    final fontSize = (size.width * 0.09).clamp(28.0, 52.0);

    return Scaffold(
      backgroundColor: const Color(0xFF1D1C1A),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calcula el destino dinámico: centro → 50px desde el borde superior
          // ajustado al tamaño del logo ya escalado
          final targetY =
              -(size.height / 2) + 30 + (logoSize * _scaleOut.value / 2);
          final combinedSlide = _slideIn.value + (_slideOut.value * targetY);
          final combinedOpacity = (_fadeIn.value * _fadeOut.value).clamp(
            0.0,
            1.0,
          );

          return Center(
            child: Transform.translate(
              offset: Offset(0, combinedSlide),
              child: Transform.scale(
                scale: _scaleOut.value,
                child: Opacity(
                  opacity: combinedOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo2.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                      Transform.translate(
                        offset: const Offset(0, -90),
                        child: Text(
                          'Cuevana 7',
                          style: TextStyle(
                            fontFamily: 'InclusiveSans',
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
