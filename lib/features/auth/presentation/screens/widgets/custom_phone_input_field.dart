import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomPhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final String hintText;
  final ValueChanged<String> onFullNumberChanged;
  final ValueChanged<String> onDialCodeChanged;
  final String? initialFullNumber;
  final String? defaultIsoCode;

  const CustomPhoneInputField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hintText,
    required this.onFullNumberChanged,
    required this.onDialCodeChanged,
    this.initialFullNumber,
    this.defaultIsoCode,
  });

  @override
  State<CustomPhoneInputField> createState() => _CustomPhoneInputFieldState();
}

class _CountryOption {
  final String isoCode;
  final String dialCode;
  final String nameAr;
  final String nameEn;
  final String flag;

  const _CountryOption({
    required this.isoCode,
    required this.dialCode,
    required this.nameAr,
    required this.nameEn,
    required this.flag,
  });
}

class _CustomPhoneInputFieldState extends State<CustomPhoneInputField> {
  static const List<_CountryOption> _arabCountries = [
    _CountryOption(
      isoCode: 'JO',
      dialCode: '962',
      nameAr: 'الأردن',
      nameEn: 'Jordan',
      flag: '🇯🇴',
    ),
    _CountryOption(
      isoCode: 'EG',
      dialCode: '20',
      nameAr: 'مصر',
      nameEn: 'Egypt',
      flag: '🇪🇬',
    ),
    _CountryOption(
      isoCode: 'SA',
      dialCode: '966',
      nameAr: 'السعودية',
      nameEn: 'Saudi Arabia',
      flag: '🇸🇦',
    ),
    _CountryOption(
      isoCode: 'AE',
      dialCode: '971',
      nameAr: 'الإمارات',
      nameEn: 'UAE',
      flag: '🇦🇪',
    ),
    _CountryOption(
      isoCode: 'KW',
      dialCode: '965',
      nameAr: 'الكويت',
      nameEn: 'Kuwait',
      flag: '🇰🇼',
    ),
    _CountryOption(
      isoCode: 'QA',
      dialCode: '974',
      nameAr: 'قطر',
      nameEn: 'Qatar',
      flag: '🇶🇦',
    ),
    _CountryOption(
      isoCode: 'BH',
      dialCode: '973',
      nameAr: 'البحرين',
      nameEn: 'Bahrain',
      flag: '🇧🇭',
    ),
    _CountryOption(
      isoCode: 'OM',
      dialCode: '968',
      nameAr: 'عُمان',
      nameEn: 'Oman',
      flag: '🇴🇲',
    ),
    _CountryOption(
      isoCode: 'IQ',
      dialCode: '964',
      nameAr: 'العراق',
      nameEn: 'Iraq',
      flag: '🇮🇶',
    ),
    _CountryOption(
      isoCode: 'SY',
      dialCode: '963',
      nameAr: 'سوريا',
      nameEn: 'Syria',
      flag: '🇸🇾',
    ),
    _CountryOption(
      isoCode: 'LB',
      dialCode: '961',
      nameAr: 'لبنان',
      nameEn: 'Lebanon',
      flag: '🇱🇧',
    ),
    _CountryOption(
      isoCode: 'YE',
      dialCode: '967',
      nameAr: 'اليمن',
      nameEn: 'Yemen',
      flag: '🇾🇪',
    ),
    _CountryOption(
      isoCode: 'PS',
      dialCode: '970',
      nameAr: 'فلسطين',
      nameEn: 'Palestine',
      flag: '🇵🇸',
    ),
    _CountryOption(
      isoCode: 'SD',
      dialCode: '249',
      nameAr: 'السودان',
      nameEn: 'Sudan',
      flag: '🇸🇩',
    ),
    _CountryOption(
      isoCode: 'DZ',
      dialCode: '213',
      nameAr: 'الجزائر',
      nameEn: 'Algeria',
      flag: '🇩🇿',
    ),
    _CountryOption(
      isoCode: 'MA',
      dialCode: '212',
      nameAr: 'المغرب',
      nameEn: 'Morocco',
      flag: '🇲🇦',
    ),
    _CountryOption(
      isoCode: 'TN',
      dialCode: '216',
      nameAr: 'تونس',
      nameEn: 'Tunisia',
      flag: '🇹🇳',
    ),
    _CountryOption(
      isoCode: 'LY',
      dialCode: '218',
      nameAr: 'ليبيا',
      nameEn: 'Libya',
      flag: '🇱🇾',
    ),
  ];

