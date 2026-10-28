import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// One item of the bottom navigation bar.
class NavItem {
  const NavItem(this.label, this.icon, this.activeIcon, {this.isAlerts = false});

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isAlerts; // shows the unread notification count on this item
}

/// Bottom navigation bar used by the passenger, driver and administrator areas.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    required this.index,
    required this.onTap,
    this.unread = 0,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onTap;
  final int unread;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.green,
      unselectedItemColor: AppColors.textSecondary,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: onTap,
      items: [
        for (final item in items)
          BottomNavigationBarItem(
            label: item.label,
            icon: _icon(item, item.icon),
            activeIcon: _icon(item, item.activeIcon),
          ),
      ],
    );
  }

  Widget _icon(NavItem item, IconData data) {
    if (!item.isAlerts) return Icon(data);
    return Badge(
      isLabelVisible: unread > 0,
      label: Text('$unread'),
      backgroundColor: AppColors.red,
      child: Icon(data),
    );
  }
}
