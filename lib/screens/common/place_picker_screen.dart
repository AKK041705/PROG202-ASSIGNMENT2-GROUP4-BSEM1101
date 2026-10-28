import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/ui_helpers.dart';
import '../../data/place_data.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';

/// Search screen for choosing a place. Returns the chosen place name to the
/// screen that opened it (data passed back with Navigator.pop).
class PlacePickerScreen extends StatefulWidget {
  const PlacePickerScreen({super.key, required this.title});

  final String title;

  @override
  State<PlacePickerScreen> createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _areaLabel(Place p) {
    switch (p.area) {
      case 'City':
        return 'Freetown';
      case 'Peninsula':
        return 'Western Area';
      case 'Lungi':
        return 'Lungi';
      case 'North':
        return 'North';
      default:
        return 'South and East';
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = kPlaces.where((p) => p.name.toLowerCase().contains(q)).toList();
    return Scaffold(
      appBar: AppTopBar(title: widget.title),
      body: SafeArea(
        child: ResponsiveBody(
          scroll: false,
          child: Column(
            children: [
              // A plain TextField, used here for searching (not inside a Form).
              TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: appInputDecoration('Search places', Icons.search).copyWith(
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No place found',
                        message: 'Try a shorter name, for example "lum" for Lumley.',
                      )
                    : ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final place = results[index];
                          return ListTile(
                            leading: Icon(Icons.place_outlined, color: AppColors.green),
                            title: Text(place.name),
                            subtitle: Text(_areaLabel(place)),
                            onTap: () => Navigator.pop(context, place.name),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
