import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/nav_bar.dart';
import '../common/notifications_view.dart';
import 'admin_dashboard_view.dart';
import 'admin_drivers_view.dart';
import 'admin_fares_view.dart';
import 'admin_reports_view.dart';

/// Administrator area: Dashboard, Drivers, Fares, Reports, Alerts.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _titles = ['Dashboard', 'Drivers', 'Manage fares', 'Fare reports', 'Notifications'];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final unread = state.unreadCount(state.currentUser?.username ?? '');
        return Scaffold(
          appBar: AppTopBar(title: _titles[_index]),
          drawer: const AppDrawer(
            items: [
              DrawerItem('My profile', Icons.person_outline, AppRoutes.profile),
              DrawerItem('Compare transportation', Icons.compare_arrows, AppRoutes.compare),
              DrawerItem('About', Icons.info_outline, AppRoutes.about),
            ],
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _index,
              children: [
                AdminDashboardView(onOpenTab: (i) => setState(() => _index = i)),
                const AdminDriversView(),
                const AdminFaresView(),
                const AdminReportsView(),
                const NotificationsView(),
              ],
            ),
          ),
          bottomNavigationBar: NavBar(
            index: _index,
            unread: unread,
            onTap: (i) => setState(() => _index = i),
            items: const [
              NavItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard),
              NavItem('Drivers', Icons.badge_outlined, Icons.badge),
              NavItem('Fares', Icons.payments_outlined, Icons.payments),
              NavItem('Reports', Icons.flag_outlined, Icons.flag),
              NavItem('Alerts', Icons.notifications_none, Icons.notifications, isAlerts: true),
            ],
          ),
        );
      },
    );
  }
}
