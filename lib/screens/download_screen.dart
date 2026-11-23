import 'package:flutter/material.dart';

import '../models/classification_entry.dart';
import '../services/classifier.dart';
import '../services/classify_flow.dart';
import '../services/history_store.dart';
import '../services/image_sources.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({
    super.key,
    required this.classifier,
    required this.store,
    required this.sources,
  });

  final Classifier classifier;
  final HistoryStore store;
  final ImageSources sources;

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });

    String? error;
    ClassificationEntry? entry;
    try {
      final bytes = await widget.sources.fromUrl(_controller.text);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      entry = classifyBytes(
        classifier: widget.classifier,
        store: widget.store,
        bytes: bytes,
        source: InputSource.download,
      );
    } on ImageSourceException catch (e) {
      error = e.message;
    } on FormatException {
      error = 'The download is not a picture the app can read.';
    } catch (e) {
      error = 'Something went wrong: $e';
    }

    if (!mounted) return;
    if (entry != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResultScreen(entry: entry!)),
      );
      return;
    }
    setState(() {
      _loading = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Download an image')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Paste the address of a picture. It must end up at an image file, not a web page.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            enabled: !_loading,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            autocorrect: false,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: 'Image address',
              hintText: 'https://...',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: const Text('Download and classify'),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_loading) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: AppSpacing.sm),
            Text('Downloading...', style: theme.textTheme.bodyMedium),
          ],
          if (_error != null)
            Text(
              _error!,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.error),
            ),
        ],
      ),
    );
  }
}