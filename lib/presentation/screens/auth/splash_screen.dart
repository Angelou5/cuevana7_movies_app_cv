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
  late final AnimationController _controller;

  late final Animation<double> _slideIn;
  late final Animation<double> _fadeIn;
  late final Animation<double> _slideOut;
  late final Animation<double> _scaleOut;
  late final Animation<double> _fadeOut;

  bool _started = false;
  bool _navigated = false;

  static const AssetImage _logoImage = AssetImage('assets/images/logo2.png');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // entrada desde abajo 
    _slideIn = Tween<double>(begin: 400.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.20,
          curve: Curves.easeOut,
        ),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.20,
          curve: Curves.easeOut,
        ),
      ),
    );

    // pausa

    // se hace pequeño y va subiendo
    _slideOut = Tween<double>(begin: 0.0, end: 1.44).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.45,
          0.65,
          curve: Curves.easeInCubic,
        ),
      ),
    );

    _scaleOut = Tween<double>(begin: 1.0, end: 0.55).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.45,
          0.65,
          curve: Curves.easeInCubic,
        ),
      ),
    );

    // otra pausa

    // pa desaparecer
    _fadeOut = Tween<double>(begin: 1.00, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.90,
          0.99,
          curve: Curves.easeIn,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_started) return;
    _started = true;

    _startSplash();
  }

  Future<void> _startSplash() async {
    // Precarga la imagen asi es mejor jeje
    await precacheImage(_logoImage, context);

    if (!mounted) return;

    await _controller.forward();

    if (!mounted || _navigated) return;

    _navigated = true;
    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;

    final logoSize = (shortestSide * 0.90).clamp(200.0, 560.0);
    final fontSize = (size.width * 0.09).clamp(28.0, 52.0);

    return Scaffold(
      backgroundColor: const Color(0xFF1D1C1A),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final targetY =
              -(size.height / 2.5) + 30 + (logoSize * _scaleOut.value / 2);

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
                  child: child,
                ),
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: _logoImage,
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
    );
  }
}