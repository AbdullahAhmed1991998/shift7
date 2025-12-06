import 'package:dio/dio.dart';

String extractErrorMessage(DioException e) {
  try {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) {
        return data['message'] as String;
      }
      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;
        final List<String> messages = [];
        errors.forEach((field, value) {
          if (value is List) {
            messages.addAll(value.map((e) => e.toString()));
          } else {
            messages.add(value.toString());
          }
        });
        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
    }
  } catch (_) {}
  return 'Something went wrong. Please try again.';
}
