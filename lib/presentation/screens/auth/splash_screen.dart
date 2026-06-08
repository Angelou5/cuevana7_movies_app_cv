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

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    // FASE 1: entra desde abajo (0.0 → 0.13) ~480ms
    _slideIn = Tween<double>(begin: 140.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.13, curve: Curves.easeOut),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.13, curve: Curves.easeOut),
      ),
    );

    // FASE 2: espera ~2 segundos (0.13 → 0.60)

    // FASE 3: sube y encoge (0.60 → 1.0) ~1520ms
    _slideOut = Tween<double>(begin: 0.0, end: -220.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.0, curve: Curves.easeInCubic),
      ),
    );

    _scaleOut = Tween<double>(begin: 1.0, end: 0.20).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.0, curve: Curves.easeInCubic),
      ),
    );

    // Navega a mitad de la animación de encogimiento
    _controller.addListener(() {
      if (_controller.value >= 0.80 && !_navigated && mounted) {
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
          final combinedSlide = _slideIn.value + _slideOut.value;

          return Center(
            child: Transform.translate(
              offset: Offset(0, combinedSlide),
              child: Transform.scale(
                scale: _scaleOut.value,
                child: Opacity(
                  opacity: _fadeIn.value,
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
