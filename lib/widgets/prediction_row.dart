import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../theme/app_theme.dart';
import 'format.dart';

class PredictionRow extends StatelessWidget {
  const PredictionRow({
    super.key,
    required this.prediction,
    required this.emphasised,
  });

  final Prediction prediction;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style =
        emphasised ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              prediction.label,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.barHeight),
              child: LinearProgressIndicator(
                value: prediction.confidence.clamp(0.0, 1.0).toDouble(),
                minHeight: AppTheme.barHeight,
                color: emphasised
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 64,
            child: Text(
              formatPercent(prediction.confidence),
              style: style,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}