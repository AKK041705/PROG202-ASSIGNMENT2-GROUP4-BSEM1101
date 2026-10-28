import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../core/session.dart';
import '../core/ui_helpers.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'logo_widgets.dart';

class DrawerItem {
  const DrawerItem(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

/// Side menu with the user's name, extra screens and Log out.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.items});

  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    final user = AppState.instance.currentUser;
    return Drawer(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.green,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StaticLogoMark(size: 56),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Guest',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    user?.role.label ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final item in [...items, const DrawerItem('Settings (theme, currency)', Icons.settings_outlined, AppRoutes.settings)])
                    ListTile(
                      leading: Icon(item.icon, color: AppColors.green),
                      title: Text(item.label),
                      onTap: () {
                        Navigator.pop(context); // close the drawer
                        Navigator.pushNamed(context, item.route);
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.red),
              title: Text('Log out', style: TextStyle(color: AppColors.red)),
              onTap: () async {
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
      ),
    );
  }
}
