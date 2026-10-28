import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';

/// List of notifications. Pull down to refresh, like checking for a new grade.
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final username = state.currentUser!.username;
        final items = state.notificationsFor(username);
        final unread = state.unreadCount(username);
        return RefreshIndicator(
          color: AppColors.green,
          onRefresh: () async => state.refresh(),
          child: ResponsiveBody(
            scroll: false,
            child: items.isEmpty
                ? ListView(
                    children: const [
                      EmptyState(
                        icon: Icons.notifications_none,
                        title: 'No notifications yet',
                        message: 'When someone responds to your request or report, it shows up here. Pull down to refresh.',
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      if (unread > 0)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => state.markAllRead(username),
                            icon: const Icon(Icons.done_all),
                            label: Text('Mark $unread as read'),
                          ),
                        ),
                      for (final n in items)
                        AppCard(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: n.read ? AppColors.surface : AppColors.greenTint,
                          borderColor: n.read ? AppColors.border : AppColors.greenTint,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                n.read ? Icons.notifications_none : Icons.notifications_active,
                                color: AppColors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(n.text, style: const TextStyle(height: 1.35)),
                                    const SizedBox(height: 4),
                                    Text(_time(n.time),
                                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

/// Stand-alone page version of the notifications list.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Notifications'),
      body: SafeArea(child: NotificationsView()),
    );
  }
}
