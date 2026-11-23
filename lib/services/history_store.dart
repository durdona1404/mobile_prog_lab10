import 'package:flutter/foundation.dart';

import '../models/classification_entry.dart';

class HistoryStore extends ChangeNotifier {
  final List<ClassificationEntry> _entries = [];

  List<ClassificationEntry> get entries => List.unmodifiable(_entries);

  ClassificationEntry? get latest => _entries.isEmpty ? null : _entries.first;

  void add(ClassificationEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }
}