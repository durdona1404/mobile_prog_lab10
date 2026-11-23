import 'package:flutter/material.dart';
import '../services/image_sources.dart';
import '../services/classifier.dart';
import '../services/history_store.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'model_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.classifier, required this.store});

  final Classifier classifier;
  final HistoryStore store;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final ImageSources _sources = ImageSources();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            classifier: widget.classifier,
            store: widget.store,
            sources: _sources,
          ),
          HistoryScreen(store: widget.store),
          ModelScreen(classifier: widget.classifier),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_outlined),
            selectedIcon: Icon(Icons.memory),
            label: 'Model',
          ),
        ],
      ),
    );
  }
}