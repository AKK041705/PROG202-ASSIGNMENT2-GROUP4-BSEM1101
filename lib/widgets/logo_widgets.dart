import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// The Salone Transport Hub logo as a picture (assets/images/logo.png).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    final pixels = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      cacheWidth: pixels,
      fit: BoxFit.contain,
      semanticLabel: 'Salone Transport Hub logo',
      // If a phone or emulator cannot decode the picture, draw the logo in code instead.
      errorBuilder: (context, error, stackTrace) => StaticLogoMark(size: size),
    );
  }
}

/// Draws the logo and lets each part animate:
/// the tile pops in, the road draws itself, the pin drops, then a ripple spreads.
class LogoMarkPainter extends CustomPainter {
  LogoMarkPainter({
    required this.tile,
    required this.road,
    required this.pin,
    required this.ripple,
    this.rotation = 0,
    this.vehicle = 0,
  });

  final double tile; // 0..1 tile scale
  final double road; // 0..1 how much of the road is drawn
  final double pin; // 0..1 pin drop
  final double ripple; // 0..1 ripple spread
  final double rotation; // radians the tile is turned by
  final double vehicle; // 0..1 position of the little vehicle on the road (0 = hidden)

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final centre = Offset(s / 2, s / 2);

    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.rotate(rotation);
    canvas.scale(tile.clamp(0.0, 1.2));
    canvas.translate(-centre.dx, -centre.dy);

    final tileRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, s, s),
      Radius.circular(s * 0.24),
    );
    canvas.drawRRect(tileRect, Paint()..color = AppColors.green);
    canvas.clipRRect(tileRect);

    // Road
    final roadPath = Path()
      ..moveTo(s * 0.18, s * 0.80)
      ..cubicTo(s * 0.38, s * 0.58, s * 0.60, s * 0.86, s * 0.82, s * 0.60);
    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.075
      ..strokeCap = StrokeCap.round;
    for (final metric in roadPath.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * road.clamp(0.0, 1.0)), roadPaint);
      // A small vehicle drives along the road while it is being drawn.
      if (vehicle > 0 && vehicle < 1) {
        final spot = metric.getTangentForOffset(metric.length * vehicle);
        if (spot != null) {
          canvas.drawCircle(spot.position, s * 0.062, Paint()..color = AppColors.blue);
          canvas.drawCircle(spot.position, s * 0.032, Paint()..color = Colors.white);
        }
      }
    }

    // Ripple where the pin lands
    if (ripple > 0 && ripple < 1) {
      final rect = Rect.fromCenter(
        center: Offset(s * 0.5, s * 0.70),
        width: s * 0.5 * ripple + s * 0.1,
        height: s * 0.2 * ripple + s * 0.04,
      );
      canvas.drawOval(
        rect,
        Paint()
          ..color = Color.fromRGBO(255, 255, 255, 1 - ripple)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.02,
      );
    }

    // Pin (drops from above with a bounce)
    final drop = (1 - Curves.bounceOut.transform(pin.clamp(0.0, 1.0))) * s * 0.7;
    canvas.save();
    canvas.translate(0, -drop);
    // Teardrop: an arc over the top of the circle, then straight lines to the tip.
    final pinCentre = Offset(s * 0.5, s * 0.36);
    final pinRadius = s * 0.15;
    final tip = Offset(s * 0.5, s * 0.63);
    final theta = math.acos(pinRadius / (tip.dy - pinCentre.dy));
    final startAngle = math.pi / 2 + theta;
    final leftTangent = Offset(
      pinCentre.dx + pinRadius * math.cos(startAngle),
      pinCentre.dy + pinRadius * math.sin(startAngle),
    );
    final pinPath = Path()
      ..moveTo(leftTangent.dx, leftTangent.dy)
      ..arcTo(Rect.fromCircle(center: pinCentre, radius: pinRadius), startAngle, 2 * math.pi - 2 * theta, false)
      ..lineTo(tip.dx, tip.dy)
      ..close();
    canvas.drawPath(pinPath, Paint()..color = AppColors.blue);
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.022
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(Offset(s * 0.5, s * 0.36), s * 0.055, Paint()..color = Colors.white);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(LogoMarkPainter old) =>
      old.tile != tile ||
      old.road != road ||
      old.pin != pin ||
      old.ripple != ripple ||
      old.rotation != rotation ||
      old.vehicle != vehicle;
}

/// Convenience: a fully drawn logo mark of a given size.
class StaticLogoMark extends StatelessWidget {
  const StaticLogoMark({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: LogoMarkPainter(tile: 1, road: 1, pin: 1, ripple: 0),
      ),
    );
  }
}
