import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/session.dart';
import '../../core/ui_helpers.dart';
import '../../models/models.dart';
import '../../services/phone_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';

/// Profile of the logged-in user, with a Log out button.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final user = state.currentUser;
        if (user == null) return const SizedBox.shrink();
        return ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                  child: Text(
                    user.initials,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(user.role.label, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow('Username', user.username),
                    InfoRow('Phone', PhoneService.display(user.phone)),
                    InfoRow('Country', user.country),
                    InfoRow('Prices in', user.currency == 'NLe' ? 'NLe only' : 'NLe and ${user.currency}'),
                    if (user.role == UserRole.driver) ...[
                      InfoRow('Type', user.driverType ?? '-'),
                      InfoRow('Vehicle', user.vehicle ?? '-'),
                      InfoRow('Plate', user.plate ?? '-'),
                      InfoRow('Status', user.verified ? 'Verified' : 'Waiting for verification'),
                    ],
                  ],
                ),
              ),
              if (user.role == UserRole.driver && !user.verified) ...[
                const SizedBox(height: 12),
                NoteBox(
                  text: 'The administrator has not verified your account yet. You cannot receive requests until then.',
                  icon: Icons.hourglass_top,
                  color: AppColors.amber,
                  background: AppColors.amberTint,
                ),
              ],
              const SizedBox(height: 20),
              SecondaryButton(
                label: 'Settings: theme and currency',
                icon: Icons.settings_outlined,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Log out',
                icon: Icons.logout,
                color: AppColors.red,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final ok = await confirmAction(
                    context,
                    title: 'Log out',
                    message: 'Do you want to log out?',
                    confirmLabel: 'Log out',
                  );
                  if (!ok) return;
                  Session.logout();
                  navigator.pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Profile'),
      body: SafeArea(child: ProfileView()),
    );
  }
}
