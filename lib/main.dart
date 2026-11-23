import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'services/classifier.dart';
import 'services/history_store.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final HistoryStore _store = HistoryStore();
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
        _error = 'The model could not be loaded. Expected these files in the '
            'app assets:\nassets/model/model_unquant.tflite\n'
            'assets/model/labels.txt\n\nDetails: $e';
      });
    }
  }

  @override
  void dispose() {
    _classifier?.close();
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Finder',
      theme: AppTheme.light(),
      home: WelcomeScreen(
        classifier: _classifier,
        error: _error,
        store: _store,
        onRetry: _load,
      ),
    );
  }
}