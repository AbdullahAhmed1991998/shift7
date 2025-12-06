import 'package:flutter/foundation.dart';

extension ImageUrlSanitizer on String {
  String get cleanedImageUrl {
    final raw = trim();
    if (raw.isEmpty) return raw;

    try {
      final encoded = Uri.encodeFull(raw);
      return encoded;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ImageUrlSanitizer error for: $raw, error: $e');
      }
      return raw;
    }
  }
}
