import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../models/classification_entry.dart';
import '../services/classifier.dart';
import '../services/classify_flow.dart';
import '../services/history_store.dart';
import '../services/image_sources.dart';
import '../theme/app_theme.dart';
import '../widgets/entry_tile.dart';
import 'download_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.classifier,
    required this.store,
    required this.sources,
  });

  final Classifier classifier;
  final HistoryStore store;
  final ImageSources sources;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _busy = false;

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(
    InputSource source,
    Future<Uint8List?> Function() getBytes,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final bytes = await getBytes();
      if (bytes == null) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final entry = classifyBytes(
        classifier: widget.classifier,
        store: widget.store,
        bytes: bytes,
        source: source,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen(entry: entry)),
      );
    } on PlatformException {
      _show('The camera or gallery is not available. Check the permission in the phone settings.');
    } on FormatException {
      _show('This file is not a picture the app can read.');
    } catch (e) {
      _show('Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _openDownload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DownloadScreen(
          classifier: widget.classifier,
          store: widget.store,
          sources: widget.sources,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _ActionCard(
                  icon: InputSource.camera.icon,
                  title: 'Take a photo',
                  subtitle: 'Use the phone camera',
                  onTap: _busy
                      ? null
                      : () => _run(
                            InputSource.camera,
                            widget.sources.fromCamera,
                          ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ActionCard(
                  icon: InputSource.gallery.icon,
                  title: 'Choose from gallery',
                  subtitle: 'Pick an existing picture',
                  onTap: _busy
                      ? null
                      : () => _run(
                            InputSource.gallery,
                            widget.sources.fromGallery,
                          ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ActionCard(
                  icon: InputSource.download.icon,
                  title: 'Download an image',
                  subtitle: 'Paste an image address',
                  onTap: _busy ? null : _openDownload,
                ),
                const SizedBox(height: AppSpacing.lg),
                ListenableBuilder(
                  listenable: widget.store,
                  builder: (context, _) {
                    final latest = widget.store.latest;
                    if (latest == null) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latest result',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),
                        EntryTile(entry: latest),
                      ],
                    );
                  },
                ),
              ],
            ),
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        enabled: onTap != null,
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