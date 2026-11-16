import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'services/classifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final classifier = await Classifier.load();
  final data = await rootBundle.load('assets/model/sample.jpg');
  final results = classifier.classify(data.buffer.asUint8List());
  var total = 0.0;
  for (final p in results) {
    total += p.confidence;
    debugPrint('${p.label}: ${(p.confidence * 100).toStringAsFixed(1)} %');
  }
  debugPrint('Sum: ${total.toStringAsFixed(3)}');
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('Check the console'))),
    ),
  );
}
