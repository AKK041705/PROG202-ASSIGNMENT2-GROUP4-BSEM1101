import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/nav_bar.dart';
import '../common/fares_screen.dart';
import '../common/notifications_view.dart';
import '../common/profile_view.dart';
import 'my_requests_screen.dart';
import 'passenger_home_view.dart';

/// Passenger area: bottom navigation (Home, Fares, Requests, Alerts, Profile)
/// plus a drawer with extra screens.
class PassengerShell extends StatefulWidget {
  const PassengerShell({super.key});

  @override
  State<PassengerShell> createState() => _PassengerShellState();
}

class _PassengerShellState extends State<PassengerShell> {
  int _index = 0;

  static const _titles = ['Home', 'Fares', 'My requests', 'Notifications', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final unread = state.unreadCount(state.currentUser?.username ?? '');
        return Scaffold(
          appBar: AppTopBar(
            title: _titles[_index],
            actions: [
              if (_index == 0)
                IconButton(
                  tooltip: 'New request',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.requestTransport),
                ),
            ],
          ),
          drawer: const AppDrawer(
            items: [
              DrawerItem('Request transportation', Icons.directions_car, AppRoutes.requestTransport),
              DrawerItem('Compare transportation', Icons.compare_arrows, AppRoutes.compare),
              DrawerItem('Report a fare issue', Icons.flag_outlined, AppRoutes.reportFare),
              DrawerItem('My fare reports', Icons.assignment_outlined, AppRoutes.myReports),
              DrawerItem('About', Icons.info_outline, AppRoutes.about),
            ],
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _index,
              children: [
                PassengerHomeView(onOpenTab: (i) => setState(() => _index = i)),
                const FaresView(),
                const MyRequestsView(),
                const NotificationsView(),
                const ProfileView(),
              ],
            ),
          ),
          bottomNavigationBar: _bar(unread),
        );
      },
    );
  }

  Widget _bar(int unread) {
    return NavBar(
      index: _index,
      unread: unread,
      onTap: (i) => setState(() => _index = i),
      items: const [
        NavItem('Home', Icons.home_outlined, Icons.home),
        NavItem('Fares', Icons.payments_outlined, Icons.payments),
        NavItem('Requests', Icons.list_alt_outlined, Icons.list_alt),
        NavItem('Alerts', Icons.notifications_none, Icons.notifications, isAlerts: true),
        NavItem('Profile', Icons.person_outline, Icons.person),
      ],
    );
  }
}
