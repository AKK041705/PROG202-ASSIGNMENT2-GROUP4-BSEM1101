import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/ui_helpers.dart';
import '../../core/validators.dart';
import '../../data/fare_service.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/fare_tile.dart';
import '../../widgets/responsive_body.dart';

/// Administrator tab: browse and edit the published fares.
class AdminFaresView extends StatefulWidget {
  const AdminFaresView({super.key});

  @override
  State<AdminFaresView> createState() => _AdminFaresViewState();
}

class _AdminFaresViewState extends State<AdminFaresView> {
  String _mode = 'Kekeh';

  Future<void> _editFlat(Tariff flat) async {
    final controller = TextEditingController(text: flat.fare?.toStringAsFixed(1) ?? '');
    final formKey = GlobalKey<FormState>();
    final saved = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: Text('${flat.mode} pole-to-pole fare'),
        content: Form(
          key: formKey,
          child: AppTextField(
            controller: controller,
            label: 'New fare (NLe)',
            icon: Icons.payments_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            validator: Validators.amount,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(dialogContext, double.parse(controller.text.trim()));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (saved == null || !mounted) return;
    AppState.instance.updateFlatFare(flat, saved);
    showMessage(context, '${flat.mode} pole-to-pole fare updated.');
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final tariffs = state.tariffsForMode(_mode);
        final flats = tariffs.where((t) => t.isFlat).toList();
        final routes = tariffs.where((t) => !t.isFlat).toList();
        return Stack(
          children: [
            ResponsiveBody(
              scroll: false,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  AppDropdown(
                    label: 'Transport mode',
                    icon: Icons.directions_bus_outlined,
                    value: _mode,
                    items: FareService.adminFareModes,
                    onChanged: (v) => setState(() => _mode = v ?? _mode),
                  ),
                  for (final flat in flats) ...[
                    const SectionTitle('Pole-to-pole fare'),
                    AppCard(
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, color: AppColors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(FareService.money(flat.fare ?? 0),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                SourceTag(flat.source),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit pole-to-pole fare',
                            icon: Icon(Icons.edit_outlined, color: AppColors.green),
                            onPressed: () => _editFlat(flat),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SectionTitle('Route fares (${routes.length})'),
                  if (routes.isEmpty) const NoteBox(text: 'No route fares for this mode yet.'),
                  for (final t in routes)
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.fareEdit, arguments: t),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${t.from} <-> ${t.to}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                SourceTag(t.source),
                              ],
                            ),
                          ),
                          Text(
                            t.fare == null ? "Rider's discretion" : FareService.money(t.fare!),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.fareEdit),
                icon: const Icon(Icons.add),
                label: const Text('Add fare'),
              ),
            ),
          ],
        );
      },
    );
  }
}
