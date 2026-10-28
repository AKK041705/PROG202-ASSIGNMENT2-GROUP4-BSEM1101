import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/nav_bar.dart';
import '../common/notifications_view.dart';
import '../common/profile_view.dart';
import 'driver_home_view.dart';
import 'driver_requests_view.dart';
import 'driver_trips_view.dart';

/// Driver area: Requests, Trips, Fares, Alerts, Profile.
class DriverShell extends StatefulWidget {
  const DriverShell({super.key});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;

  static const _titles = ['Home', 'Incoming requests', 'My trips', 'Notifications', 'Profile'];

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
              DrawerItem('View fares', Icons.payments_outlined, AppRoutes.fares),
              DrawerItem('Compare transportation', Icons.compare_arrows, AppRoutes.compare),
              DrawerItem('About', Icons.info_outline, AppRoutes.about),
            ],
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _index,
              children: [
                DriverHomeView(onOpenTab: (i) => setState(() => _index = i)),
                const DriverRequestsView(),
                const DriverTripsView(),
                const NotificationsView(),
                const ProfileView(),
              ],
            ),
          ),
          bottomNavigationBar: NavBar(
            index: _index,
            unread: unread,
            onTap: (i) => setState(() => _index = i),
            items: const [
              NavItem('Home', Icons.home_outlined, Icons.home),
              NavItem('Requests', Icons.inbox_outlined, Icons.inbox),
              NavItem('Trips', Icons.route_outlined, Icons.route),
              NavItem('Alerts', Icons.notifications_none, Icons.notifications, isAlerts: true),
              NavItem('Profile', Icons.person_outline, Icons.person),
            ],
          ),
        );
      },
    );
  }
}