  late _CountryOption _selectedCountry;
  bool _initializedFromInitial = false;

  @override
  void initState() {
    super.initState();
    _initFromInitial();
  }

  @override
  void didUpdateWidget(covariant CustomPhoneInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFullNumber != widget.initialFullNumber ||
        oldWidget.defaultIsoCode != widget.defaultIsoCode) {
      _initFromInitial();
      setState(() {});
    }
  }

  void _initFromInitial() {
    final defaultIso = widget.defaultIsoCode ?? 'JO';
    _selectedCountry = _arabCountries.firstWhere(
      (c) => c.isoCode == defaultIso,
      orElse: () => _arabCountries.first,
    );

    final v = widget.initialFullNumber?.trim();
    if (v != null && v.isNotEmpty) {
      if (v.startsWith('+')) {
        for (final c in _arabCountries) {
          final prefix = '+${c.dialCode}';
          if (v.startsWith(prefix)) {
            _selectedCountry = c;
            final local = v.substring(prefix.length);
            widget.controller.text = local;
            _initializedFromInitial = true;
            _notifyChange();
            return;
          }
        }
        widget.controller.text = v;
        _initializedFromInitial = true;
        _notifyChange();
      } else {
        widget.controller.text = v;
        _initializedFromInitial = true;
        _notifyChange();
      }
    } else {
      _initializedFromInitial = false;
      widget.controller.clear();
    }
  }

  String _normalizeDigitsToEnglish(String input) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const easternIndic = '۰۱۲۳۴۵۶۷۸۹';
    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      final i1 = arabicIndic.indexOf(ch);
      final i2 = easternIndic.indexOf(ch);
      if (i1 != -1) {
        buffer.write(i1.toString());
      } else if (i2 != -1) {
        buffer.write(i2.toString());
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  void _notifyChange() {
    final raw = widget.controller.text.trim();
    final normalized = _normalizeDigitsToEnglish(raw);
    final full = '+${_selectedCountry.dialCode}$normalized';
    widget.onDialCodeChanged('+${_selectedCountry.dialCode}');
    widget.onFullNumberChanged(full);
  }

  Future<void> _openCountryBottomSheet() async {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    final selected = await showModalBottomSheet<_CountryOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: EdgeInsets.only(top: 60.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    isArabic ? 'اختر الدولة' : 'Select country',
                    style: AppTextStyle.styleBlack16Bold,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: ListView.separated(
                  itemCount: _arabCountries.length,
                  separatorBuilder:
                      (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final c = _arabCountries[index];
                    final isSelected = c.isoCode == _selectedCountry.isoCode;
                    return ListTile(
                      leading: Text(c.flag, style: TextStyle(fontSize: 22.sp)),
                      title: Text(
                        isArabic ? c.nameAr : c.nameEn,
                        style: AppTextStyle.styleBlack16W500,
                      ),
                      subtitle: Text(
                        '+${c.dialCode}',
                        style: AppTextStyle.styleGrey12Bold,
                      ),
                      trailing:
                          isSelected
                              ? Icon(
                                Icons.check_circle,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              )
                              : null,
                      onTap: () {
                        Navigator.of(context).pop(c);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCountry = selected;
      });
      _notifyChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Row(
          children: [
            Icon(
              Icons.phone_rounded,
              color: AppColors.secondaryColor,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Container(width: 1.w, height: 28.h, color: Colors.grey.shade300),
            SizedBox(width: 8.w),
            InkWell(
              onTap: widget.enabled ? _openCountryBottomSheet : null,
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCountry.flag,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '+${_selectedCountry.dialCode}',
                      style: AppTextStyle.styleBlack16W500,
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.secondaryColor,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(width: 1.w, height: 28.h, color: Colors.grey.shade300),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: widget.controller,
                enabled: widget.enabled,
                keyboardType: TextInputType.phone,
                cursorColor: AppColors.secondaryColor,
                style: AppTextStyle.styleBlack16W500,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppTextStyle.styleGrey12Bold,
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 12.h,
                  ),
                ),
                onChanged: (_) {
                  if (!_initializedFromInitial) {
                    _initializedFromInitial = true;
                  }
                  _notifyChange();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
