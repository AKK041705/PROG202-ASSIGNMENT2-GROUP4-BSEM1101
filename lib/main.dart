import 'package:flutter/material.dart';

import 'core/app_preferences.dart';
import 'core/app_router.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const SaloneTransportHubApp());
}

class SaloneTransportHubApp extends StatelessWidget {
  const SaloneTransportHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds the whole app with a new theme when Settings change.
    return ListenableBuilder(
      listenable: AppPreferences.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Salone Transport Hub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(),
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.generate,
          // Keeps text readable on every phone: very large system font sizes are
          // limited so layouts do not overflow.
          builder: (context, child) {
            return MediaQuery.withClampedTextScaling(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.25,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
