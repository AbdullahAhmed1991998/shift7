import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

String normalizeDigits(String input) {
  const map = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };
  return input.split('').map((c) => map[c] ?? c).join();
}

String phoneErrorMessage(BuildContext context, String dialCode) {
  switch (dialCode) {
    case '+962':
      return 'jordan_phone_error'.tr();
    case '+20':
      return 'egypt_phone_error'.tr();
    case '+966':
      return 'saudi_phone_error'.tr();
    default:
      return 'enter_valid_phone'.tr();
  }
}

bool validatePhoneByCountry({required String e164, required String dialCode}) {
  final normalized = normalizeDigits(e164);
  final patterns = <String, RegExp>{
    '+962': RegExp(r'^\+9627\d{8}$'),
    '+20': RegExp(r'^\+201[0125]\d{8}$'),
    '+966': RegExp(r'^\+9665\d{8}$'),
  };
  final reg = patterns[dialCode];
  if (reg != null) {
    return reg.hasMatch(normalized);
  }
  return normalized.startsWith(dialCode) &&
      normalized.length >= dialCode.length + 8;
}
