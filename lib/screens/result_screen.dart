import 'package:flutter/material.dart';

import '../models/classification_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/prediction_row.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.entry});

  final ClassificationEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          Icon(entry.source.icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Center(
            child: Text(entry.source.label, style: theme.textTheme.labelLarge),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxImageHeight),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                child: Image.memory(entry.bytes, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  for (var i = 0; i < entry.predictions.length; i++)
                    PredictionRow(
                      prediction: entry.predictions[i],
                      emphasised: i == 0,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}