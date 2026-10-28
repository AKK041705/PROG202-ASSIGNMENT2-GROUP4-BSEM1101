import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/status_chip.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: const AppTopBar(title: 'My fare reports'),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            final reports = state.reportsOfPassenger(state.currentUser!.username);
            return RefreshIndicator(
              color: AppColors.green,
              onRefresh: () async => state.refresh(),
              child: ResponsiveBody(
                scroll: false,
                child: reports.isEmpty
                    ? ListView(
                        children: const [
                          EmptyState(
                            icon: Icons.flag_outlined,
                            title: 'No reports yet',
                            message: 'Reports you send about unusual fares will appear here.',
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          for (final r in reports)
                            AppCard(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${r.id}  |  ${r.mode}',
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      StatusChip.report(r.status),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  InfoRow('Route', r.route),
                                  InfoRow('You paid', 'NLe ${r.reported.toStringAsFixed(1)}'),
                                  InfoRow('System fare', r.systemFare),
                                  InfoRow('Description', r.note),
                                  if (r.response.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    NoteBox(text: 'Administrator: ${r.response}', icon: Icons.reply),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
