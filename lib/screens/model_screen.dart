import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../theme/app_theme.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key, required this.classifier});

  final Classifier classifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = Classifier.inputSize;
    return Scaffold(
      appBar: AppBar(title: const Text('Model')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Classes'),
                  trailing: Text('${classifier.labels.length}'),
                ),
                ListTile(
                  title: const Text('Input size'),
                  trailing: Text('$size x $size'),
                ),
                const ListTile(
                  title: Text('Model file'),
                  trailing: Text('model_unquant.tflite'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Labels', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final label in classifier.labels) Chip(label: Text(label)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Design credit', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                '${DesignCredit.name} by ${DesignCredit.author}\n${DesignCredit.link}\nLicence: ${DesignCredit.licence}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}