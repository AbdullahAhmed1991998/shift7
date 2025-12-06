import 'package:easy_localization/easy_localization.dart';

class EditProfileValidators {
  String? validateName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'valNameRequired'.tr();
    if (s.length < 3) return 'valNameMin3'.tr();
    return null;
  }

  String? validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'valEmailRequired'.tr();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(s)) return 'valEmailInvalid'.tr();
    return null;
  }

  String? validatePassword(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;
    if (s.length < 6) return 'valPasswordMin6'.tr();
    return null;
  }
}
