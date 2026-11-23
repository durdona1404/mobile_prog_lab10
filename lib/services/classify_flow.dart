import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../models/classification_entry.dart';
import 'classifier.dart';
import 'history_store.dart';

ClassificationEntry classifyBytes({
  required Classifier classifier,
  required HistoryStore store,
  required Uint8List bytes,
  required InputSource source,
}) {
  final watch = Stopwatch()..start();
  final predictions = classifier.classify(bytes);
  watch.stop();
  debugPrint('classify took ${watch.elapsedMilliseconds} ms');

  final entry = ClassificationEntry(
    bytes: bytes,
    predictions: predictions,
    source: source,
  );
  store.add(entry);
  return entry;
}