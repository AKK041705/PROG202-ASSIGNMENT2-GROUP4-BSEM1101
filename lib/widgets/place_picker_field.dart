import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../core/ui_helpers.dart';

/// A form field that opens the place search screen when tapped and shows the
/// chosen place. (A read-only TextFormField, so the whole field is tappable.)
class PlacePickerField extends StatefulWidget {
  const PlacePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon = Icons.place_outlined,
    this.required = true,
  });

  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final bool required;

  @override
  State<PlacePickerField> createState() => _PlacePickerFieldState();
}

class _PlacePickerFieldState extends State<PlacePickerField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value ?? '');

  @override
  void didUpdateWidget(PlacePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openPicker() async {
    FocusScope.of(context).unfocus();
    // The search screen sends the chosen place back with Navigator.pop.
    final picked = await Navigator.pushNamed(
      context,
      AppRoutes.placePicker,
      arguments: widget.label,
    );
    if (picked is String && mounted) {
      _controller.text = picked;
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      showCursor: false,
      onTap: _openPicker,
      validator: (text) {
        if (widget.required && (text == null || text.isEmpty)) {
          return 'Choose a place';
        }
        return null;
      },
      style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      decoration: appInputDecoration(widget.label, widget.icon, hint: 'Tap to choose').copyWith(
        suffixIcon: Icon(Icons.search, color: AppColors.textSecondary),
      ),
    );
  }
}
