import 'dart:convert';

bool asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.trim().toLowerCase();
    return s == '1' || s == 'true' || s == 'yes';
  }
  return false;
}

int asInt(dynamic v, {int fallback = 0}) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.trim()) ?? fallback;
  return fallback;
}

double? asDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.trim());
  return null;
}

DateTime? asDateTimeOrNull(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String && v.trim().isNotEmpty) {
    try {
      return DateTime.parse(v.trim());
    } catch (_) {
      return null;
    }
  }
  return null;
}

String asStringOrEmpty(dynamic v) {
  if (v == null) return '';
  if (v is String) return v.trim();
  return v.toString();
}

String? asNullableTrimmedString(dynamic v) {
  if (v == null) return null;
  if (v is String) {
    final s = v.trim();
    return s.isEmpty ? null : s;
  }
  return v.toString();
}

double asDouble(dynamic v, [double def = 0.0]) {
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.trim()) ?? def;
  return def;
}

String asString(dynamic v, [String def = '']) {
  if (v == null) return def;
  final s = v.toString().trim();
  return s.isEmpty ? def : s;
}

Map<String, dynamic> asMap(dynamic v) {
  if (v is Map) {
    return v.map((k, val) => MapEntry(k.toString(), val));
  }
  return <String, dynamic>{};
}

List<dynamic> asList(dynamic v) {
  if (v is List) return v;
  return const <dynamic>[];
}

Map<String, dynamic>? asMapStringDynamicOrNull(dynamic v) {
  if (v is Map) {
    return Map<String, dynamic>.from(v);
  }
  return null;
}

Map<String, dynamic> decodeJsonObject(String src) =>
    jsonDecode(src) as Map<String, dynamic>;
