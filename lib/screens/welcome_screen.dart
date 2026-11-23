import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../services/history_store.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.classifier,
    required this.error,
    required this.store,
    required this.onRetry,
  });

  final Classifier? classifier;
  final String? error;
  final HistoryStore store;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaded = classifier;
    final message = error;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      Icon(
                        Icons.center_focus_strong_outlined,
                        size: 56,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Fruit Finder',
                          style: theme.textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Take or choose a picture of a fruit and the app tells you which one it is, fully offline.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (loaded != null)
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            for (final label in loaded.labels)
                              Chip(label: Text(label)),
                          ],
                        ),
                      if (message != null)
                        Text(
                          message,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.colorScheme.error),
                        ),
                    ],
                  ),
                ),
              ),
              if (loaded == null && message == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text('Loading the model...',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              if (message != null)
                FilledButton(onPressed: onRetry, child: const Text('Try again')),
              if (loaded != null)
                FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          AppShell(classifier: loaded, store: store),
                    ),
                  ),
                  child: const Text('Get started'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}