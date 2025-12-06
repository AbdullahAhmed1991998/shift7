import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';

class CustomEmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String hintText;

  const CustomEmailInputField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppFormField(
      controller: controller,
      prefixIcon: EvaIcons.email,
      borderRadius: 12.r,
      cursorColor: AppColors.secondaryColor,
      cursorHeight: 20.h,
      autofocus: false,
      hintText: hintText,
      hintStyle: AppTextStyle.styleGrey12Bold,
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
    );
  }
}
