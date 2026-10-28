import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_preferences.dart';
import '../../core/app_routes.dart';
import '../../data/fare_service.dart';
import '../../models/models.dart';
import '../../services/currency_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/fare_tile.dart';
import '../../widgets/request_card.dart';
import '../../widgets/responsive_body.dart';

/// Home tab: greeting, summary, quick actions, popular routes and the latest request.
class PassengerHomeView extends StatelessWidget {
  const PassengerHomeView({super.key, required this.onOpenTab});

  /// Lets a tile switch the bottom navigation to another tab.
  final ValueChanged<int> onOpenTab;

  static const List<List<String>> _popular = [
    ['Lumley', 'Wilberforce', 'Kekeh'],
    ['Waterloo', 'Bombay Street', 'Poda-poda'],
    ['Freetown', 'Bo', 'Bus'],
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final user = state.currentUser!;
        final unread = state.unreadCount(user.username);
        final mine = state.requestsOfPassenger(user.username);
        final active = mine.where((r) => r.status.isActive).length;
        final completed = mine.where((r) => r.status == RequestStatus.completed).length;
        final reports = state.reportsOfPassenger(user.username).length;
        final currency = AppPreferences.instance.currency;

        return ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user.name.split(' ').first}',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    const Text('Where do you want to go today?', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _HeaderChip(Icons.public, user.country),
                        _HeaderChip(Icons.payments_outlined, currency == 'NLe' ? 'Prices in NLe' : 'NLe and $currency'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: MiniStat(label: 'Active requests', value: '$active', icon: Icons.directions_car)),
                  const SizedBox(width: 10),
                  Expanded(child: MiniStat(label: 'Trips completed', value: '$completed', icon: Icons.flag_circle_outlined)),
                  const SizedBox(width: 10),
                  Expanded(child: MiniStat(label: 'Fare reports', value: '$reports', icon: Icons.flag_outlined)),
                ],
              ),
              const SectionTitle('Quick actions'),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 142,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  ActionTile(
                    label: 'Request a ride',
                    icon: Icons.directions_car,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.requestTransport),
                  ),
                  ActionTile(
                    label: 'Compare fares',
                    icon: Icons.compare_arrows,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.compare),
                  ),
                  ActionTile(
                    label: 'My requests',
                    icon: Icons.list_alt,
                    onTap: () => onOpenTab(2),
                  ),
                  ActionTile(
                    label: 'Report a fare issue',
                    icon: Icons.flag_outlined,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.reportFare),
                  ),
                  ActionTile(
                    label: 'My reports',
                    icon: Icons.assignment_outlined,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.myReports),
                  ),
                  ActionTile(
                    label: 'Notifications',
                    icon: Icons.notifications_none,
                    badge: unread,
                    onTap: () => onOpenTab(3),
                  ),
                ],
              ),
              const SectionTitle('Popular routes'),
              for (final route in _popular) _popularRoute(context, state, route, currency),
              const SectionTitle('Latest request'),
              if (mine.isEmpty)
                const EmptyState(
                  icon: Icons.directions_car_outlined,
                  title: 'No requests yet',
                  message: 'Tap "Request a ride" to send your first request.',
                )
              else
                RequestCard(
                  request: mine.first,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: mine.first.id),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _popularRoute(BuildContext context, AppState state, List<String> route, String currency) {
    final quote = state.quote(route[2], route[0], route[1]);
    final other = CurrencyService.secondary(quote.amount, currency);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      // Passing the route to the compare screen (data between screens).
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.compare,
        arguments: <String>[route[0], route[1]],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.greenTint, shape: BoxShape.circle),
            child: Icon(modeIcon(route[2]), color: AppColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${route[0]} to ${route[1]}', style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(route[2], style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(FareService.amountText(quote), style: const TextStyle(fontWeight: FontWeight.w800)),
              if (other != null) Text(other, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greenDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
