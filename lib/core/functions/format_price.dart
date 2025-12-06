import 'package:intl/intl.dart';

String _toLatinDigits(String input) {
  const arabicIndic = [
    '\u0660',
    '\u0661',
    '\u0662',
    '\u0663',
    '\u0664',
    '\u0665',
    '\u0666',
    '\u0667',
    '\u0668',
    '\u0669',
  ];
  const easternArabicIndic = [
    '\u06F0',
    '\u06F1',
    '\u06F2',
    '\u06F3',
    '\u06F4',
    '\u06F5',
    '\u06F6',
    '\u06F7',
    '\u06F8',
    '\u06F9',
  ];
  var out = input;
  for (var i = 0; i < 10; i++) {
    out = out.replaceAll(arabicIndic[i], '$i');
    out = out.replaceAll(easternArabicIndic[i], '$i');
  }
  return out;
}

double _parseAmount(String text) {
  if (text.isEmpty) return 0.0;
  final s = _toLatinDigits(text).trim();
  final onlyNums = s.replaceAll(RegExp(r'[^\d\.,\-+]'), '');
  if (onlyNums.isEmpty) return 0.0;
  final lastDot = onlyNums.lastIndexOf('.');
  final lastComma = onlyNums.lastIndexOf(',');
  String normalized;
  if (lastDot != -1 && lastComma != -1) {
    final decIsComma = lastComma > lastDot;
    if (decIsComma) {
      final withoutDots = onlyNums.replaceAll('.', '');
      final withDotDecimal = withoutDots.replaceFirstMapped(
        RegExp(r',(?!.*,)'),
        (_) => '.',
      );
      normalized = withDotDecimal.replaceAll(',', '');
    } else {
      normalized = onlyNums.replaceAll(',', '');
    }
  } else {
    final sep = lastDot != -1 ? '.' : (lastComma != -1 ? ',' : null);
    if (sep == null) {
      normalized = onlyNums;
    } else {
      final parts = onlyNums.split(sep);
      if (parts.length == 1) {
        normalized = onlyNums.replaceAll(',', '').replaceAll('.', '');
      } else {
        final decimals = parts.removeLast();
        final intPart = parts.join();
        normalized = '$intPart.$decimals';
      }
    }
  }
  return double.tryParse(normalized) ?? 0.0;
}

num _coerceToNum(Object? value) {
  if (value is num) return value;
  if (value is String) return _parseAmount(value);
  return 0;
}

String formatJod(Object? value, bool isArabic) {
  final amount = _coerceToNum(value);
  final number = NumberFormat(
    '#,##0.###',
    isArabic ? 'ar' : 'en',
  ).format(amount);
  return isArabic ? '$number دينار' : '$number JOD';
}
