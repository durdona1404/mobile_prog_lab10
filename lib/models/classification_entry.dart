import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/classifier.dart';

enum InputSource {
  camera('Camera', Icons.photo_camera_outlined),
  gallery('Gallery', Icons.photo_library_outlined),
  download('Download', Icons.cloud_download_outlined);

  const InputSource(this.label, this.icon);

  final String label;
  final IconData icon;
}

class ClassificationEntry {
  ClassificationEntry({
    required this.bytes,
    required this.predictions,
    required this.source,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  final Uint8List bytes;
  final List<Prediction> predictions;
  final InputSource source;
  final DateTime time;

  Prediction get top => predictions.first;
}