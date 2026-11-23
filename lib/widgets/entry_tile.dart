import 'package:flutter/material.dart';

import '../models/classification_entry.dart';
import '../screens/result_screen.dart';
import '../theme/app_theme.dart';
import 'format.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});

  final ClassificationEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.sm),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius / 2),
          child: Image.memory(
            entry.bytes,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            cacheWidth: 112,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image_outlined),
          ),
        ),
        title: Text(entry.top.label, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${formatPercent(entry.top.confidence)} · ${entry.source.label}',
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Icon(entry.source.icon, color: theme.colorScheme.primary),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultScreen(entry: entry)),
        ),
      ),
    );
  }
}