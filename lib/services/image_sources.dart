import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageSourceException implements Exception {
  const ImageSourceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ImageSources {
  final _picker = ImagePicker();

  Future<Uint8List?> fromCamera() async {
    final shot = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
    );
    return shot == null ? null : await shot.readAsBytes();
  }

  Future<Uint8List?> fromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
    );
    return picked == null ? null : await picked.readAsBytes();
  }

  Future<Uint8List> fromUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    final valid = uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https');
    if (!valid) {
      throw const ImageSourceException(
        'That is not a valid web address. It should start with https://',
      );
    }

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw ImageSourceException(
          'The server answered ${response.statusCode}, so no picture was downloaded.',
        );
      }
      final type = response.headers['content-type'] ?? '';
      if (!type.startsWith('image/')) {
        throw const ImageSourceException(
          'That address leads to a web page or file, not to a picture.',
        );
      }
      return response.bodyBytes;
    } on TimeoutException {
      throw const ImageSourceException(
        'The download took too long. Check your connection and try again.',
      );
    } on http.ClientException {
      throw const ImageSourceException(
        'No connection. Check your internet and try again.',
      );
    }
  }
}