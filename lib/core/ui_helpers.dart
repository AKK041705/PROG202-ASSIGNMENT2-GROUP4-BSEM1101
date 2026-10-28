import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shows a short message at the bottom of the screen.
void showMessage(BuildContext context, String text, {bool error = false}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: error ? AppColors.red : AppColors.greenDark,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Asks the user to confirm an action. Returns true when they choose Yes.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Yes',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Standard text field look used by every form.
InputDecoration appInputDecoration(String label, IconData icon, {String? hint}) {
  OutlineInputBorder border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(icon, color: AppColors.textSecondary),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    enabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.green, 2),
    errorBorder: border(AppColors.red),
    focusedErrorBorder: border(AppColors.red, 2),
    labelStyle: TextStyle(color: AppColors.textSecondary),
    floatingLabelStyle: TextStyle(color: AppColors.green),
  );
}
