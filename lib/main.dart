import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'services/classifier.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Classifier? _classifier;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final classifier = await Classifier.load();
      if (!mounted) {
        classifier.close();
        return;
      }
      setState(() => _classifier = classifier);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error =
            'The model could not be loaded. Expected these files in the '
            'app assets:\nassets/model/model_unquant.tflite\n'
            'assets/model/labels.txt\n\nDetails: $e';
      });
    }
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classifier = _classifier;
    final error = _error;
    return MaterialApp(
      home: classifier != null
          ? HomeScreen(classifier: classifier)
          : error != null
          ? ErrorScreen(message: error, onRetry: _load)
          : const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading the model...'),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.classifier});

  final Classifier classifier;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _output = 'Press a button';

  Future<void> _run(Future<Uint8List> Function() getBytes) async {
    try {
      final bytes = await getBytes();
      final results = widget.classifier.classify(bytes);
      setState(() {
        _output = [
          for (final p in results)
            '${p.label}: ${(p.confidence * 100).toStringAsFixed(1)} %',
        ].join('\n');
      });
    } on FormatException {
      setState(() {
        _output = 'This is not a picture I can read. Please choose a JPG or PNG image.';
      });
    } catch (e) {
      setState(() => _output = 'Something went wrong while classifying: $e');
    }
  }

  Future<Uint8List> _sample() async {
    final data = await rootBundle.load('assets/model/sample.jpg');
    return data.buffer.asUint8List();
  }

  Future<Uint8List> _textFile() async {
    return Uint8List.fromList(utf8.encode('this is a text file, not an image'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classifier test')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () => _run(_sample),
              child: const Text('Classify sample image'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _run(_textFile),
              child: const Text('Classify a text file (test)'),
            ),
            const SizedBox(height: 24),
            Text(_output),
          ],
        ),
      ),
    );
  }
}
