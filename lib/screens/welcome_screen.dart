import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_preferences.dart';
import '../core/app_routes.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/logo_widgets.dart';
import '../widgets/responsive_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 520,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Dark or light mode',
                    icon: Icon(
                      AppPreferences.instance.dark ? Icons.light_mode : Icons.dark_mode,
                      color: AppColors.green,
                    ),
                    onPressed: () => AppPreferences.instance.setDark(!AppPreferences.instance.dark),
                  ),
                  IconButton(
                    tooltip: 'Settings',
                    icon: Icon(Icons.settings_outlined, color: AppColors.green),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                ],
              ),
              const Center(child: AppLogo(size: 110)),
              const SizedBox(height: 16),
              Text(
                'Salone Transport Hub',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.green),
              ),
              const SizedBox(height: 8),
              Text(
                'Fares, rides and fair-price reports for okada, kekeh, taxi, poda-poda and bus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 24),
              const _Feature(Icons.compare_arrows, 'Compare fares', 'See every transport option for your route.'),
              const _Feature(Icons.directions_car, 'Request a ride', 'Choose your vehicle, people and seats.'),
              const _Feature(Icons.flag_outlined, 'Report a fare issue', 'Tell the administrator when a fare looks wrong.'),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Log in',
                icon: Icons.login,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Create account',
                icon: Icons.person_add_alt_1,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.guestFares),
                child: const Text('Browse fares without logging in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.greenTint, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(text, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
