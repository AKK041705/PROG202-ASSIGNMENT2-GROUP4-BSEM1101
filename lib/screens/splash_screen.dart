import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../widgets/logo_widgets.dart';

/// First screen. The logo animates (rings pulse, the tile spins in, a vehicle
/// drives along the road, the pin drops and ripples, the name appears letter by
/// letter), then the app opens the welcome screen. Tap to skip.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  static const String _title = 'Salone Transport Hub';

  late final AnimationController _controller;
  late final Animation<double> _tile;
  late final Animation<double> _spin;
  late final Animation<double> _road;
  late final Animation<double> _pin;
  late final Animation<double> _ripple;
  late final Animation<double> _tagline;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3800));
    Animation<double> part(double begin, double end, Curve curve) {
      return CurvedAnimation(parent: _controller, curve: Interval(begin, end, curve: curve));
    }

    _tile = part(0.0, 0.22, Curves.easeOutBack);
    _spin = part(0.0, 0.22, Curves.easeOutCubic);
    _road = part(0.18, 0.52, Curves.easeInOut);
    _pin = part(0.50, 0.76, Curves.linear);
    _ripple = part(0.72, 0.92, Curves.easeOut);
    _tagline = part(0.86, 1.0, Curves.easeOut);

    _controller.forward().whenComplete(() async {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      _goNext();
    });
  }

  void _goNext() {
    if (_left || !mounted) return;
    _left = true;
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// How much of letter [index] has appeared (0 to 1).
  double _letter(int index) {
    final start = 0.60 + index * 0.014;
    return ((_controller.value - start) / 0.09).clamp(0.0, 1.0);
  }

  Widget _ring(double size, double phase) {
    final t = ((_controller.value * 2.2) + phase) % 1.0;
    // Fades by blending towards the background colour (no transparency layers,
    // so it also works on phones and emulators with weak graphics).
    final color = Color.lerp(AppColors.green, AppColors.surface, t)!;
    return Container(
      width: size * (0.7 + t * 1.5),
      height: size * (0.7 + t * 1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final logoSize = (shortest * 0.42).clamp(120.0, 220.0);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goNext,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: logoSize * 2.2,
                    height: logoSize * 2.2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _ring(logoSize, 0.0),
                        _ring(logoSize, 0.33),
                        _ring(logoSize, 0.66),
                        SizedBox(
                          width: logoSize,
                          height: logoSize,
                          child: CustomPaint(
                            painter: LogoMarkPainter(
                              tile: _tile.value,
                              rotation: (1 - _spin.value) * -0.6,
                              road: _road.value,
                              vehicle: _road.value,
                              pin: _pin.value,
                              ripple: _ripple.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (var i = 0; i < _title.length; i++)
                        Transform.translate(
                          offset: Offset(0, (1 - _letter(i)) * 16),
                          child: Text(
                            _title[i],
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              color: Color.lerp(AppColors.surface, AppColors.green, _letter(i)),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Know your fare. Travel with confidence.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.lerp(AppColors.surface, AppColors.textSecondary, _tagline.value),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 140,
                    height: 4,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: _controller.value.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
