import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_preferences.dart';
import '../services/currency_service.dart';
import '../data/fare_service.dart';
import '../models/models.dart';
import 'app_card.dart';

IconData modeIcon(String mode) {
  if (mode.startsWith('Taxi')) return Icons.local_taxi;
  switch (mode) {
    case 'Okada':
      return Icons.two_wheeler;
    case 'Kekeh':
      return Icons.electric_rickshaw;
    case 'Poda-poda':
      return Icons.airport_shuttle;
    case 'Bus':
      return Icons.directions_bus;
    default:
      return Icons.directions_car;
  }
}

/// Label that tells the user where a fare comes from.
class SourceTag extends StatelessWidget {
  const SourceTag(this.source, {super.key});

  final String source;

  @override
  Widget build(BuildContext context) {
    final simulated = source == 'Simulated estimate';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: simulated ? AppColors.amberTint : AppColors.successTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        source,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: simulated ? AppColors.amber : AppColors.success,
        ),
      ),
    );
  }
}

/// One row on the fares screen: mode, fare, fare type and source.
class FareTile extends StatelessWidget {
  const FareTile({super.key, required this.mode, required this.quote});

  final String mode;
  final FareQuote quote;

  @override
  Widget build(BuildContext context) {
    final available = quote.isAvailable;
    final other = CurrencyService.secondary(quote.amount, AppPreferences.instance.currency);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: available ? AppColors.greenTint : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              modeIcon(mode),
              color: available ? AppColors.green : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mode, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 2),
                if (available) ...[
                  Text(quote.type, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      SourceTag(quote.source),
                      if (quote.flat)
                        Text('one short trip',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ] else
                  Text(quote.unavailableReason ?? '',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  FareService.amountText(quote),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: available ? 17 : 13,
                    fontWeight: FontWeight.w800,
                    color: available ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                if (available && other != null)
                  Text(
                    other,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact card used in the compare grid.
class CompareCard extends StatelessWidget {
  const CompareCard({super.key, required this.mode, required this.quote});

  final String mode;
  final FareQuote quote;

  @override
  Widget build(BuildContext context) {
    final available = quote.isAvailable;
    final other = CurrencyService.secondary(quote.amount, AppPreferences.instance.currency);
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(modeIcon(mode), color: available ? AppColors.green : AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(mode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          Text(
            available ? FareService.amountText(quote) : 'Not available',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: available ? 20 : 15,
              fontWeight: FontWeight.w800,
              color: available ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          if (available)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (other != null)
                  Text(other, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text(quote.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                SourceTag(quote.source),
              ],
            )
          else
            Text(quote.unavailableReason ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
