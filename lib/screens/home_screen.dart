import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/classification_entry.dart';
import '../services/classifier.dart';
import '../services/history_store.dart';
import '../theme/app_theme.dart';
import '../widgets/entry_tile.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.classifier, required this.store});

  final Classifier classifier;
  final HistoryStore store;

  Future<void> _runPlaceholder(
      BuildContext context, InputSource source) async {
    try {
      final data = await rootBundle.load('assets/model/sample.jpg');
      final bytes = data.buffer.asUint8List();
      final entry = ClassificationEntry(
        bytes: bytes,
        predictions: classifier.classify(bytes),
        source: source,
      );
      store.add(entry);
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen(entry: entry)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not classify this picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _ActionCard(
            icon: InputSource.camera.icon,
            title: 'Take a photo',
            subtitle: 'Use the phone camera',
            onTap: () => _runPlaceholder(context, InputSource.camera),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionCard(
            icon: InputSource.gallery.icon,
            title: 'Choose from gallery',
            subtitle: 'Pick an existing picture',
            onTap: () => _runPlaceholder(context, InputSource.gallery),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionCard(
            icon: InputSource.download.icon,
            title: 'Download an image',
            subtitle: 'Paste an image address',
            onTap: () => _runPlaceholder(context, InputSource.download),
          ),
          const SizedBox(height: AppSpacing.lg),
          ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final latest = store.latest;
              if (latest == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latest result', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  EntryTile(entry: latest),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Icon(icon, size: 32, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}