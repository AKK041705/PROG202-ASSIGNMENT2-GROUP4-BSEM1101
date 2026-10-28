import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/logo_widgets.dart';
import '../../widgets/responsive_body.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'About'),
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: AppLogo(size: 100)),
              const SizedBox(height: 12),
              Text(
                'Salone Transport Hub',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.green),
              ),
              Text('Version 1.0 (PROG 202, Assignment 2)',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              const AppCard(
                child: Text(
                  'Salone Transport Hub is a student prototype that helps passengers in Sierra Leone find '
                  'transport fares, compare options, request a ride and report fare problems.',
                  style: TextStyle(height: 1.45),
                ),
              ),
              const SizedBox(height: 12),
              NoteBox(
                text: 'This app is not owned, approved or endorsed by any government body, union or transport '
                    'operator, and it does not set or control any transport price. Data is kept in memory only '
                    'and is lost when the app closes. Drivers, vehicles, demo passengers, requests and reports are fictional sample data.',
                icon: Icons.gavel,
                color: AppColors.amber,
                background: AppColors.amberTint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
