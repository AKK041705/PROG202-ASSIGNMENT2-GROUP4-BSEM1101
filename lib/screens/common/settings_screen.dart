import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_palette.dart';
import '../../core/app_preferences.dart';
import '../../services/currency_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';

/// Appearance (light or dark, accent colour) and the currency shown beside prices.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = AppPreferences.instance;
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        final example = CurrencyService.secondary(12.0, prefs.currency);
        return Scaffold(
          appBar: const AppTopBar(title: 'Settings'),
          body: SafeArea(
            child: ResponsiveBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle('Appearance'),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      secondary: Icon(
                        prefs.dark ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.green,
                      ),
                      title: const Text('Dark mode', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        prefs.dark ? 'Dark theme is on' : 'Light theme is on',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      value: prefs.dark,
                      onChanged: prefs.setDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Accent colour', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 14,
                          runSpacing: 12,
                          children: [
                            for (final option in AccentOption.values)
                              _AccentDot(
                                option: option,
                                selected: option == prefs.accent,
                                onTap: () => prefs.setAccent(option),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SectionTitle('Prices'),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Also show prices in',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Visiting from overseas? Choose your currency to see an approximate price next to every fare in leones (NLe).',
                          style: TextStyle(color: AppColors.textSecondary, height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final code in CurrencyService.options)
                              ChoiceChip(
                                label: Text(code),
                                selected: prefs.currency == code,
                                selectedColor: AppColors.green,
                                backgroundColor: AppColors.surface,
                                side: BorderSide(color: AppColors.border),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: prefs.currency == code ? Colors.white : AppColors.textPrimary,
                                ),
                                showCheckmark: false,
                                onSelected: (_) {
                                  prefs.setCurrency(code);
                                  AppState.instance.setUserCurrency(code);
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          example == null
                              ? 'Example: NLe 12.0 (leones only)'
                              : 'Example: NLe 12.0, $example',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  NoteBox(
                    text: 'Exchange rates are Bank of Sierra Leone reference rates of '
                        '${CurrencyService.ratesDate}. They are indicative only and change every day, '
                        'so confirm the real rate at a bank or exchange bureau.',
                    icon: Icons.currency_exchange,
                    color: AppColors.amber,
                    background: AppColors.amberTint,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AccentDot extends StatelessWidget {
  const _AccentDot({required this.option, required this.selected, required this.onTap});

  final AccentOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: option.swatch,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.textPrimary : AppColors.border,
                width: selected ? 3 : 1,
              ),
            ),
            child: selected ? const Icon(Icons.check, color: Colors.white) : null,
          ),
          const SizedBox(height: 4),
          Text(option.label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
