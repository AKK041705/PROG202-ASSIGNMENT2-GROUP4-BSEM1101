import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../widgets/logo_widgets.dart';

/// First screen: the logo animates, then the app moves to the welcome screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _tile;
  late final Animation<double> _road;
  late final Animation<double> _pin;
  late final Animation<double> _ripple;
  late final Animation<double> _text;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    Animation<double> part(double begin, double end, Curve curve) {
      return CurvedAnimation(parent: _controller, curve: Interval(begin, end, curve: curve));
    }

    _tile = part(0.0, 0.25, Curves.easeOutBack);
    _road = part(0.20, 0.55, Curves.easeInOut);
    _pin = part(0.45, 0.78, Curves.linear);
    _ripple = part(0.72, 0.95, Curves.easeOut);
    _text = part(0.60, 0.90, Curves.easeOut);

    _controller.forward().whenComplete(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final logoSize = (shortest * 0.42).clamp(120.0, 220.0);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: logoSize,
                  height: logoSize,
                  child: CustomPaint(
                    painter: LogoMarkPainter(
                      tile: _tile.value,
                      road: _road.value,
                      pin: _pin.value,
                      ripple: _ripple.value,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Opacity(
                  opacity: _text.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, (1 - _text.value) * 16),
                    child: Column(
                      children: [
                        Text(
                          'Salone Transport Hub',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.green,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Know your fare. Travel with confidence.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
