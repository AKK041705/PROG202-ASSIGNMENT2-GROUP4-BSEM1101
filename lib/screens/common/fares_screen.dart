import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/fare_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/fare_tile.dart';
import '../../widgets/place_picker_field.dart';
import '../../widgets/responsive_body.dart';

const String _disclaimer =
    'Fares tagged "Official price list" come from the supplied price lists. '
    '"Published sample" fares come from news reports. "Simulated estimate" fares are '
    'calculated by this prototype and are NOT official. Always confirm with the latest '
    'notice from the Ministry of Transport and Aviation.';

/// Search a route and see every transport mode's fare, as a list or as a
/// side-by-side comparison. Used inside the bottom navigation bar, from the home
/// screen, and for guests.
class FaresView extends StatefulWidget {
  const FaresView({super.key, this.startOnCompare = false, this.initialRoute});

  final bool startOnCompare;

  /// Optional [pickup, destination] to start with.
  final List<String>? initialRoute;

  @override
  State<FaresView> createState() => _FaresViewState();
}

class _FaresViewState extends State<FaresView> {
  late String? _pickup = widget.initialRoute?[0] ?? 'Lumley';
  late String? _destination = widget.initialRoute?[1] ?? 'Wilberforce';
  late bool _compare = widget.startOnCompare;

  void _swap() {
    setState(() {
      final temp = _pickup;
      _pickup = _destination;
      _destination = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final ready = _pickup != null && _destination != null && _pickup != _destination;
        return ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlacePickerField(
                label: 'Pickup',
                value: _pickup,
                icon: Icons.trip_origin,
                onChanged: (v) => setState(() => _pickup = v),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Swap pickup and destination',
                  onPressed: _swap,
                  icon: Icon(Icons.swap_vert, color: AppColors.green),
                ),
              ),
              PlacePickerField(
                label: 'Destination',
                value: _destination,
                icon: Icons.flag_outlined,
                onChanged: (v) => setState(() => _destination = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ViewToggle(
                      label: 'Fares list',
                      icon: Icons.view_list,
                      selected: !_compare,
                      onTap: () => setState(() => _compare = false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ViewToggle(
                      label: 'Compare',
                      icon: Icons.grid_view,
                      selected: _compare,
                      onTap: () => setState(() => _compare = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_pickup != null && _destination != null && _pickup == _destination)
                NoteBox(
                  text: 'Pickup and destination cannot be the same place.',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.red,
                  background: AppColors.redTint,
                )
              else if (!ready)
                const EmptyState(
                  icon: Icons.alt_route,
                  title: 'Choose your route',
                  message: 'Pick a pickup place and a destination to see the fares for every transport mode.',
                )
              else ...[
                SectionTitle('${_pickup!} to ${_destination!}'),
                Text(
                  'Approximate distance: ${FareService.distanceKm(_pickup!, _destination!)} km (simulated)',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                if (_compare) _buildCompare(state) else _buildList(state),
                const SizedBox(height: 8),
                const NoteBox(
                  text: 'The app does not rank options. A cheaper mode may offer a different level of service.',
                ),
                const SizedBox(height: 10),
                NoteBox(
                  text: _disclaimer,
                  icon: Icons.gavel,
                  color: AppColors.amber,
                  background: AppColors.amberTint,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(AppState state) {
    return Column(
      children: [
        for (final mode in FareService.fareModes)
          FareTile(mode: mode, quote: state.quote(mode, _pickup!, _destination!)),
      ],
    );
  }

  Widget _buildCompare(AppState state) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: [
        for (final mode in FareService.fareModes)
          CompareCard(mode: mode, quote: state.quote(mode, _pickup!, _destination!)),
      ],
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return PrimaryButton(label: label, icon: icon, onPressed: onTap);
    }
    return SecondaryButton(label: label, icon: icon, onPressed: onTap);
  }
}

/// Stand-alone page version (own app bar), used for guests and quick actions.
class FaresScreen extends StatelessWidget {
  const FaresScreen({
    super.key,
    this.title = 'Transportation fares',
    this.startOnCompare = false,
    this.initialRoute,
  });

  final String title;
  final bool startOnCompare;
  final List<String>? initialRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: title),
      body: SafeArea(
        child: FaresView(startOnCompare: startOnCompare, initialRoute: initialRoute),
      ),
    );
  }
}
